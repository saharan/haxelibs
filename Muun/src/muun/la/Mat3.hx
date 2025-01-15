package muun.la;

@:forward(e00, e01, e02, e10, e11, e12, e20, e21, e22)
abstract Mat3(Mat3Data) from Mat3Data {
	inline function new(e00:Float, e01:Float, e02:Float, e10:Float, e11:Float, e12:Float, e20:Float, e21:Float,
			e22:Float) {
		this = new Mat3Data(e00, e01, e02, e10, e11, e12, e20, e21, e22);
	}

	extern public static inline function of(e00:Float, e01:Float, e02:Float, e10:Float, e11:Float, e12:Float,
			e20:Float, e21:Float, e22:Float):Mat3 {
		return new Mat3(e00, e01, e02, e10, e11, e12, e20, e21, e22);
	}

	var a(get, never):Mat3;

	extern inline function get_a()
		return this;

	public static var zero(get, never):Mat3;
	public static var one(get, never):Mat3;
	public static var id(get, never):Mat3;

	extern static inline function get_zero() {
		return of(0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	extern static inline function get_one() {
		return of(1, 1, 1, 1, 1, 1, 1, 1, 1);
	}

	extern static inline function get_id() {
		return of(1, 0, 0, 0, 1, 0, 0, 0, 1);
	}

	extern public static inline function rot(angle:Float, axis:Vec3):Mat3 {
		final s = Math.sin(angle);
		final c = Math.cos(angle);
		final c1 = 1 - c;
		final ax = axis.x;
		final ay = axis.y;
		final az = axis.z;
		return of(ax * ax * c1 + c, ax * ay * c1 - az * s, ax * az * c1 + ay * s, ay * ax * c1 + az * s, ay * ay * c1 +
			c, ay * az * c1 - ax * s, az * ax * c1 - ay * s, az * ay * c1 + ax * s, az * az * c1 + c);
	}

	extern public static inline function translate(v:Vec2):Mat3 {
		return of(1, 0, v.x, 0, 1, v.y, 0, 0, 1);
	}

	public var row0(get, set):ImVec3;
	public var row1(get, set):ImVec3;
	public var row2(get, set):ImVec3;
	public var col0(get, set):ImVec3;
	public var col1(get, set):ImVec3;
	public var col2(get, set):ImVec3;

	extern inline function get_row0() {
		return Vec3.of(a.e00, a.e01, a.e02);
	}

	extern inline function get_row1() {
		return Vec3.of(a.e10, a.e11, a.e12);
	}

	extern inline function get_row2() {
		return Vec3.of(a.e20, a.e21, a.e22);
	}

	extern inline function get_col0() {
		return Vec3.of(a.e00, a.e10, a.e20);
	}

	extern inline function get_col1() {
		return Vec3.of(a.e01, a.e11, a.e21);
	}

	extern inline function get_col2() {
		return Vec3.of(a.e02, a.e12, a.e22);
	}

	public var t(get, never):Mat3;
	public var det(get, never):Float;
	public var tr(get, never):Float;
	public var inv(get, never):Mat3;

	extern inline function get_t() {
		return of(a.e00, a.e10, a.e20, a.e01, a.e11, a.e21, a.e02, a.e12, a.e22);
	}

	extern inline function get_det() {
		final e00 = a.e00;
		final e01 = a.e01;
		final e02 = a.e02;
		final e10 = a.e10;
		final e11 = a.e11;
		final e12 = a.e12;
		final e20 = a.e20;
		final e21 = a.e21;
		final e22 = a.e22;
		return e00 * (e11 * e22 - e12 * e21) - e01 * (e10 * e22 - e12 * e20) + e02 * (e10 * e21 - e11 * e20);
	}

	extern inline function get_tr() {
		return a.e00 + a.e11 + a.e22;
	}

	extern inline function get_inv() {
		final e00 = a.e00;
		final e01 = a.e01;
		final e02 = a.e02;
		final e10 = a.e10;
		final e11 = a.e11;
		final e12 = a.e12;
		final e20 = a.e20;
		final e21 = a.e21;
		final e22 = a.e22;
		final d00 = e11 * e22 - e12 * e21;
		final d01 = e10 * e22 - e12 * e20;
		final d02 = e10 * e21 - e11 * e20;
		final d10 = e01 * e22 - e02 * e21;
		final d11 = e00 * e22 - e02 * e20;
		final d12 = e00 * e21 - e01 * e20;
		final d20 = e01 * e12 - e02 * e11;
		final d21 = e00 * e12 - e02 * e10;
		final d22 = e00 * e11 - e01 * e10;
		var idet = e00 * d00 - e01 * d01 + e02 * d02;
		if (idet != 0)
			idet = 1 / idet;
		return of(d00 * idet, -d10 * idet, d20 * idet, -d01 * idet, d11 * idet, -d21 * idet, d02 * idet, -d12 * idet,
			d22 * idet);
	}

	extern static inline function unary(a:Mat3, f:(a:Float) -> Float):Mat3 {
		return of(f(a.e00), f(a.e01), f(a.e02), f(a.e10), f(a.e11), f(a.e12), f(a.e20), f(a.e21), f(a.e22));
	}

	extern static inline function binary(a:Mat3, b:Mat3, f:(a:Float, b:Float) -> Float):Mat3 {
		return of(f(a.e00, b.e00), f(a.e01, b.e01), f(a.e02, b.e02), f(a.e10, b.e10), f(a.e11, b.e11), f(a.e12, b.e12),
			f(a.e20, b.e20), f(a.e21, b.e21), f(a.e22, b.e22));
	}

	extern public static inline function emul(a:Mat3, b:Mat3):Mat3 {
		return binary(a, b, (a, b) -> a * b);
	}

	extern public static inline function ediv(a:Mat3, b:Mat3):Mat3 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(-A)
	extern static inline function neg(a:Mat3):Mat3 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern static inline function add(a:Mat3, b:Mat3):Mat3 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern static inline function sub(a:Mat3, b:Mat3):Mat3 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern static inline function mul(a:Mat3, b:Mat3):Mat3 {
		final a00 = a.e00;
		final a01 = a.e01;
		final a02 = a.e02;
		final a10 = a.e10;
		final a11 = a.e11;
		final a12 = a.e12;
		final a20 = a.e20;
		final a21 = a.e21;
		final a22 = a.e22;
		final b00 = b.e00;
		final b01 = b.e01;
		final b02 = b.e02;
		final b10 = b.e10;
		final b11 = b.e11;
		final b12 = b.e12;
		final b20 = b.e20;
		final b21 = b.e21;
		final b22 = b.e22;
		return of(a00 * b00 + a01 * b10 + a02 * b20, a00 * b01 + a01 * b11 + a02 * b21, a00 * b02 + a01 * b12 +
			a02 * b22, a10 * b00 + a11 * b10 + a12 * b20, a10 * b01 + a11 * b11 + a12 * b21, a10 * b02 + a11 * b12 +
			a12 * b22, a20 * b00 + a21 * b10 + a22 * b20, a20 * b01 + a21 * b11 + a22 * b21, a20 * b02 + a21 * b12 +
			a22 * b22);
	}

	@:op(A * B)
	extern static inline function mulVec(a:Mat3, b:Vec3):Vec3 {
		return Vec3.of(a.e00 * b.x + a.e01 * b.y + a.e02 * b.z, a.e10 * b.x + a.e11 * b.y + a.e12 * b.z, a.e20 * b.x +
			a.e21 * b.y + a.e22 * b.z);
	}

	@:op(A / B)
	extern static inline function div(a:Mat3, b:Mat3):Mat3 {
		return a * b.inv;
	}

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:Mat3, b:Float):Mat3 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern static inline function subf(a:Mat3, b:Float):Mat3 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern static inline function fsub(a:Float, b:Mat3):Mat3 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:Mat3, b:Float):Mat3 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern static inline function divf(a:Mat3, b:Float):Mat3 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:Mat3):Mat3 {
		return a * b.inv;
	}

	extern public inline function getRow(index:Int):Vec3 {
		return switch index {
			case 0:
				row0;
			case 1:
				row1;
			case 2:
				row2;
			case _:
				throw "Mat3 row index out of bounds: " + index;
		}
	}

	extern public inline function getCol(index:Int):Vec3 {
		return switch index {
			case 0:
				col0;
			case 1:
				col1;
			case 2:
				col2;
			case _:
				throw "Mat3 column index out of bounds: " + index;
		}
	}

	extern public inline function get(rowIndex:Int, colIndex:Int):Float {
		return getRow(rowIndex)[colIndex];
	}

	extern public inline function toMat2():Mat2 {
		return Mat2.of(a.e00, a.e01, a.e10, a.e11);
	}

	extern public inline function toMat4():Mat4 {
		return Mat4.of(a.e00, a.e01, a.e02, 0, a.e10, a.e11, a.e12, 0, a.e20, a.e21, a.e22, 0, 0, 0, 0, 1);
	}

	extern public inline function toAffineMat2():Mat2 {
		return Mat2.of(a.e00, a.e02, 0, 1);
	}

	extern public inline function toAffineMat4():Mat4 {
		return Mat4.of(a.e00, a.e01, 0, a.e02, a.e10, a.e11, 0, a.e12, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	extern public inline function copy():Mat3 {
		return of(a.e00, a.e01, a.e02, a.e10, a.e11, a.e12, a.e20, a.e21, a.e22);
	}

	public function toString():String {
		return 'Mat3(${a.e00}, ${a.e01}, ${a.e02}; ${a.e10}, ${a.e11}, ${a.e12}; ${a.e20}, ${a.e21}, ${a.e22})';
	}

	// following methods mutate the state

	@:op(A <<= B)
	extern inline function assign(b:Mat3):Mat3 {
		a.e00 = b.e00;
		a.e01 = b.e01;
		a.e02 = b.e02;
		a.e10 = b.e10;
		a.e11 = b.e11;
		a.e12 = b.e12;
		a.e20 = b.e20;
		a.e21 = b.e21;
		a.e22 = b.e22;
		return a;
	}

	@:op(A += B)
	extern inline function addEq(b:Mat3):Mat3 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subEq(b:Mat3):Mat3 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulEq(b:Mat3):Mat3 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divEq(b:Mat3):Mat3 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern inline function addfEq(b:Float):Mat3 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subfEq(b:Float):Mat3 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulfEq(b:Float):Mat3 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divfEq(b:Float):Mat3 {
		return a <<= a / b;
	}

	extern public inline function set(e00:Float, e01:Float, e02:Float, e10:Float, e11:Float, e12:Float, e20:Float,
			e21:Float, e22:Float):Mat3 {
		return a <<= of(e00, e01, e02, e10, e11, e12, e20, e21, e22);
	}

	extern inline function set_row0(v) {
		a.e00 = v.x;
		a.e01 = v.y;
		a.e02 = v.z;
		return row0;
	}

	extern inline function set_row1(v) {
		a.e10 = v.x;
		a.e11 = v.y;
		a.e12 = v.z;
		return row1;
	}

	extern inline function set_row2(v) {
		a.e20 = v.x;
		a.e21 = v.y;
		a.e22 = v.z;
		return row2;
	}

	extern inline function set_col0(v) {
		a.e00 = v.x;
		a.e10 = v.y;
		a.e20 = v.z;
		return col0;
	}

	extern inline function set_col1(v) {
		a.e01 = v.x;
		a.e11 = v.y;
		a.e21 = v.z;
		return col1;
	}

	extern inline function set_col2(v) {
		a.e02 = v.x;
		a.e12 = v.y;
		a.e22 = v.z;
		return col2;
	}
}

private class Mat3Data {
	public var e00:Float;
	public var e01:Float;
	public var e02:Float;
	public var e10:Float;
	public var e11:Float;
	public var e12:Float;
	public var e20:Float;
	public var e21:Float;
	public var e22:Float;

	public inline function new(e00:Float, e01:Float, e02:Float, e10:Float, e11:Float, e12:Float, e20:Float, e21:Float,
			e22:Float) {
		this.e00 = e00;
		this.e01 = e01;
		this.e02 = e02;
		this.e10 = e10;
		this.e11 = e11;
		this.e12 = e12;
		this.e20 = e20;
		this.e21 = e21;
		this.e22 = e22;
	}
}
