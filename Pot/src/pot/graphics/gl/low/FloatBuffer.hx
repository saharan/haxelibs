package pot.graphics.gl.low;

import haxe.io.UInt8Array;
import js.html.webgl.Buffer;
import js.html.webgl.GL2;
import js.lib.Float32Array;
import js.lib.Uint8Array;

class FloatBuffer extends GLObject {
	final buffer:Buffer;

	public var length(default, null):Int = 0;

	var lastKind:BufferKind = null;

	public function new(gl:GL2) {
		super(gl);
		buffer = gl.createBuffer();
	}

	public function getRawBuffer():Buffer {
		return buffer;
	}

	extern public inline function upload(kind:BufferKind, data:Float32Array, usage:BufferUsage):Void {
		lastKind = kind;
		gl.bindBuffer(kind, buffer);
		gl.bufferData(kind, data, usage);
		gl.bindBuffer(kind, null);
		length = data.length;
	}

	public inline function subUpload(kind:BufferKind, offset:Int, data:Float32Array):Void {
		lastKind = kind;
		gl.bindBuffer(kind, buffer);
		gl.bufferSubData(kind, offset * Float32Array.BYTES_PER_ELEMENT, data, 0);
		gl.bindBuffer(kind, null);
		length = data.length;
	}

	extern public inline function download(offset:Int, dst:Float32Array):Void {
		gl.bindBuffer(lastKind, buffer);
		gl.getBufferSubData(lastKind, offset * Float32Array.BYTES_PER_ELEMENT, dst);
		gl.bindBuffer(lastKind, null);
	}

	extern public inline function sync():Void {
		gl.bindBuffer(lastKind, buffer);
		gl.getBufferSubData(lastKind, 0, new Float32Array(1));
		gl.bindBuffer(lastKind, null);
	}

	extern public inline function vertexAttribPointer(location:Int, size:Int, stride:Int, offset:Int):Void {
		gl.bindBuffer(GL2.ARRAY_BUFFER, buffer);
		gl.vertexAttribPointer(location, size, GL2.FLOAT, false, stride, offset);
		gl.bindBuffer(GL2.ARRAY_BUFFER, null);
	}

	function disposeImpl():Void {
		gl.deleteBuffer(buffer);
	}
}
