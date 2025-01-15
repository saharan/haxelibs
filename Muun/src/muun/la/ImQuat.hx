package muun.la;

// immutable version
@:forward(length, lengthSq, conj, inv, normalized, dot, toMat3, toVec4, copy)
@:access(muun.la.Quat)
abstract ImQuat(Quat) from Quat to Quat {
	@:op(-A)
	extern static inline function neg(a:ImQuat):Quat
		return Quat.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImQuat, b:ImQuat):Quat
		return Quat.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImQuat, b:ImQuat):Quat
		return Quat.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImQuat, b:ImQuat):Quat
		return Quat.mul(a, b);

	@:op(A * B)
	extern static inline function mulVec(a:ImQuat, b:Vec3):Vec3
		return Quat.mulVec(a, b);

	@:op(A / B)
	extern static inline function div(a:ImQuat, b:ImQuat):Quat
		return Quat.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImQuat, b:Float):Quat
		return Quat.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImQuat, b:Float):Quat
		return Quat.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImQuat):Quat
		return Quat.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImQuat, b:Float):Quat
		return Quat.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImQuat, b:Float):Quat
		return Quat.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImQuat):Quat
		return Quat.fdiv(a, b);

	public var vec(get, never):ImVec3;

	extern inline function get_vec()
		return this.vec;

	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;
	public var w(get, never):Float;

	extern inline function get_x()
		return this.x;

	extern inline function get_y()
		return this.y;

	extern inline function get_z()
		return this.z;

	extern inline function get_w()
		return this.w;

	public function toString():String
		return 'ImQuat($x, $y, $z; $w)';
}
