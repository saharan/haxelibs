package pot.graphics.gl;

import js.html.webgl.GL2;

class VertexAttribute {
	final gl:GL2;

	public final buffer:VertexBuffer;
	public var location:Int;
	public var divisor:Int;

	public function new(buffer:VertexBuffer, location:Int, divisor:Int = 0) {
		this.buffer = buffer;
		gl = switch buffer.buffer {
			case Float(buffer):
				@:privateAccess buffer.gl;
			case Int(buffer):
				@:privateAccess buffer.gl;
		}
		this.location = location;
		this.divisor = divisor;
	}

	extern public inline function bind():Void {
		gl.enableVertexAttribArray(location);
		gl.vertexAttribDivisor(location, divisor);
		switch buffer.buffer {
			case Float(fbuf):
				fbuf.vertexAttribPointer(location, buffer.size, buffer.stride, buffer.offset);
			case Int(ibuf):
				ibuf.vertexAttribPointer(location, buffer.size, buffer.stride, buffer.offset);
		}
	}

	extern public inline function unbind():Void {
		gl.disableVertexAttribArray(location);
	}

	public function dispose():Void {
		switch buffer.buffer {
			case Float(buffer):
				buffer.dispose();
			case Int(buffer):
				buffer.dispose();
		}
	}
}
