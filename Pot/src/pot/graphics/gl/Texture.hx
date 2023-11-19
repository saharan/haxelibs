package pot.graphics.gl;

import js.html.webgl.GL2;
import js.lib.Float32Array;
import js.lib.Int32Array;
import js.lib.Uint16Array;
import js.lib.Uint32Array;
import js.lib.Uint8Array;
import pot.graphics.bitmap.BitmapSource;

/**
 * Texture class
 */
class Texture extends GLObject {
	public var width(default, null):Int;
	public var height(default, null):Int;

	final texture:js.html.webgl.Texture;

	public final frameBuffer:FrameBuffer;

	var texWrapU:TextureWrap;
	var texWrapV:TextureWrap;
	var texFilter:TextureFilter;

	public var format(default, null):TextureFormat;
	public var type(default, null):TextureType;

	@:allow(pot.graphics.gl.Graphics)
	function new(gl:GL2) {
		super(gl);
		texWrapU = Clamp;
		texWrapV = Clamp;
		texFilter = Linear;

		texture = gl.createTexture();
		frameBuffer = new FrameBuffer(gl, [this], false);
	}

	public function getRawTexture():js.html.webgl.Texture {
		return texture;
	}

	function internalFormatWrap():Int {
		return switch [format, type] {
			case [R, Int8]:
				GL2.R8;
			case [RGB, Int8]:
				GL2.RGB8;
			case [RGBA, Int8]:
				GL2.RGBA8;
			case [R, Int32]:
				GL2.R32I;
			case [RGB, Int32]:
				GL2.RGB32I;
			case [RGBA, Int32]:
				GL2.RGBA32I;
			case [R, UInt32]:
				GL2.R32UI;
			case [RGB, UInt32]:
				GL2.RGB32UI;
			case [RGBA, UInt32]:
				GL2.RGBA32UI;
			case [R, Float16]:
				GL2.R16F;
			case [RGB, Float16]:
				GL2.RGB16F;
			case [RGBA, Float16]:
				GL2.RGBA16F;
			case [R, Float32]:
				GL2.R32F;
			case [RGB, Float32]:
				GL2.RGB32F;
			case [RGBA, Float32]:
				GL2.RGBA32F;
		}
	}

	function formatWrap():Int {
		return switch [format, type] {
			case [R, Int32 | UInt32]:
				GL2.RED_INTEGER;
			case [RGB, Int32 | UInt32]:
				GL2.RGB_INTEGER;
			case [RGBA, Int32 | UInt32]:
				GL2.RGBA_INTEGER;
			case [R, Int8 | Float16 | Float32]:
				GL2.RED;
			case [RGB, Int8 | Float16 | Float32]:
				GL2.RGB;
			case [RGBA, Int8 | Float16 | Float32]:
				GL2.RGBA;
		}
	}

	function numChannels():Int {
		return switch format {
			case R:
				1;
			case RGB:
				3;
			case RGBA:
				4;
		}
	}

	@:allow(pot.graphics.gl.Graphics)
	function init(width:Int, height:Int, format:TextureFormat, type:TextureType):Void {
		this.width = width;
		this.height = height;
		this.format = format;
		this.type = type;

		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texImage2D(GL2.TEXTURE_2D, 0, internalFormatWrap(), width, height, 0, formatWrap(), type, null);
		gl.bindTexture(GL2.TEXTURE_2D, null);

		switch type {
			case Int32 | UInt32:
				texFilter = Nearest;
			case _:
		}
		filter(texFilter);
		wrap(texWrapU, texWrapV);

		initFBO();
	}

	@:allow(pot.graphics.gl.Graphics)
	function load(source:BitmapSource, format:TextureFormat, type:TextureType, flipY:Bool = true):Void {
		this.width = source.width;
		this.height = source.height;
		this.format = format;
		this.type = type;

		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texImage2D(GL2.TEXTURE_2D, 0, internalFormatWrap(), formatWrap(), type, cast source.source);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);

		switch type {
			case Int32 | UInt32:
				texFilter = Nearest;
			case _:
		}
		filter(texFilter);
		wrap(texWrapU, texWrapV);

		initFBO();
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Uint8Array, flipY:Bool = true):Void {
		if (type != Int8)
			throw "not an 8-bit integer texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_BYTE,
			pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Int32Array, flipY:Bool = true):Void {
		if (type != Int32)
			throw "not a 32-bit integer texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.INT, pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Uint32Array, flipY:Bool = true):Void {
		if (type != UInt32)
			throw "not an unsigned 32-bit integer texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_INT,
			pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Float32Array, flipY:Bool = true):Void {
		if (type != Float32)
			throw "not a 32-bit floating point texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.FLOAT, pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Uint8Array):Void {
		if (type != Int8)
			throw "not an 8-bit integer texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, frameBuffer.getRawFrameBuffer());
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_BYTE, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Int32Array):Void {
		if (type != Int32)
			throw "not a 32-bit integer texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, frameBuffer.getRawFrameBuffer());
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.INT, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Uint32Array):Void {
		if (type != UInt32)
			throw "not an unsigned 32-bit integer texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, frameBuffer.getRawFrameBuffer());
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_INT, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int,
			pixelsRGBA:Float32Array):Void {
		if (type != Float32)
			throw "not a 32-bit floating point texture";
		if (pixelsRGBA.length != width * height * numChannels())
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, frameBuffer.getRawFrameBuffer());
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.FLOAT, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	public function sync():Void {
		gl.bindFramebuffer(GL2.FRAMEBUFFER, frameBuffer.getRawFrameBuffer());
		final nc = numChannels();
		gl.readPixels(0, 0, 1, 1, formatWrap(), type, switch type {
			case Int8:
				new Uint8Array(nc);
			case Int32:
				new Int32Array(nc);
			case UInt32:
				new Uint32Array(nc);
			case Float16:
				new Uint16Array(nc);
			case Float32:
				new Float32Array(nc);
		});
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	function initFBO():Void {
		frameBuffer.initBuffers();
	}

	public inline function filter(filter:TextureFilter, enableMipmapping:Bool = false):Void {
		texFilter = filter;
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		switch (filter) {
			case Nearest:
				gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MAG_FILTER, GL2.NEAREST);
				if (enableMipmapping) {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.NEAREST_MIPMAP_NEAREST);
				} else {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.NEAREST);
				}
			case Linear:
				gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MAG_FILTER, GL2.LINEAR);
				if (enableMipmapping) {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.LINEAR_MIPMAP_LINEAR);
				} else {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.LINEAR);
				}
		}
		if (enableMipmapping) {
			gl.generateMipmap(GL2.TEXTURE_2D);
		}
		gl.bindTexture(GL2.TEXTURE_2D, null);
	}

	public inline function wrap(wrapU:TextureWrap, wrapV:TextureWrap):Void {
		texWrapU = wrapU;
		texWrapV = wrapV;
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_WRAP_S, wrapU);
		gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_WRAP_T, wrapV);
		gl.bindTexture(GL2.TEXTURE_2D, null);
	}

	function disposeImpl():Void {
		gl.deleteTexture(texture);
		frameBuffer.dispose();
	}
}
