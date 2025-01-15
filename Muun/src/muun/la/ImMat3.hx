package muun.la;

// immutable version
@:forward(t, det, tr, inv, getRow, getCol, get, toMat2, toMat4, copy)
@:access(muun.la.Mat3)
abstract ImMat3(Mat3) from Mat3 to Mat3 {
	@:op(-A)
	extern static inline function neg(a:ImMat3):Mat3
		return Mat3.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImMat3, b:ImMat3):Mat3
		return Mat3.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImMat3, b:ImMat3):Mat3
		return Mat3.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImMat3, b:ImMat3):Mat3
		return Mat3.mul(a, b);

	@:op(A * B)
	extern static inline function mulVec(a:ImMat3, b:Vec3):Vec3
		return Mat3.mulVec(a, b);

	@:op(A / B)
	extern static inline function div(a:ImMat3, b:ImMat3):Mat3
		return Mat3.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImMat3, b:Float):Mat3
		return Mat3.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImMat3, b:Float):Mat3
		return Mat3.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImMat3):Mat3
		return Mat3.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImMat3, b:Float):Mat3
		return Mat3.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImMat3, b:Float):Mat3
		return Mat3.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImMat3):Mat3
		return Mat3.fdiv(a, b);

	public var row0(get, never):ImVec3;
	public var row1(get, never):ImVec3;
	public var row2(get, never):ImVec3;
	public var col0(get, never):ImVec3;
	public var col1(get, never):ImVec3;
	public var col2(get, never):ImVec3;

	extern inline function get_row0()
		return this.row0;

	extern inline function get_row1()
		return this.row1;

	extern inline function get_row2()
		return this.row2;

	extern inline function get_col0()
		return this.col0;

	extern inline function get_col1()
		return this.col1;

	extern inline function get_col2()
		return this.col2;

	public var e00(get, never):Float;
	public var e01(get, never):Float;
	public var e02(get, never):Float;
	public var e10(get, never):Float;
	public var e11(get, never):Float;
	public var e12(get, never):Float;
	public var e20(get, never):Float;
	public var e21(get, never):Float;
	public var e22(get, never):Float;

	extern inline function get_e00()
		return this.e00;

	extern inline function get_e01()
		return this.e01;

	extern inline function get_e02()
		return this.e02;

	extern inline function get_e10()
		return this.e10;

	extern inline function get_e11()
		return this.e11;

	extern inline function get_e12()
		return this.e12;

	extern inline function get_e20()
		return this.e20;

	extern inline function get_e21()
		return this.e21;

	extern inline function get_e22()
		return this.e22;

	public function toString():String
		return 'ImMat3($e00, $e01, $e02; $e10, $e11, $e12; $e20, $e21, $e22)';
}
