package pot.graphics.gl;

import muun.la.Vec2;
import muun.la.Vec3;
import muun.la.Vec4;
import pot.graphics.gl.low.FloatBuffer;
import pot.graphics.gl.low.IntBuffer;

class ObjectWriter {
	public final positionWriter:FloatBufferWriter;
	public final colorWriter:FloatBufferWriter;
	public final normalWriter:FloatBufferWriter;
	public final texCoordWriter:FloatBufferWriter;
	public final indexWriter:IntBufferWriter;

	var cr:Float = 1;
	var cg:Float = 1;
	var cb:Float = 1;
	var ca:Float = 1;
	var nx:Float = 0;
	var ny:Float = 0;
	var nz:Float = 0;
	var u:Float = 0;
	var v:Float = 0;
	var numVertices:Int = 0;

	public function new(position:FloatBuffer, color:FloatBuffer, normal:FloatBuffer, texCoord:FloatBuffer, index:IntBuffer) {
		positionWriter = new FloatBufferWriter(position, ArrayBuffer, DynamicDraw);
		colorWriter = new FloatBufferWriter(color, ArrayBuffer, DynamicDraw);
		normalWriter = new FloatBufferWriter(normal, ArrayBuffer, DynamicDraw);
		texCoordWriter = new FloatBufferWriter(texCoord, ArrayBuffer, DynamicDraw);
		indexWriter = new IntBufferWriter(index, ElementArrayBuffer, DynamicDraw);
	}

	public function clear():Void {
		positionWriter.clear();
		colorWriter.clear();
		normalWriter.clear();
		texCoordWriter.clear();
		indexWriter.clear();
		numVertices = 0;
	}

	overload extern public inline function color(rgb:Vec3, a:Float = 1):Void {
		color(rgb.x, rgb.y, rgb.z, a);
	}

	overload extern public inline function color(rgba:Vec4):Void {
		color(rgba.x, rgba.y, rgba.z, rgba.w);
	}

	overload extern public inline function normal(n:Vec3):Void {
		normal(n.x, n.y, n.z);
	}

	overload extern public inline function texCoord(uv:Vec2):Void {
		texCoord(uv.x, uv.y);
	}

	overload extern public inline function color(r:Float, g:Float, b:Float, a:Float = 1):Void {
		cr = r;
		cg = g;
		cb = b;
		ca = a;
	}

	overload extern public inline function normal(nx:Float, ny:Float, nz:Float):Void {
		this.nx = nx;
		this.ny = ny;
		this.nz = nz;
	}

	overload extern public inline function texCoord(u:Float, v:Float):Void {
		this.u = u;
		this.v = v;
	}

	overload extern public inline function vertex(p:Vec3, addIndex:Bool = true):Int {
		return vertex(p.x, p.y, p.z, addIndex);
	}

	overload extern public inline function vertex(x:Float, y:Float, z:Float, addIndex:Bool = true):Int {
		positionWriter.push(x, y, z);
		colorWriter.push(cr, cg, cb, ca);
		normalWriter.push(nx, ny, nz);
		texCoordWriter.push(u, v);
		if (addIndex)
			indexWriter.push(numVertices);
		return numVertices++;
	}

	overload extern public inline function index(i:Int):Void {
		indexWriter.push(i);
	}

	overload extern public inline function index(i1:Int, i2:Int):Void {
		indexWriter.push(i1, i2);
	}

	overload extern public inline function index(i1:Int, i2:Int, i3:Int):Void {
		indexWriter.push(i1, i2, i3);
	}

	public function upload():Void {
		positionWriter.upload();
		colorWriter.upload();
		normalWriter.upload();
		texCoordWriter.upload();
		indexWriter.upload();
	}
}
