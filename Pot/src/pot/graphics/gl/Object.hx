package pot.graphics.gl;

import pot.graphics.gl.low.FloatBuffer;
import js.html.webgl.GL2;
import pot.graphics.gl.low.IndexBuffer;
import pot.graphics.gl.low.ShapeMode;
import pot.graphics.gl.low.VertexArrayObject;
import pot.graphics.gl.shader.DefaultShader;

class Object extends GLObject {
	final obj:VertexArrayObject;

	public final position:VertexAttribute;
	public final color:VertexAttribute;
	public final normal:VertexAttribute;
	public final texCoord:VertexAttribute;
	public final customAttributes:Array<VertexAttribute> = [];
	public final index:IndexBuffer;
	public final writer:ObjectWriter;

	public var mode:ShapeMode = Triangles;

	public var material:Material = new Material();

	@:allow(pot.graphics.gl.Graphics)
	function new(gl:GL2, attributes:Array<Attribute>) {
		super(gl);
		final defaultAttribs = DefaultShader.attributes;
		inline function vbuf(size:Int):VertexBuffer {
			return {
				buffer: Float(new FloatBuffer(gl, ArrayBuffer)),
				size: size,
				stride: 0,
				offset: 0
			}
		}
		inline function fbuf(buf:VertexBuffer):FloatBuffer {
			return switch buf.buffer {
				case Float(buffer):
					buffer;
				case Int(buffer):
					throw "float buffer expected";
			}
		}
		position = new VertexAttribute(vbuf(3), defaultAttribs.aPosition.location);
		color = new VertexAttribute(vbuf(4), defaultAttribs.aColor.location);
		normal = new VertexAttribute(vbuf(3), defaultAttribs.aNormal.location);
		texCoord = new VertexAttribute(vbuf(2), defaultAttribs.aTexCoord.location);
		index = new IndexBuffer(gl);
		writer = new ObjectWriter(fbuf(position.buffer), fbuf(color.buffer), fbuf(normal.buffer), fbuf(texCoord.buffer), index.buffer);
		obj = new VertexArrayObject(gl, attributes.map(attribute -> {
			switch attribute {
				case Position(location):
					if (location != null)
						position.location = location;
					position;
				case Color(location):
					if (location != null)
						color.location = location;
					color;
				case Normal(location):
					if (location != null)
						normal.location = location;
					normal;
				case TexCoord(location):
					if (location != null)
						texCoord.location = location;
					texCoord;
				case Custom(buffer, location, divisor):
					final res = new VertexAttribute(buffer, location, divisor == null ? 0 : divisor);
					customAttributes.push(res);
					res;
			}
		}), index);
	}

	public function rebindAttributes():Void {
		obj.rebindAttributes();
	}

	public function draw(defaultMap:UniformMap):Void {
		material.shader.bind([defaultMap, material.uniformMap]);
		obj.mode = mode;
		obj.draw();
	}

	public function drawInstanced(defaultMap:UniformMap, instanceCount:Int):Void {
		material.shader.bind([defaultMap, material.uniformMap]);
		obj.mode = mode;
		obj.drawInstanced(instanceCount);
	}

	function disposeImpl():Void {
		position.dispose();
		color.dispose();
		normal.dispose();
		texCoord.dispose();
		obj.dispose();
	}
}
