package pot.graphics.gl;

import js.lib.Int32Array;
import pot.graphics.gl.low.BufferKind;
import pot.graphics.gl.low.BufferUsage;
import pot.graphics.gl.low.IntBuffer;

class IntBufferWriter {
	public final buffer:IntBuffer;
	public var kind:BufferKind;
	public var usage:BufferUsage;
	public var data(default, null):Int32Array = new Int32Array(512);
	public var length(default, null):Int = 0;

	var maxLength:Int;
	var changed:Bool = false;

	public function new(buffer:IntBuffer, kind:BufferKind, usage:BufferUsage) {
		this.buffer = buffer;
		this.kind = kind;
		this.usage = usage;
		maxLength = data.length;
	}

	extern public inline function clear():Void {
		length = 0;
		changed = true;
	}

	overload extern public inline function push(i:Int):Void {
		if (length + 1 > maxLength) {
			expand();
		}
		data[length++] = i;
		changed = true;
	}

	overload extern public inline function push(i1:Int, i2:Int):Void {
		if (length + 2 > maxLength) {
			expand();
		}
		data[length++] = i1;
		data[length++] = i2;
		changed = true;
	}

	overload extern public inline function push(i1:Int, i2:Int, i3:Int):Void {
		if (length + 3 > maxLength) {
			expand();
		}
		data[length++] = i1;
		data[length++] = i2;
		data[length++] = i3;
		changed = true;
	}

	overload extern public inline function push(i1:Int, i2:Int, i3:Int, i4:Int):Void {
		if (length + 4 > maxLength) {
			expand();
		}
		data[length++] = i1;
		data[length++] = i2;
		data[length++] = i3;
		data[length++] = i4;
		changed = true;
	}

	extern public inline function upload(force:Bool = false):Void {
		if (changed || force) {
			changed = false;
			buffer.upload(kind, new Int32Array(data.buffer, 0, length), usage);
		}
	}

	extern inline function expand():Void {
		final oldData = data;
		data = new Int32Array(maxLength <<= 1);
		data.set(oldData);
	}
}
