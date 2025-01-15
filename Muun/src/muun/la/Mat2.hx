package muun.la;

@:forward(e00, e01, e10, e11)
abstract Mat2(Mat2Data) from Mat2Data {
	inline function new(e00:Float, e01:Float, e10:Float, e11:Float) {
		this = new Mat2Data(e00, e01, e10, e11);
	}

	extern public static inline function of(e00:Float, e01:Float, e10:Float, e11:Float):Mat2 {
		return new Mat2(e00, e01, e10, e11);
	}

	var a(get, never):Mat2;

	extern inline function get_a()
		return this;

	public static var zero(get, never):Mat2;
	public static var one(get, never):Mat2;
	public static var id(get, never):Mat2;

	extern static inline function get_zero() {
		return of(0, 0, 0, 0);
	}

	extern static inline function get_one() {
		return of(1, 1, 1, 1);
	}

	extern static inline function get_id() {
		return of(1, 0, 0, 1);
	}

	extern public static inline function rot(angle:Float):Mat2 {
		final s = Math.sin(angle);
		final c = Math.cos(angle);
		return of(c, -s, s, c);
	}

	public var row0(get, set):ImVec2;
	public var row1(get, set):ImVec2;
	public var col0(get, set):ImVec2;
	public var col1(get, set):ImVec2;

	extern inline function get_row0() {
		return Vec2.of(a.e00, a.e01);
	}

	extern inline function get_row1() {
		return Vec2.of(a.e10, a.e11);
	}

	extern inline function get_col0() {
		return Vec2.of(a.e00, a.e10);
	}

	extern inline function get_col1() {
		return Vec2.of(a.e01, a.e11);
	}

	public var t(get, never):Mat2;
	public var det(get, never):Float;
	public var tr(get, never):Float;
	public var inv(get, never):Mat2;

	extern inline function get_t() {
		return of(a.e00, a.e10, a.e01, a.e11);
	}

	extern inline function get_det() {
		return a.e00 * a.e11 - a.e01 * a.e10;
	}

	extern inline function get_tr() {
		return a.e00 + a.e11;
	}

	extern inline function get_inv() {
		var idet = a.e00 * a.e11 - a.e01 * a.e10;
		if (idet != 0)
			idet = 1 / idet;
		return of(a.e11 * idet, -a.e01 * idet, -a.e10 * idet, a.e00 * idet);
	}

	extern static inline function unary(a:Mat2, f:(a:Float) -> Float):Mat2 {
		return of(f(a.e00), f(a.e01), f(a.e10), f(a.e11));
	}

	extern static inline function binary(a:Mat2, b:Mat2, f:(a:Float, b:Float) -> Float):Mat2 {
		return of(f(a.e00, b.e00), f(a.e01, b.e01), f(a.e10, b.e10), f(a.e11, b.e11));
	}

	extern public static inline function emul(a:Mat2, b:Mat2):Mat2 {
		return binary(a, b, (a, b) -> a * b);
	}

	extern public static inline function ediv(a:Mat2, b:Mat2):Mat2 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(-A)
	extern static inline function neg(a:Mat2):Mat2 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern static inline function add(a:Mat2, b:Mat2):Mat2 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern static inline function sub(a:Mat2, b:Mat2):Mat2 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern static inline function mul(a:Mat2, b:Mat2):Mat2 {
		return of(a.e00 * b.e00 + a.e01 * b.e10, a.e00 * b.e01 + a.e01 * b.e11, a.e10 * b.e00 + a.e11 * b.e10,
			a.e10 * b.e01 + a.e11 * b.e11);
	}

	@:op(A * B)
	extern static inline function mulVec(a:Mat2, b:Vec2):Vec2 {
		return Vec2.of(a.e00 * b.x + a.e01 * b.y, a.e10 * b.x + a.e11 * b.y);
	}

	@:op(A / B)
	extern static inline function div(a:Mat2, b:Mat2):Mat2 {
		return a * b.inv;
	}

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:Mat2, b:Float):Mat2 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern static inline function subf(a:Mat2, b:Float):Mat2 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern static inline function fsub(a:Float, b:Mat2):Mat2 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:Mat2, b:Float):Mat2 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern static inline function divf(a:Mat2, b:Float):Mat2 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:Mat2):Mat2 {
		return a * b.inv;
	}

	extern public inline function getRow(index:Int):Vec2 {
		return switch index {
			case 0:
				row0;
			case 1:
				row1;
			case _:
				throw "Mat2 row index out of bounds: " + index;
		}
	}

	extern public inline function getCol(index:Int):Vec2 {
		return switch index {
			case 0:
				col0;
			case 1:
				col1;
			case _:
				throw "Mat2 column index out of bounds: " + index;
		}
	}

	extern public inline function get(rowIndex:Int, colIndex:Int):Float {
		return getRow(rowIndex)[colIndex];
	}

	extern public inline function toMat3():Mat3 {
		return Mat3.of(a.e00, a.e01, 0, a.e10, a.e11, 0, 0, 0, 1);
	}

	extern public inline function toMat4():Mat4 {
		return Mat4.of(a.e00, a.e01, 0, 0, a.e10, a.e11, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	extern public inline function toAffineMat3():Mat3 {
		return Mat3.of(a.e00, 0, a.e01, 0, 1, 0, 0, 0, 1);
	}

	extern public inline function toAffineMat4():Mat4 {
		return Mat4.of(a.e00, 0, 0, a.e01, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	extern public inline function copy():Mat2 {
		return of(a.e00, a.e01, a.e10, a.e11);
	}

	public function toString():String {
		return 'Mat3(${a.e00}, ${a.e01}; ${a.e10}, ${a.e11})';
	}

	// following methods mutate the state

	@:op(A <<= B)
	extern inline function assign(b:Mat2):Mat2 {
		a.e00 = b.e00;
		a.e01 = b.e01;
		a.e10 = b.e10;
		a.e11 = b.e11;
		return a;
	}

	@:op(A += B)
	extern inline function addEq(b:Mat2):Mat2 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subEq(b:Mat2):Mat2 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulEq(b:Mat2):Mat2 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divEq(b:Mat2):Mat2 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern inline function addfEq(b:Float):Mat2 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subfEq(b:Float):Mat2 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulfEq(b:Float):Mat2 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divfEq(b:Float):Mat2 {
		return a <<= a / b;
	}

	extern public inline function set(e00:Float, e01:Float, e10:Float, e11:Float):Mat2 {
		return a <<= of(e00, e01, e10, e11);
	}

	extern inline function set_row0(v) {
		a.e00 = v.x;
		a.e01 = v.y;
		return row0;
	}

	extern inline function set_row1(v) {
		a.e10 = v.x;
		a.e11 = v.y;
		return row1;
	}

	extern inline function set_col0(v) {
		a.e00 = v.x;
		a.e10 = v.y;
		return col0;
	}

	extern inline function set_col1(v) {
		a.e01 = v.x;
		a.e11 = v.y;
		return col1;
	}
}

private class Mat2Data {
	public var e00:Float;
	public var e01:Float;
	public var e10:Float;
	public var e11:Float;

	public inline function new(e00:Float, e01:Float, e10:Float, e11:Float) {
		this.e00 = e00;
		this.e01 = e01;
		this.e10 = e10;
		this.e11 = e11;
	}
}
