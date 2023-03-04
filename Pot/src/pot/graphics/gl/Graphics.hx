package pot.graphics.gl;

import js.lib.Uint32Array;
import js.lib.Int32Array;
import pot.graphics.gl.low.BufferType;
import js.lib.Float32Array;
import pot.graphics.gl.low.IntBuffer;
import pot.graphics.gl.low.FloatBuffer;
import pot.graphics.gl.low.TransformFeedback;
import pot.graphics.gl.low.ShapeMode;
import haxe.ds.Vector;
import js.html.CanvasElement;
import js.html.webgl.GL2;
import js.lib.Error;
import muun.la.Mat3;
import muun.la.Mat4;
import muun.la.Vec2;
import muun.la.Vec3;
import muun.la.Vec4;
import pot.graphics.bitmap.BitmapSource;
import pot.graphics.gl.shader.Consts;
import pot.graphics.gl.shader.DefaultShader;
import pot.graphics.gl.shader.DefaultShaderTextured;

/**
 * ...
 */
class Graphics {
	final canvas:CanvasElement;
	final gl:GL2;

	final localObj:Object;
	final localObjWriter:ObjectWriter;
	final tf:TransformFeedback;

	public final defaultUniformMap:UniformMap = [];

	var cameraFov:Float;
	var cameraFovMode:FovMode;
	var cameraNear:Float;
	var cameraFar:Float;
	var cameraSet:Bool = false;
	final defaultCameraPos:Vec3 = Vec3.zero;
	final cameraPos:Vec3 = Vec3.zero;
	final cameraAt:Vec3 = Vec3.zero;
	final cameraUp:Vec3 = Vec3.zero;
	var screenWidth:Float;
	var screenHeight:Float;

	var defaultShader:Shader;
	var defaultShaderTextured:Shader;
	var currentShader:Shader;

	var currentTexture:Texture;

	final modelMat:Mat4 = Mat4.id;
	final viewMat:Mat4 = Mat4.id;
	final projMat:Mat4 = Mat4.id;
	final mvpMat:Mat4 = Mat4.id;
	final vpMat:Mat4 = Mat4.id;

	var sceneOpen:Bool;
	var shapeOpen:Bool;

	static inline var MAT_STACK_SIZE:Int = 1024;

	var matStack:Vector<Float>;
	var matStackCount:Int;

	var currentRenderTarget:FrameBuffer;

	var numLights:Int;
	final lightBuf:Vector<Light> = new Vector(Consts.consts.MAX_LIGHTS);

	var materialAmb:Float;
	var materialDif:Float;
	var materialSpc:Float;
	var materialShn:Float;
	var materialEmi:Float;

	final unitSphereVs:Array<Vec3> = [];
	final unitSphereIs:Array<Array<Int>> = [];

	public function new(canvas:CanvasElement) {
		this.canvas = canvas;
		// gl = untyped WebGLDebugUtils.makeDebugContext(canvas.getContextWebGL2({
		// 	premultipliedAlpha: false
		// }));
		gl = canvas.getContextWebGL2({
			premultipliedAlpha: false,
			preserveDrawingBuffer: true
		});

		initGL();
		initShaders();
		sphereDetails(32, 16);

		localObj = createObject();
		localObjWriter = localObj.writer;
		tf = new TransformFeedback(gl);

		// camera
		perspective();
		cameraSet = false;
		cameraPos.set(0, 0, 1);
		cameraAt.set(0, 0, 0);
		cameraUp.set(0, 1, 0);

		// screen
		screen(canvas.width, canvas.height);

		// stack
		matStack = new Vector(MAT_STACK_SIZE);
		matStackCount = 0;

		// textures
		currentTexture = null;
		currentRenderTarget = null;

		// openness
		sceneOpen = false;
		shapeOpen = false;

		// lights
		for (i in 0...lightBuf.length) {
			lightBuf[i] = new Light();
		}
		numLights = 0;
	}

	function initGL():Void {
		gl.getExtension(OES_texture_float_linear);
		gl.getExtension(OES_texture_half_float_linear);
		gl.getExtension(EXT_color_buffer_float);

		gl.disable(GL2.DEPTH_TEST);
		gl.enable(GL2.BLEND);
		gl.frontFace(GL2.CCW);
		gl.cullFace(GL2.BACK);
		gl.disable(GL2.CULL_FACE);
		gl.blendFuncSeparate(GL2.SRC_ALPHA, GL2.ONE_MINUS_SRC_ALPHA, GL2.ONE, GL2.ONE);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	public function init2D():Void {
		gl.disable(GL2.DEPTH_TEST);
		gl.frontFace(GL2.CCW);
		gl.cullFace(GL2.BACK);
		gl.disable(GL2.CULL_FACE);
		resetCamera();
		resetViewport();
		noTexture();
	}

	public function init3D():Void {
		gl.enable(GL2.DEPTH_TEST);
		gl.frontFace(GL2.CCW);
		gl.cullFace(GL2.BACK);
		gl.enable(GL2.CULL_FACE);
		resetCamera();
		resetViewport();
		noTexture();
	}

	public function transformFeedback(shader:Shader, uniformMap:UniformMap, inputs:Array<VertexAttribute>, outputs:Array<FloatBuffer>,
			vertexCount:Int):Void {
		sceneCheck(false, "cannot perform transform feedbacks inside a scene");
		shader.bind([uniformMap]);
		tf.bind();
		tf.bindBuffers(outputs);
		tf.begin();
		for (input in inputs) {
			input.bind();
		}
		gl.drawArrays(GL2.POINTS, 0, vertexCount);
		for (input in inputs) {
			input.unbind();
		}
		tf.end();
		tf.unbind();
	}

	public function createObject(?attributes:Array<Attribute>):Object {
		return new Object(gl, attributes == null ? [Position(), Color(), Normal(), TexCoord()] : attributes);
	}

	function initShaders():Void {
		defaultShader = new Shader(gl);
		defaultShader.compile(DefaultShader.vertexSource, DefaultShader.fragmentSource);
		defaultShaderTextured = new Shader(gl);
		defaultShaderTextured.compile(DefaultShaderTextured.vertexSource, DefaultShaderTextured.fragmentSource);
		currentShader = null;
	}

	function chooseShader():Shader {
		if (currentShader != null)
			return currentShader;
		if (currentTexture != null)
			return defaultShaderTextured;
		return defaultShader;
	}

	/**
	 * Sets virtual screen size to `(width, height)`.
	 * This affects to the aspect ratio and default camera positions
	 */
	public function screen(width:Float, height:Float):Void {
		screenWidth = width;
		screenHeight = height;
		if (currentRenderTarget == null)
			resetViewport();
		updatePerspectiveMatrix();
	}

	public function viewport(x:Int, y:Int, width:Int, height:Int):Void {
		var targetHeight = currentRenderTarget == null ? canvas.height : currentRenderTarget.height;
		gl.viewport(x, targetHeight - height - y, width, height);
	}

	public function resetViewport():Void {
		var width;
		var height;
		if (currentRenderTarget == null) {
			width = canvas.width;
			height = canvas.height;
		} else {
			width = currentRenderTarget.width;
			height = currentRenderTarget.height;
		}
		gl.viewport(0, 0, width, height);
	}

	public function getRawGL():GL2 {
		return gl;
	}

	public function resetMaterial():Void {
		materialAmb = 1;
		materialDif = 1;
		materialSpc = 0;
		materialShn = 10;
		materialEmi = 0;
	}

	public function beginScene():Void {
		sceneCheck(false, "scene already begun");
		sceneOpen = true;

		modelMat << Mat4.id;
		numLights = 0;
		currentTexture = null;
		localObjWriter.color(Vec4.of(1, 1, 1, 1));
		localObjWriter.normal(Vec3.of(0, 0, 0));
		localObjWriter.texCoord(Vec2.of(0, 0));
		resetMaterial();

		if (!cameraSet) {
			defaultCameraPos.set(screenWidth * 0.5, screenHeight * 0.5, -screenHeight / (2 * Math.tan(computeFovY() * 0.5)));
			viewMat << Mat4.lookAt(defaultCameraPos, defaultCameraPos.xy.extend(0), -Vec3.ey);
		}
	}

	public function endScene():Void {
		sceneCheck(true, "scene already ended");
		sceneOpen = false;
		gl.flush();
	}

	/**
	 * Equivalent to `this.beginScene(); f(); this.endScene();`
	 */
	public inline function inScene(f:() -> Void):Void {
		beginScene();
		f();
		endScene();
	}

	extern inline function sceneCheck(shouldBeOpen:Bool, msg:String):Void {
		if (sceneOpen != shouldBeOpen) {
			throw new Error(msg);
		}
	}

	extern inline function shapeCheck(shouldBeOpen:Bool, msg:String):Void {
		if (shapeOpen != shouldBeOpen) {
			throw new Error(msg);
		}
	}

	public inline function enableDepthTest():Void {
		gl.enable(GL2.DEPTH_TEST);
	}

	public inline function disableDepthTest():Void {
		gl.disable(GL2.DEPTH_TEST);
	}

	public inline function culling(face:Face):Void {
		if (face == None) {
			gl.disable(GL2.CULL_FACE);
		} else {
			gl.enable(GL2.CULL_FACE);
			gl.cullFace(face);
		}
	}

	public inline function clearInt(r:Int, g:Int, b:Int, ?a:Int = 0):Void {
		sceneCheck(true, "begin scene before clear scene");
		if (currentRenderTarget == null || currentRenderTarget.textures[0].type != Int32)
			throw "current render target is not signed 32-bit integer texture(s)";
		for (i in 0...currentRenderTarget.textures.length) {
			gl.clearBufferiv(GL2.COLOR, i, new Int32Array([r, g, b, a]));
		}
		gl.clearDepth(1);
		gl.clear(GL2.DEPTH_BUFFER_BIT);
	}

	public inline function clearUInt(r:UInt, g:UInt, b:UInt, ?a:UInt = 0):Void {
		sceneCheck(true, "begin scene before clear scene");
		if (currentRenderTarget == null || currentRenderTarget.textures[0].type != UInt32)
			throw "current render target is not unsigned 32-bit integer texture(s)";
		for (i in 0...currentRenderTarget.textures.length) {
			gl.clearBufferuiv(GL2.COLOR, i, new Uint32Array([r, g, b, a]));
		}
		gl.clearDepth(1);
		gl.clear(GL2.DEPTH_BUFFER_BIT);
	}

	overload extern public inline function clear(rgb:Vec3, a:Float = 1):Void {
		clearImpl(rgb.x, rgb.y, rgb.z, a);
	}

	overload extern public inline function clear(rgba:Vec4):Void {
		clearImpl(rgba.x, rgba.y, rgba.z, rgba.w);
	}

	overload extern public inline function clear(r:Float, g:Float, b:Float, a:Float = 1):Void {
		clearImpl(r, g, b, a);
	}

	overload extern public inline function clear(rgb:Float, a:Float = 1):Void {
		clearImpl(rgb, rgb, rgb, a);
	}

	function clearImpl(r:Float, g:Float, b:Float, a:Float):Void {
		sceneCheck(true, "begin scene before clear scene");
		if (currentRenderTarget != null && (currentRenderTarget.textures[0].type == Int32 || currentRenderTarget.textures[0].type == UInt32))
			throw "current render target is integer texture(s); use clearInt or clearUInt";
		gl.clearColor(r, g, b, a);
		gl.clearDepth(1);
		gl.clear(GL2.COLOR_BUFFER_BIT | GL2.DEPTH_BUFFER_BIT);
	}

	public function createShader(vertexSource:String, fragmentSource:String, ?transformFeedbackOutput:TransformFeedbackOutput):Shader {
		var shader = new Shader(gl);
		shader.compile(vertexSource, fragmentSource, transformFeedbackOutput);
		return shader;
	}

	public function shader(shader:Shader):Void {
		currentShader = shader;
	}

	public function resetShader():Void {
		currentShader = null;
	}

	extern public inline function withShader(shader:Shader, f:() -> Void):Void {
		final tmp = currentShader;
		currentShader = shader;
		f();
		currentShader = tmp;
	}

	public function createTexture(width:Int, height:Int, type:TextureType = Int8):Texture {
		final tex = new Texture(gl);
		tex.init(width, height, type);
		return tex;
	}

	public function loadBitmap(source:BitmapSource, type:TextureType = Int8):Texture {
		final tex = new Texture(gl);
		tex.load(source, type);
		return tex;
	}

	public function loadBitmapTo(dst:Texture, source:BitmapSource, type:TextureType = Int8):Void {
		dst.load(source, type);
	}

	public function createFloatBuffer():FloatBuffer {
		return new FloatBuffer(gl);
	}

	public function createVertexBuffer(type:BufferType, size:Int):VertexBuffer {
		return {
			buffer: switch type {
				case Int:
					Int(new IntBuffer(gl));
				case Float:
					Float(new FloatBuffer(gl));
			},
			size: size,
			stride: 0,
			offset: 0
		}
	}

	public function createIntVertexBufferInterleaved(sizes:Array<Int>):{
		vertexBuffers:Array<VertexBuffer>,
		buffer:IntBuffer,
		totalSize:Int
	} {
		final res = createVertexBufferInterleaved(Int, sizes);
		return {
			vertexBuffers: res.vertexBuffers,
			buffer: switch res.buffer {
				case Int(buffer):
					buffer;
				case _:
					throw "int buffer expected";
			},
			totalSize: res.totalSize
		}
	}

	public function createFloatVertexBufferInterleaved(sizes:Array<Int>):{
		vertexBuffers:Array<VertexBuffer>,
		buffer:FloatBuffer,
		totalSize:Int
	} {
		final res = createVertexBufferInterleaved(Float, sizes);
		return {
			vertexBuffers: res.vertexBuffers,
			buffer: switch res.buffer {
				case Float(buffer):
					buffer;
				case _:
					throw "float buffer expected";
			},
			totalSize: res.totalSize
		}
	}

	function createVertexBufferInterleaved(type:BufferType, sizes:Array<Int>):{
		vertexBuffers:Array<VertexBuffer>,
		buffer:TypedBuffer,
		totalSize:Int
	} {
		final offsets = [];
		final stride = {
			var sum = 0;
			for (size in sizes) {
				offsets.push(sum);
				sum += size * Float32Array.BYTES_PER_ELEMENT;
			}
			sum;
		}
		final buffer:TypedBuffer = switch type {
			case Int:
				Int(new IntBuffer(gl));
			case Float:
				Float(new FloatBuffer(gl));
		}
		return {
			vertexBuffers: [for (i => size in sizes) {
				buffer: buffer,
				size: size,
				stride: stride,
				offset: offsets[i]
			}],
			buffer: buffer,
			totalSize: Std.int(stride / Float32Array.BYTES_PER_ELEMENT)
		}
	}

	public function createIntBuffer():IntBuffer {
		return new IntBuffer(gl);
	}

	overload extern public inline function createFrameBuffer(textures:Array<Texture>):FrameBuffer {
		return new FrameBuffer(gl, textures);
	}

	overload extern public inline function createFrameBuffer(texture:Texture):FrameBuffer {
		return createFrameBuffer([texture]);
	}

	public function renderingTo(target:FrameBuffer, f:() -> Void):Void {
		final tmp = currentRenderTarget;
		renderTarget(target);
		f();
		renderTarget(tmp);
	}

	public function renderTarget(target:FrameBuffer):Void {
		currentRenderTarget = target;
		if (target == null) {
			gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
			gl.drawBuffers([GL2.BACK]);
			gl.viewport(0, 0, canvas.width, canvas.height);
		} else {
			gl.bindFramebuffer(GL2.FRAMEBUFFER, target.getRawFrameBuffer());
			gl.drawBuffers([for (i in 0...target.textures.length) GL2.COLOR_ATTACHMENT0 + i]);
			gl.viewport(0, 0, target.width, target.height);
		}
	}

	public function pushMatrix():Void {
		if (matStackCount > MAT_STACK_SIZE - 16) {
			throw new Error("matrix stack overflowed");
		}
		matStack[matStackCount++] = modelMat.e00;
		matStack[matStackCount++] = modelMat.e01;
		matStack[matStackCount++] = modelMat.e02;
		matStack[matStackCount++] = modelMat.e03;
		matStack[matStackCount++] = modelMat.e10;
		matStack[matStackCount++] = modelMat.e11;
		matStack[matStackCount++] = modelMat.e12;
		matStack[matStackCount++] = modelMat.e13;
		matStack[matStackCount++] = modelMat.e20;
		matStack[matStackCount++] = modelMat.e21;
		matStack[matStackCount++] = modelMat.e22;
		matStack[matStackCount++] = modelMat.e23;
		matStack[matStackCount++] = modelMat.e30;
		matStack[matStackCount++] = modelMat.e31;
		matStack[matStackCount++] = modelMat.e32;
		matStack[matStackCount++] = modelMat.e33;
	}

	public function popMatrix():Void {
		if (matStackCount < 16) {
			throw new Error("cannot pop matrix");
		}
		modelMat.e33 = matStack[--matStackCount];
		modelMat.e32 = matStack[--matStackCount];
		modelMat.e31 = matStack[--matStackCount];
		modelMat.e30 = matStack[--matStackCount];
		modelMat.e23 = matStack[--matStackCount];
		modelMat.e22 = matStack[--matStackCount];
		modelMat.e21 = matStack[--matStackCount];
		modelMat.e20 = matStack[--matStackCount];
		modelMat.e13 = matStack[--matStackCount];
		modelMat.e12 = matStack[--matStackCount];
		modelMat.e11 = matStack[--matStackCount];
		modelMat.e10 = matStack[--matStackCount];
		modelMat.e03 = matStack[--matStackCount];
		modelMat.e02 = matStack[--matStackCount];
		modelMat.e01 = matStack[--matStackCount];
		modelMat.e00 = matStack[--matStackCount];
	}

	overload extern public inline function scale(s:Vec2):Void {
		scale(s.x, s.y);
	}

	overload extern public inline function scale(s:Vec3):Void {
		scale(s.x, s.y, s.z);
	}

	overload extern public inline function scale(sx:Float, sy:Float, sz:Float = 1):Void {
		modelMat << modelMat * Vec4.of(sx, sy, sz, 1).diag;
	}

	extern public inline function rotate(ang:Float):Void {
		modelMat << modelMat * Mat3.rot(ang, Vec3.ez).toMat4();
	}

	extern public inline function rotateX(ang:Float):Void {
		modelMat << modelMat * Mat3.rot(ang, Vec3.ex).toMat4();
	}

	extern public inline function rotateY(ang:Float):Void {
		modelMat << modelMat * Mat3.rot(ang, Vec3.ey).toMat4();
	}

	extern public inline function rotateZ(ang:Float):Void {
		modelMat << modelMat * Mat3.rot(ang, Vec3.ez).toMat4();
	}

	overload extern public inline function translate(tx:Float, ty:Float, tz:Float = 0):Void {
		modelMat << modelMat * Mat4.translate(Vec3.of(tx, ty, tz));
	}

	overload extern public inline function translate(t:Vec3):Void {
		modelMat << modelMat * Mat4.translate(t);
	}

	overload extern public inline function translate(t:Vec2):Void {
		modelMat << modelMat * Mat4.translate(t.extend(0));
	}

	extern public inline function transform(mat:Mat4):Void {
		modelMat << modelMat * mat;
	}

	extern public inline function resetCamera():Void {
		cameraSet = false;
	}

	extern public inline function camera(pos:Vec3, at:Vec3, up:Vec3):Void {
		cameraSet = true;
		cameraPos << pos;
		cameraAt << at;
		cameraUp << up;
		viewMat << Mat4.lookAt(cameraPos, cameraAt, cameraUp);
	}

	public inline function perspective(?fov:Float, ?fovMode:FovMode = FovY, ?near:Float = 0.1, ?far:Float = 10000):Void {
		if (fov == null) {
			fov = Math.PI / 3;
		}
		cameraFov = fov;
		cameraFovMode = fovMode;
		cameraNear = near;
		cameraFar = far;
		updatePerspectiveMatrix();
	}

	function computeFovY():Float {
		final aspect = screenWidth / screenHeight;
		final useFovX = switch (cameraFovMode) {
			case FovX:
				true;
			case FovY:
				false;
			case FovMin:
				aspect < 1;
			case FovMax:
				aspect > 1;
		}
		return if (useFovX) {
			2 * Math.atan(Math.tan(cameraFov * 0.5) / aspect);
		} else {
			cameraFov;
		}
	}

	inline function updatePerspectiveMatrix():Void {
		projMat << Mat4.perspective(computeFovY(), screenWidth / screenHeight, cameraNear, cameraFar);
	}

	public function image(img:Texture, srcX:Float, srcY:Float, srcW:Float, srcH:Float, dstX:Float, dstY:Float, dstW:Float,
			dstH:Float):Void {
		withTexture(img, () -> {
			final sw = 1 / img.width;
			final sh = 1 / img.height;
			srcX *= sw;
			srcY *= sh;
			srcW *= sw;
			srcH *= sh;

			beginShape(TriangleStrip);
			normal(0, 0, -1);
			texCoord(srcX, srcY);
			vertex(dstX, dstY, 0);
			texCoord(srcX, srcY + srcH);
			vertex(dstX, dstY + dstH, 0);
			texCoord(srcX + srcW, srcY);
			vertex(dstX + dstW, dstY, 0);
			texCoord(srcX + srcW, srcY + srcH);
			vertex(dstX + dstW, dstY + dstH, 0);
			endShape();
		});
	}

	public function rect(x:Float, y:Float, width:Float, height:Float):Void {
		beginShape(TriangleStrip);
		normal(0, 0, -1);
		texCoord(0, 1);
		vertex(x, y, 0);
		texCoord(0, 0);
		vertex(x, y + height, 0);
		texCoord(1, 1);
		vertex(x + width, y, 0);
		texCoord(1, 0);
		vertex(x + width, y + height, 0);
		endShape();
	}

	public function fullScreenRect():Void {
		beginShape(TriangleStrip);
		normal((viewMat.toMat3() * modelMat.toMat3()).t.col2);
		texCoord(0, 0);
		vertex(screenToWorld(Vec3.of(-1, -1, 0)));
		texCoord(1, 0);
		vertex(screenToWorld(Vec3.of(1, -1, 0)));
		texCoord(0, 1);
		vertex(screenToWorld(Vec3.of(-1, 1, 0)));
		texCoord(1, 1);
		vertex(screenToWorld(Vec3.of(1, 1, 0)));
		endShape();
	}

	overload extern public inline function line(x1:Float, y1:Float, x2:Float, y2:Float):Void {
		lineImpl(x1, y1, 0, x2, y2, 0);
	}

	overload extern public inline function line(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float):Void {
		lineImpl(x1, y1, z1, x2, y2, z2);
	}

	function lineImpl(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float):Void {
		var tmpNumLights = numLights;
		numLights = 0;
		withTexture(null, () -> {
			beginShape(Lines);
			vertex(x1, y1, z1);
			vertex(x2, y2, z2);
			endShape();
		});
		numLights = tmpNumLights;
	}

	public function sphereDetails(divV:Int, divH:Int):Void {
		if (divV < 3 || divH < 3)
			throw "sphere divisions must be greater than or equal to 3";
		final numVertices = 2 + (divH - 2) * divV;
		unitSphereVs.resize(0);
		unitSphereVs.push(Vec3.of(0, 1, 0));
		for (i in 1...divH - 1) {
			final theta = i / divH * Math.PI;
			for (j in 0...divV) {
				final phi = j / divV * Math.PI * 2;
				unitSphereVs.push(Vec3.of(Math.sin(theta) * Math.cos(phi), Math.cos(theta), -Math.sin(theta) * Math.sin(phi)));
			}
		}
		unitSphereVs.push(Vec3.of(0, -1, 0));
		unitSphereIs.resize(0);
		final last = numVertices - 1;
		for (j in 0...divV) {
			unitSphereIs.push([0, j + 1, (j + 1) % divV + 1]);
			unitSphereIs.push([last, last - (j + 1), last - ((j + 1) % divV + 1)]);
		}
		for (i in 1...divH - 2) {
			final off1 = 1 + divV * (i - 1);
			final off2 = off1 + divV;
			for (j in 0...divV) {
				final i1 = off1 + j;
				final i2 = off2 + j;
				final i3 = off2 + (j + 1) % divV;
				final i4 = off1 + (j + 1) % divV;
				unitSphereIs.push([i1, i2, i3]);
				unitSphereIs.push([i1, i3, i4]);
			}
		}
	}

	public function sphere(radius:Float):Void {
		var tmpTex = currentTexture; // TODO: put texture coords
		currentTexture = null;

		beginShape(Triangles);
		for (tri in unitSphereIs) {
			final v1 = unitSphereVs[tri[0]];
			final v2 = unitSphereVs[tri[1]];
			final v3 = unitSphereVs[tri[2]];
			normal(v1.x, v1.y, v1.z);
			vertex(v1.x * radius, v1.y * radius, v1.z * radius);
			normal(v2.x, v2.y, v2.z);
			vertex(v2.x * radius, v2.y * radius, v2.z * radius);
			normal(v3.x, v3.y, v3.z);
			vertex(v3.x * radius, v3.y * radius, v3.z * radius);
		}
		endShape();

		currentTexture = tmpTex;
	}

	overload extern public inline function triangle(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float, x3:Float, y3:Float,
			z3:Float):Void {
		triangleImpl(x1, y1, z1, x2, y2, z2, x3, y3, z3);
	}

	overload extern public inline function triangle(v1:Vec3, v2:Vec3, v3:Vec3):Void {
		triangleImpl(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z, v3.x, v3.y, v3.z);
	}

	overload extern public inline function triangle(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float):Void {
		triangleImpl(x1, y1, 0, x2, y2, 0, x3, y3, 0);
	}

	overload extern public inline function triangle(v1:Vec2, v2:Vec2, v3:Vec2):Void {
		triangleImpl(v1.x, v1.y, 0, v2.x, v2.y, 0, v3.x, v3.y, 0);
	}

	function triangleImpl(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float, x3:Float, y3:Float, z3:Float):Void {
		withTexture(null, () -> {
			shaping(Triangles, () -> {
				var x12 = x2 - x1;
				var y12 = y2 - y1;
				var z12 = z2 - z1;
				var x13 = x3 - x1;
				var y13 = y3 - y1;
				var z13 = z3 - z1;
				var nx = y12 * z13 - z12 * y13;
				var ny = z12 * x13 - x12 * z13;
				var nz = x12 * y13 - y12 * x13;
				var len = nx * nx + ny * ny + nz * nz;
				if (len > 0)
					len = 1 / Math.sqrt(len);
				nx *= len;
				ny *= len;
				nz *= len;
				normal(nx, ny, nz);
				vertex(x1, y1, z1);
				vertex(x2, y2, z2);
				vertex(x3, y3, z3);
			});
		});
	}

	public function box(width:Float, height:Float, depth:Float):Void {
		beginShape(Triangles);
		width *= 0.5;
		height *= 0.5;
		depth *= 0.5;
		var x1 = -width;
		var x2 = width;
		var y1 = -height;
		var y2 = height;
		var z1 = -depth;
		var z2 = depth;

		if (currentTexture != null) {
			normal(-1, 0, 0);
			boxFaceUV(x1, y1, z1, x1, y1, z2, x1, y2, z2, x1, y2, z1);
			normal(1, 0, 0);
			boxFaceUV(x2, y1, z1, x2, y2, z1, x2, y2, z2, x2, y1, z2);
			normal(0, -1, 0);
			boxFaceUV(x1, y1, z1, x2, y1, z1, x2, y1, z2, x1, y1, z2);
			normal(0, 1, 0);
			boxFaceUV(x1, y2, z1, x1, y2, z2, x2, y2, z2, x2, y2, z1);
			normal(0, 0, -1);
			boxFaceUV(x1, y1, z1, x1, y2, z1, x2, y2, z1, x2, y1, z1);
			normal(0, 0, 1);
			boxFaceUV(x1, y1, z2, x2, y1, z2, x2, y2, z2, x1, y2, z2);
		} else {
			normal(-1, 0, 0);
			boxFace(x1, y1, z1, x1, y1, z2, x1, y2, z2, x1, y2, z1);
			normal(1, 0, 0);
			boxFace(x2, y1, z1, x2, y2, z1, x2, y2, z2, x2, y1, z2);
			normal(0, -1, 0);
			boxFace(x1, y1, z1, x2, y1, z1, x2, y1, z2, x1, y1, z2);
			normal(0, 1, 0);
			boxFace(x1, y2, z1, x1, y2, z2, x2, y2, z2, x2, y2, z1);
			normal(0, 0, -1);
			boxFace(x1, y1, z1, x1, y2, z1, x2, y2, z1, x2, y1, z1);
			normal(0, 0, 1);
			boxFace(x1, y1, z2, x2, y1, z2, x2, y2, z2, x1, y2, z2);
		}
		endShape();
	}

	function boxFace(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float, x3:Float, y3:Float, z3:Float, x4:Float, y4:Float,
			z4:Float):Void {
		vertex(x1, y1, z1);
		vertex(x2, y2, z2);
		vertex(x3, y3, z3);
		vertex(x1, y1, z1);
		vertex(x3, y3, z3);
		vertex(x4, y4, z4);
	}

	function boxFaceUV(x1:Float, y1:Float, z1:Float, x2:Float, y2:Float, z2:Float, x3:Float, y3:Float, z3:Float, x4:Float, y4:Float,
			z4:Float):Void {
		texCoord(0, 0);
		vertex(x1, y1, z1);
		texCoord(0, 1);
		vertex(x2, y2, z2);
		texCoord(1, 1);
		vertex(x3, y3, z3);
		texCoord(0, 0);
		vertex(x1, y1, z1);
		texCoord(1, 1);
		vertex(x3, y3, z3);
		texCoord(1, 0);
		vertex(x4, y4, z4);
	}

	overload extern public inline function color(rgb:Vec3, a:Float = 1):Void {
		localObjWriter.color(rgb, a);
	}

	overload extern public inline function color(rgba:Vec4):Void {
		localObjWriter.color(rgba);
	}

	overload extern public inline function color(r:Float, g:Float, b:Float, a:Float = 1):Void {
		localObjWriter.color(r, g, b, a);
	}

	overload extern public inline function color(rgb:Float, a:Float = 1):Void {
		localObjWriter.color(rgb, rgb, rgb, a);
	}

	overload extern public inline function normal(n:Vec3):Void {
		localObjWriter.normal(n);
	}

	overload extern public inline function normal(nx:Float, ny:Float, nz:Float):Void {
		localObjWriter.normal(nx, ny, nz);
	}

	overload extern public inline function texCoord(uv:Vec2):Void {
		localObjWriter.texCoord(uv);
	}

	overload extern public inline function texCoord(u:Float, v:Float):Void {
		localObjWriter.texCoord(u, v);
	}

	public inline function blend(blendMode:BlendMode = Normal):Void {
		switch (blendMode) {
			case Normal:
				gl.enable(GL2.BLEND);
				gl.blendFuncSeparate(GL2.SRC_ALPHA, GL2.ONE_MINUS_SRC_ALPHA, GL2.ONE, GL2.ONE);
			case Add:
				gl.enable(GL2.BLEND);
				gl.blendFuncSeparate(GL2.SRC_ALPHA, GL2.ONE, GL2.ONE, GL2.ONE);
			case None:
				gl.disable(GL2.BLEND);
		}
	}

	public inline function noLights():Void {
		sceneCheck(true, "begin scene before setting lights");
		numLights = 0;
	}

	public inline function lights():Void {
		ambientLight(0.2);
		directionalLight(0.8, -viewMat.row2.xyz);
	}

	overload extern public inline function ambientLight(rgb:Float):Void {
		ambientLight(rgb, rgb, rgb);
	}

	overload extern public inline function ambientLight(rgb:Vec3):Void {
		ambientLight(rgb.x, rgb.y, rgb.z);
	}

	overload extern public inline function ambientLight(r:Float, g:Float, b:Float):Void {
		sceneCheck(true, "begin scene before setting lights");
		if (numLights == lightBuf.length)
			throw new Error("too many lights");
		var light = lightBuf[numLights++];
		light.col << Vec3.of(r, g, b);
		light.pos << Vec4.zero;
		light.nor << Vec3.zero;
	}

	overload extern public inline function directionalLight(rgb:Float, dir:Vec3):Void {
		directionalLight(rgb, rgb, rgb, dir);
	}

	overload extern public inline function directionalLight(rgb:Vec3, dir:Vec3):Void {
		directionalLight(rgb.x, rgb.y, rgb.z, dir);
	}

	overload extern public inline function directionalLight(r:Float, g:Float, b:Float, dir:Vec3):Void {
		sceneCheck(true, "begin scene before setting lights");
		if (numLights == lightBuf.length)
			throw new Error("too many lights");
		var light = lightBuf[numLights++];
		light.col << Vec3.of(r, g, b);
		light.pos << Vec4.zero;
		light.nor << dir.normalized;
	}

	overload extern public inline function pointLight(rgb:Float, pos:Vec3):Void {
		pointLight(rgb, rgb, rgb, pos);
	}

	overload extern public inline function pointLight(rgb:Vec3, pos:Vec3):Void {
		pointLight(rgb.x, rgb.y, rgb.z, pos);
	}

	overload extern public inline function pointLight(r:Float, g:Float, b:Float, pos:Vec3):Void {
		sceneCheck(true, "begin scene before setting lights");
		if (numLights == lightBuf.length)
			throw new Error("too many lights");
		var light = lightBuf[numLights++];
		light.col << Vec3.of(r, g, b);
		light.pos << Vec4.of(pos.x, pos.y, pos.z, 1);
		light.nor << Vec3.zero;
	}

	public inline function ambient(v:Float):Void {
		sceneCheck(true, "begin scene before setting materials");
		materialAmb = v;
	}

	public inline function diffuse(v:Float):Void {
		sceneCheck(true, "begin scene before setting materials");
		materialDif = v;
	}

	public inline function specular(v:Float):Void {
		sceneCheck(true, "begin scene before setting materials");
		materialSpc = v;
	}

	public inline function shininess(v:Float):Void {
		sceneCheck(true, "begin scene before setting materials");
		materialShn = v;
	}

	public inline function emission(v:Float):Void {
		sceneCheck(true, "begin scene before setting materials");
		materialEmi = v;
	}

	extern public inline function withTexture(tex:Null<Texture>, f:() -> Void):Void {
		final tmp = currentTexture;
		currentTexture = tex;
		f();
		currentTexture = tmp;
	}

	extern public inline function texture(tex:Texture):Void {
		currentTexture = tex;
	}

	extern public inline function noTexture():Void {
		currentTexture = null;
	}

	overload extern public inline function vertex(p:Vec3, addIndex:Bool = true):Int {
		return vertex(p.x, p.y, p.z, addIndex);
	}

	overload extern public inline function vertex(p:Vec2, addIndex:Bool = true):Int {
		return vertex(p.x, p.y, 0, addIndex);
	}

	overload extern public inline function vertex(x:Float, y:Float, ?z:Float = 0, ?addIndex:Bool = true):Int {
		shapeCheck(true, "begin shape before vertex");
		return localObjWriter.vertex(x, y, z, addIndex);
	}

	public inline function index(i:Int):Void {
		shapeCheck(true, "begin shape before index");
		localObjWriter.index(i);
	}

	public function beginShape(mode:ShapeMode):Void {
		sceneCheck(true, "begin scene before begin shape");
		shapeCheck(false, "shape already begun");
		shapeOpen = true;
		localObjWriter.clear();
		localObj.mode = mode;
	}

	public function endShape():Void {
		shapeCheck(true, "shape already ended");
		shapeOpen = false;
		localObjWriter.upload();
		localObj.material.shader = chooseShader();
		drawObject(localObj);
	}

	extern public inline function shaping(mode:ShapeMode, f:() -> Void):Void {
		beginShape(mode);
		f();
		endShape();
	}

	function prepareUniforms():Void {
		inline function toMat4(m:Mat4):UniformValue {
			return Mat(4, 4, [
				m.e00, m.e10, m.e20, m.e30,
				m.e01, m.e11, m.e21, m.e31,
				m.e02, m.e12, m.e22, m.e32,
				m.e03, m.e13, m.e23, m.e33
			]);
		}
		inline function toMat3(m:Mat3):UniformValue {
			return Mat(3, 3, [
				m.e00, m.e10, m.e20,
				m.e01, m.e11, m.e21,
				m.e02, m.e12, m.e22,
			]);
		}
		inline function toVec3(v:Vec3):UniformValue {
			return Vec3(v.x, v.y, v.z);
		}
		inline function toVec4(v:Vec4):UniformValue {
			return Vec4(v.x, v.y, v.z, v.w);
		}

		var map = defaultUniformMap;

		final modelViewMat = viewMat * modelMat;
		final invModelViewMat = modelViewMat.inv;

		final uf = DefaultShader.uniforms;
		map.set(uf.matrix.model.name, toMat4(modelMat));
		map.set(uf.matrix.view.name, toMat4(viewMat));
		map.set(uf.matrix.projection.name, toMat4(projMat));
		map.set(uf.matrix.invProjection.name, toMat4(projMat.inv));
		map.set(uf.matrix.modelView.name, toMat4(modelViewMat));
		map.set(uf.matrix.transform.name, toMat4(projMat * modelViewMat));
		map.set(uf.matrix.invModelView.name, toMat4(invModelViewMat));
		map.set(uf.matrix.normal.name, toMat3(invModelViewMat.t.toMat3()));
		map.set(uf.material.texture.name, UniformValue.Sampler(currentTexture));

		map.set(uf.material.ambient.name, UniformValue.Float(materialAmb));
		map.set(uf.material.diffuse.name, UniformValue.Float(materialDif));
		map.set(uf.material.specular.name, UniformValue.Float(materialSpc));
		map.set(uf.material.shininess.name, UniformValue.Float(materialShn));
		map.set(uf.material.emission.name, UniformValue.Float(materialEmi));

		map.set(uf.numLights.name, UniformValue.Int(numLights));
		for (i in 0...numLights) {
			map.set(uf.lights[i].position.name, toVec4(viewMat * lightBuf[i].pos));
			map.set(uf.lights[i].normal.name, toVec3(viewMat.toMat3() * lightBuf[i].nor));
			map.set(uf.lights[i].color.name, toVec3(lightBuf[i].col));
		}
	}

	public function drawObject(obj:Object):Void {
		prepareUniforms();
		obj.draw(defaultUniformMap);
	}

	public function drawObjectInstanced(obj:Object, instanceCount:Int):Void {
		prepareUniforms();
		obj.drawInstanced(defaultUniformMap, instanceCount);
	}

	/**
	 * [local -> world] -> view -> screen
	 */
	extern public inline function localToWorld(local:Vec3):Vec3 {
		final m = modelMat;
		return m.toMat3() * local + m.col3.xyz;
	}

	/**
	 * local -> [world -> view] -> screen
	 */
	extern public inline function worldToView(world:Vec3):Vec3 {
		final m = viewMat;
		return m.toMat3() * world + m.col3.xyz;
	}

	/**
	 * local -> world -> [view -> screen]
	 * 
	 * in screen coordinate system, [near, far] = [-1, 1]
	 */
	extern public inline function viewToScreen(view:Vec3):Vec3 {
		final m = projMat;
		final screen = m * view.extend(1);
		return screen.xyz / screen.w;
	}

	/**
	 * [local -> world -> view] -> screen
	 */
	extern public inline function localToView(local:Vec3):Vec3 {
		return worldToView(localToWorld(local));
	}

	/**
	 * local -> [world -> view -> screen]
	 * 
	 * in screen coordinate system, [near, far] = [-1, 1]
	 */
	extern public inline function worldToScreen(world:Vec3):Vec3 {
		return viewToScreen(worldToView(world));
	}

	/**
	 * [local -> world -> view -> screen]
	 * 
	 * in screen coordinate system, [near, far] = [-1, 1]
	 */
	extern public inline function localToScreen(local:Vec3):Vec3 {
		return viewToScreen(worldToView(localToWorld(local)));
	}

	/**
	 * [screen -> view] -> world -> local
	 * 
	 * in screen coordinate system, [near, far] = [-1, 1]
	 */
	extern public inline function screenToView(screen:Vec3):Vec3 {
		final m = projMat.inv;
		final view = m * screen.extend(1);
		return view.xyz / view.w;
	}

	/**
	 * screen -> [view -> world] -> local
	 */
	extern public inline function viewToWorld(view:Vec3):Vec3 {
		final m = viewMat.inv;
		return m.toMat3() * view + m.col3.xyz;
	}

	/**
	 * screen -> view -> [world -> local]
	 */
	extern public inline function worldToLocal(world:Vec3):Vec3 {
		final m = modelMat.inv;
		return m.toMat3() * world + m.col3.xyz;
	}

	/**
	 * [screen -> view -> world] -> local
	 * 
	 * in screen coordinate system, [near, far] = [-1, 1]
	 */
	extern public inline function screenToWorld(screen:Vec3):Vec3 {
		final m = (projMat * viewMat).inv;
		final world = m * screen.extend(1);
		return world.xyz / world.w;
	}

	/**
	 * screen -> [view -> world -> local]
	 */
	extern public inline function viewToLocal(view:Vec3):Vec3 {
		final m = (modelMat * viewMat).inv;
		return m.toMat3() * view + m.col3.xyz;
	}

	/**
	 * [screen -> view -> world -> local]
	 * 
	 * in screen coordinate system, [near, far] = [-1, 1]
	 */
	extern public inline function screenToLocal(screen:Vec3):Vec3 {
		final m = (projMat * viewMat * modelMat).inv;
		final local = m * screen.extend(1);
		return local.xyz / local.w;
	}
}

private class Light {
	public final pos:Vec4 = Vec4.zero; // w == 0.0 if directional
	public final nor:Vec3 = Vec3.zero;
	public final col:Vec3 = Vec3.zero;

	public function new() {
	}
}
