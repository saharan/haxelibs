package pot.graphics.gl;

import js.lib.Float32Array;
import pot.graphics.gl.low.BufferKind;
import pot.graphics.gl.low.BufferUsage;
import pot.graphics.gl.low.FloatBuffer;

class FloatBufferWriter {
	public final buffer:FloatBuffer;
	public var kind:BufferKind;
	public var usage:BufferUsage;
	public var data(default, null):Float32Array = new Float32Array(512);
	public var length(default, null):Int = 0;

	var maxLength:Int;
	var changed:Bool = false;

	public function new(buffer:FloatBuffer, kind:BufferKind, usage:BufferUsage) {
		this.buffer = buffer;
		this.kind = kind;
		this.usage = usage;
		maxLength = data.length;
	}

	extern public inline function clear():Void {
		length = 0;
		changed = true;
	}

	overload extern public inline function push(f:Float):Void {
		if (length + 1 > maxLength) {
			expand();
		}
		data[length++] = f;
		changed = true;
	}

	overload extern public inline function push(f1:Float, f2:Float):Void {
		if (length + 2 > maxLength) {
			expand();
		}
		data[length++] = f1;
		data[length++] = f2;
		changed = true;
	}

	overload extern public inline function push(f1:Float, f2:Float, f3:Float):Void {
		if (length + 3 > maxLength) {
			expand();
		}
		data[length++] = f1;
		data[length++] = f2;
		data[length++] = f3;
		changed = true;
	}

	overload extern public inline function push(f1:Float, f2:Float, f3:Float, f4:Float):Void {
		if (length + 4 > maxLength) {
			expand();
		}
		data[length++] = f1;
		data[length++] = f2;
		data[length++] = f3;
		data[length++] = f4;
		changed = true;
	}

	extern public inline function upload(force:Bool = false):Void {
		if (changed || force) {
			changed = false;
			buffer.upload(kind, new Float32Array(data.buffer, 0, length), usage);
		}
	}

	extern inline function expand():Void {
		final oldData = data;
		data = new Float32Array(maxLength <<= 1);
		data.set(oldData);
	}
}
