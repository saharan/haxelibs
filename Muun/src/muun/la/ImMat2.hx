package muun.la;

// immutable version
@:forward(t, det, tr, inv, getRow, getCol, get, toMat3, toMat4, copy)
@:access(muun.la.Mat2)
abstract ImMat2(Mat2) from Mat2 to Mat2 {
	@:op(-A)
	extern static inline function neg(a:ImMat2):Mat2
		return Mat2.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImMat2, b:ImMat2):Mat2
		return Mat2.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImMat2, b:ImMat2):Mat2
		return Mat2.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImMat2, b:ImMat2):Mat2
		return Mat2.mul(a, b);

	@:op(A * B)
	extern static inline function mulVec(a:ImMat2, b:Vec2):Vec2
		return Mat2.mulVec(a, b);

	@:op(A / B)
	extern static inline function div(a:ImMat2, b:ImMat2):Mat2
		return Mat2.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImMat2, b:Float):Mat2
		return Mat2.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImMat2, b:Float):Mat2
		return Mat2.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImMat2):Mat2
		return Mat2.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImMat2, b:Float):Mat2
		return Mat2.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImMat2, b:Float):Mat2
		return Mat2.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImMat2):Mat2
		return Mat2.fdiv(a, b);

	public var row0(get, never):ImVec2;
	public var row1(get, never):ImVec2;
	public var col0(get, never):ImVec2;
	public var col1(get, never):ImVec2;

	extern inline function get_row0()
		return this.row0;

	extern inline function get_row1()
		return this.row1;

	extern inline function get_col0()
		return this.col0;

	extern inline function get_col1()
		return this.col1;

	public var e00(get, never):Float;
	public var e01(get, never):Float;
	public var e10(get, never):Float;
	public var e11(get, never):Float;

	extern inline function get_e00()
		return this.e00;

	extern inline function get_e01()
		return this.e01;

	extern inline function get_e10()
		return this.e10;

	extern inline function get_e11()
		return this.e11;

	public function toString():String
		return 'ImMat2($e00, $e01; $e10, $e11)';
}
