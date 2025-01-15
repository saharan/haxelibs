package muun.la;

// immutable version
@:forward(length, lengthSq, normalized, diag, dot, tensorDot, cross, crossMat, abs, min, max, clamp, map, extend,
	extend, copy, xx, xy, xz, yx, yy, yz, zx, zy, zz, xxx, xxy, xxz, xyx, xyy, xyz, xzx, xzy, xzz, yxx, yxy, yxz, yyx,
	yyy, yyz, yzx, yzy, yzz, zxx, zxy, zxz, zyx, zyy, zyz, zzx, zzy, zzz, xxxx, xxxy, xxxz, xxyx, xxyy, xxyz, xxzx,
	xxzy, xxzz, xyxx, xyxy, xyxz, xyyx, xyyy, xyyz, xyzx, xyzy, xyzz, xzxx, xzxy, xzxz, xzyx, xzyy, xzyz, xzzx, xzzy,
	xzzz, yxxx, yxxy, yxxz, yxyx, yxyy, yxyz, yxzx, yxzy, yxzz, yyxx, yyxy, yyxz, yyyx, yyyy, yyyz, yyzx, yyzy, yyzz,
	yzxx, yzxy, yzxz, yzyx, yzyy, yzyz, yzzx, yzzy, yzzz, zxxx, zxxy, zxxz, zxyx, zxyy, zxyz, zxzx, zxzy, zxzz, zyxx,
	zyxy, zyxz, zyyx, zyyy, zyyz, zyzx, zyzy, zyzz, zzxx, zzxy, zzxz, zzyx, zzyy, zzyz, zzzx, zzzy, zzzz)
@:access(muun.la.Vec3)
abstract ImVec3(Vec3) from Vec3 to Vec3 {
	@:op(-A)
	extern static inline function neg(a:ImVec3):Vec3
		return Vec3.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImVec3, b:ImVec3):Vec3
		return Vec3.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImVec3, b:ImVec3):Vec3
		return Vec3.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImVec3, b:ImVec3):Vec3
		return Vec3.mul(a, b);

	@:op(A / B)
	extern static inline function div(a:ImVec3, b:ImVec3):Vec3
		return Vec3.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImVec3, b:Float):Vec3
		return Vec3.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImVec3, b:Float):Vec3
		return Vec3.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImVec3):Vec3
		return Vec3.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImVec3, b:Float):Vec3
		return Vec3.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImVec3, b:Float):Vec3
		return Vec3.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImVec3):Vec3
		return Vec3.fdiv(a, b);

	@:arrayAccess
	function get(index:Int):Float;

	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;

	extern inline function get_x()
		return this.x;

	extern inline function get_y()
		return this.y;

	extern inline function get_z()
		return this.z;

	public function toString():String
		return 'ImVec3($x, $y, $z)';
}
