package muun.la;

// immutable version
@:forward(t, det, tr, inv, getRow, getCol, get, toMat2, toMat3, copy)
@:access(muun.la.Mat4)
abstract ImMat4(Mat4) from Mat4 to Mat4 {
	@:op(-A)
	extern static inline function neg(a:ImMat4):Mat4
		return Mat4.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImMat4, b:ImMat4):Mat4
		return Mat4.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImMat4, b:ImMat4):Mat4
		return Mat4.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImMat4, b:ImMat4):Mat4
		return Mat4.mul(a, b);

	@:op(A * B)
	extern static inline function mulVec(a:ImMat4, b:Vec4):Vec4
		return Mat4.mulVec(a, b);

	@:op(A / B)
	extern static inline function div(a:ImMat4, b:ImMat4):Mat4
		return Mat4.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImMat4, b:Float):Mat4
		return Mat4.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImMat4, b:Float):Mat4
		return Mat4.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImMat4):Mat4
		return Mat4.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImMat4, b:Float):Mat4
		return Mat4.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImMat4, b:Float):Mat4
		return Mat4.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImMat4):Mat4
		return Mat4.fdiv(a, b);

	public var row0(get, never):ImVec4;
	public var row1(get, never):ImVec4;
	public var row2(get, never):ImVec4;
	public var row3(get, never):ImVec4;
	public var col0(get, never):ImVec4;
	public var col1(get, never):ImVec4;
	public var col2(get, never):ImVec4;
	public var col3(get, never):ImVec4;

	extern inline function get_row0()
		return this.row0;

	extern inline function get_row1()
		return this.row1;

	extern inline function get_row2()
		return this.row2;

	extern inline function get_row3()
		return this.row3;

	extern inline function get_col0()
		return this.col0;

	extern inline function get_col1()
		return this.col1;

	extern inline function get_col2()
		return this.col2;

	extern inline function get_col3()
		return this.col3;

	public var e00(get, never):Float;
	public var e01(get, never):Float;
	public var e02(get, never):Float;
	public var e03(get, never):Float;
	public var e10(get, never):Float;
	public var e11(get, never):Float;
	public var e12(get, never):Float;
	public var e13(get, never):Float;
	public var e20(get, never):Float;
	public var e21(get, never):Float;
	public var e22(get, never):Float;
	public var e23(get, never):Float;
	public var e30(get, never):Float;
	public var e31(get, never):Float;
	public var e32(get, never):Float;
	public var e33(get, never):Float;

	extern inline function get_e00()
		return this.e00;

	extern inline function get_e01()
		return this.e01;

	extern inline function get_e02()
		return this.e02;

	extern inline function get_e03()
		return this.e03;

	extern inline function get_e10()
		return this.e10;

	extern inline function get_e11()
		return this.e11;

	extern inline function get_e12()
		return this.e12;

	extern inline function get_e13()
		return this.e13;

	extern inline function get_e20()
		return this.e20;

	extern inline function get_e21()
		return this.e21;

	extern inline function get_e22()
		return this.e22;

	extern inline function get_e23()
		return this.e23;

	extern inline function get_e30()
		return this.e30;

	extern inline function get_e31()
		return this.e31;

	extern inline function get_e32()
		return this.e32;

	extern inline function get_e33()
		return this.e33;

	public function toString():String
		return 'ImMat4($e00, $e01, $e02, $e03; $e10, $e11, $e12, $e13; $e20, $e21, $e22, $e23; $e30, $e31, $e32, $e33)';
}
