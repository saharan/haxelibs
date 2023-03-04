package pot.graphics.gl;

import pot.graphics.gl.Texture;

enum UniformValue {
	Float(x:Float);
	Vec2(x:Float, y:Float);
	Vec3(x:Float, y:Float, z:Float);
	Vec4(x:Float, y:Float, z:Float, w:Float);
	Int(x:Int);
	IVec2(x:Int, y:Int);
	IVec3(x:Int, y:Int, z:Int);
	IVec4(x:Int, y:Int, z:Int, w:Int);
	UInt(x:UInt);
	UVec2(x:UInt, y:UInt);
	UVec3(x:UInt, y:UInt, z:UInt);
	UVec4(x:UInt, y:UInt, z:UInt, w:UInt);
	Bool(x:Bool);
	BVec2(x:Bool, y:Bool);
	BVec3(x:Bool, y:Bool, z:Bool);
	BVec4(x:Bool, y:Bool, z:Bool, w:Bool);
	Mat(cols:Int, rows:Int, vs:Array<Float>);
	Sampler(t:Texture);
	Floats(vs:Array<Float>);
	Vecs(vs:Array<Array<Float>>);
	Ints(vs:Array<Int>);
	IVecs(vs:Array<Array<Int>>);
	UInts(vs:Array<UInt>);
	UVecs(vs:Array<Array<UInt>>);
	Bools(vs:Array<Bool>);
	BVecs(vs:Array<Array<Bool>>);
	Mats(cols:Int, rows:Int, vs:Array<Array<Float>>);
	Samplers(ts:Array<Texture>);
}
