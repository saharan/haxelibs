package muun.la;

@:forward(e00, e01, e02, e03, e10, e11, e12, e13, e20, e21, e22, e23, e30, e31, e32, e33)
abstract Mat4(Mat4Data) from Mat4Data {
	inline function new(e00:Float, e01:Float, e02:Float, e03:Float, e10:Float, e11:Float, e12:Float, e13:Float,
			e20:Float, e21:Float, e22:Float, e23:Float, e30:Float, e31:Float, e32:Float, e33:Float) {
		this = new Mat4Data(e00, e01, e02, e03, e10, e11, e12, e13, e20, e21, e22, e23, e30, e31, e32, e33);
	}

	extern public static inline function of(e00:Float, e01:Float, e02:Float, e03:Float, e10:Float, e11:Float,
			e12:Float, e13:Float, e20:Float, e21:Float, e22:Float, e23:Float, e30:Float, e31:Float, e32:Float,
			e33:Float):Mat4 {
		return new Mat4(e00, e01, e02, e03, e10, e11, e12, e13, e20, e21, e22, e23, e30, e31, e32, e33);
	}

	var a(get, never):Mat4;

	extern inline function get_a()
		return this;

	public static var zero(get, never):Mat4;
	public static var one(get, never):Mat4;
	public static var id(get, never):Mat4;

	extern static inline function get_zero() {
		return of(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
	}

	extern static inline function get_one() {
		return of(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
	}

	extern static inline function get_id() {
		return of(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	}

	extern public static inline function lookAt(eye:Vec3, at:Vec3, up:Vec3):Mat4 {
		final z = (eye - at).normalized;
		final x = up.cross(z).normalized;
		final y = z.cross(x);
		return of(x.x, x.y, x.z, -x.dot(eye), y.x, y.y, y.z, -y.dot(eye), z.x, z.y, z.z, -z.dot(eye), 0, 0, 0, 1);
	}

	extern public static inline function perspective(fovY:Float, aspect:Float, near:Float, far:Float):Mat4 {
		final h = 1 / Math.tan(fovY * 0.5);
		return of(h / aspect, 0, 0, 0, 0, h, 0, 0, 0, 0, -(far + near) / (far - near), -2 * near * far / (far - near),
			0, 0, -1, 0);
	}

	extern public static inline function orthographic(width:Float, height:Float, near:Float, far:Float):Mat4 {
		final nf = 1 / (near - far);
		return of(2 / width, 0, 0, 0, 0, 2 / height, 0, 0, 0, 0, nf, near * nf, 0, 0, 0, 1);
	}

	extern public static inline function translate(v:Vec3):Mat4 {
		return of(1, 0, 0, v.x, 0, 1, 0, v.y, 0, 0, 1, v.z, 0, 0, 0, 1);
	}

	public var row0(get, set):ImVec4;
	public var row1(get, set):ImVec4;
	public var row2(get, set):ImVec4;
	public var row3(get, set):ImVec4;
	public var col0(get, set):ImVec4;
	public var col1(get, set):ImVec4;
	public var col2(get, set):ImVec4;
	public var col3(get, set):ImVec4;

	extern inline function get_row0() {
		return Vec4.of(a.e00, a.e01, a.e02, a.e03);
	}

	extern inline function get_row1() {
		return Vec4.of(a.e10, a.e11, a.e12, a.e13);
	}

	extern inline function get_row2() {
		return Vec4.of(a.e20, a.e21, a.e22, a.e23);
	}

	extern inline function get_row3() {
		return Vec4.of(a.e30, a.e31, a.e32, a.e33);
	}

	extern inline function get_col0() {
		return Vec4.of(a.e00, a.e10, a.e20, a.e30);
	}

	extern inline function get_col1() {
		return Vec4.of(a.e01, a.e11, a.e21, a.e31);
	}

	extern inline function get_col2() {
		return Vec4.of(a.e02, a.e12, a.e22, a.e32);
	}

	extern inline function get_col3() {
		return Vec4.of(a.e03, a.e13, a.e23, a.e33);
	}

	public var t(get, never):Mat4;
	public var det(get, never):Float;
	public var tr(get, never):Float;
	public var inv(get, never):Mat4;

	extern inline function get_t() {
		return of(a.e00, a.e10, a.e20, a.e30, a.e01, a.e11, a.e21, a.e31, a.e02, a.e12, a.e22, a.e32, a.e03, a.e13,
			a.e23, a.e33);
	}

	extern inline function get_det() {
		final e00 = a.e00;
		final e01 = a.e01;
		final e02 = a.e02;
		final e03 = a.e03;
		final e10 = a.e10;
		final e11 = a.e11;
		final e12 = a.e12;
		final e13 = a.e13;
		final e20 = a.e20;
		final e21 = a.e21;
		final e22 = a.e22;
		final e23 = a.e23;
		final e30 = a.e30;
		final e31 = a.e31;
		final e32 = a.e32;
		final e33 = a.e33;
		final d2301 = e20 * e31 - e21 * e30;
		final d2302 = e20 * e32 - e22 * e30;
		final d2303 = e20 * e33 - e23 * e30;
		final d2312 = e21 * e32 - e22 * e31;
		final d2313 = e21 * e33 - e23 * e31;
		final d2323 = e22 * e33 - e23 * e32;
		return e00 * (e11 * d2323 - e12 * d2313 + e13 * d2312) - e01 * (e10 * d2323 - e12 * d2303 + e13 * d2302) +
			e02 * (e10 * d2313 - e11 * d2303 + e13 * d2301) - e03 * (e10 * d2312 - e11 * d2302 + e12 * d2301);
	}

	extern inline function get_tr() {
		return a.e00 + a.e11 + a.e22 + a.e33;
	}

	extern inline function get_inv() {
		final e00 = a.e00;
		final e01 = a.e01;
		final e02 = a.e02;
		final e03 = a.e03;
		final e10 = a.e10;
		final e11 = a.e11;
		final e12 = a.e12;
		final e13 = a.e13;
		final e20 = a.e20;
		final e21 = a.e21;
		final e22 = a.e22;
		final e23 = a.e23;
		final e30 = a.e30;
		final e31 = a.e31;
		final e32 = a.e32;
		final e33 = a.e33;
		final d0101 = e00 * e11 - e01 * e10;
		final d0102 = e00 * e12 - e02 * e10;
		final d0103 = e00 * e13 - e03 * e10;
		final d0112 = e01 * e12 - e02 * e11;
		final d0113 = e01 * e13 - e03 * e11;
		final d0123 = e02 * e13 - e03 * e12;
		final d2301 = e20 * e31 - e21 * e30;
		final d2302 = e20 * e32 - e22 * e30;
		final d2303 = e20 * e33 - e23 * e30;
		final d2312 = e21 * e32 - e22 * e31;
		final d2313 = e21 * e33 - e23 * e31;
		final d2323 = e22 * e33 - e23 * e32;
		final d00 = e11 * d2323 - e12 * d2313 + e13 * d2312;
		final d01 = e10 * d2323 - e12 * d2303 + e13 * d2302;
		final d02 = e10 * d2313 - e11 * d2303 + e13 * d2301;
		final d03 = e10 * d2312 - e11 * d2302 + e12 * d2301;
		final d10 = e01 * d2323 - e02 * d2313 + e03 * d2312;
		final d11 = e00 * d2323 - e02 * d2303 + e03 * d2302;
		final d12 = e00 * d2313 - e01 * d2303 + e03 * d2301;
		final d13 = e00 * d2312 - e01 * d2302 + e02 * d2301;
		final d20 = e31 * d0123 - e32 * d0113 + e33 * d0112;
		final d21 = e30 * d0123 - e32 * d0103 + e33 * d0102;
		final d22 = e30 * d0113 - e31 * d0103 + e33 * d0101;
		final d23 = e30 * d0112 - e31 * d0102 + e32 * d0101;
		final d30 = e21 * d0123 - e22 * d0113 + e23 * d0112;
		final d31 = e20 * d0123 - e22 * d0103 + e23 * d0102;
		final d32 = e20 * d0113 - e21 * d0103 + e23 * d0101;
		final d33 = e20 * d0112 - e21 * d0102 + e22 * d0101;
		var idet = e00 * d00 - e01 * d01 + e02 * d02 - e03 * d03;
		if (idet != 0)
			idet = 1 / idet;
		return of(d00 * idet, -d10 * idet, d20 * idet, -d30 * idet, -d01 * idet, d11 * idet, -d21 * idet, d31 * idet,
			d02 * idet, -d12 * idet, d22 * idet, -d32 * idet, -d03 * idet, d13 * idet, -d23 * idet, d33 * idet);
	}

	extern static inline function unary(a:Mat4, f:(a:Float) -> Float):Mat4 {
		return of(f(a.e00), f(a.e01), f(a.e02), f(a.e03), f(a.e10), f(a.e11), f(a.e12), f(a.e13), f(a.e20), f(a.e21),
			f(a.e22), f(a.e23), f(a.e30), f(a.e31), f(a.e32), f(a.e33));
	}

	extern static inline function binary(a:Mat4, b:Mat4, f:(a:Float, b:Float) -> Float):Mat4 {
		return of(f(a.e00, b.e00), f(a.e01, b.e01), f(a.e02, b.e02), f(a.e03, b.e03), f(a.e10, b.e10), f(a.e11, b.e11),
			f(a.e12, b.e12), f(a.e13, b.e13), f(a.e20, b.e20), f(a.e21, b.e21), f(a.e22, b.e22), f(a.e23, b.e23),
			f(a.e30, b.e30), f(a.e31, b.e31), f(a.e32, b.e32), f(a.e33, b.e33));
	}

	extern public static inline function emul(a:Mat4, b:Mat4):Mat4 {
		return binary(a, b, (a, b) -> a * b);
	}

	extern public static inline function ediv(a:Mat4, b:Mat4):Mat4 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(-A)
	extern static inline function neg(a:Mat4):Mat4 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern static inline function add(a:Mat4, b:Mat4):Mat4 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern static inline function sub(a:Mat4, b:Mat4):Mat4 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern static inline function mul(a:Mat4, b:Mat4):Mat4 {
		final a00 = a.e00;
		final a01 = a.e01;
		final a02 = a.e02;
		final a03 = a.e03;
		final a10 = a.e10;
		final a11 = a.e11;
		final a12 = a.e12;
		final a13 = a.e13;
		final a20 = a.e20;
		final a21 = a.e21;
		final a22 = a.e22;
		final a23 = a.e23;
		final a30 = a.e30;
		final a31 = a.e31;
		final a32 = a.e32;
		final a33 = a.e33;
		final b00 = b.e00;
		final b01 = b.e01;
		final b02 = b.e02;
		final b03 = b.e03;
		final b10 = b.e10;
		final b11 = b.e11;
		final b12 = b.e12;
		final b13 = b.e13;
		final b20 = b.e20;
		final b21 = b.e21;
		final b22 = b.e22;
		final b23 = b.e23;
		final b30 = b.e30;
		final b31 = b.e31;
		final b32 = b.e32;
		final b33 = b.e33;
		return of(a00 * b00 + a01 * b10 + a02 * b20 + a03 * b30, a00 * b01 + a01 * b11 + a02 * b21 + a03 * b31,
			a00 * b02 + a01 * b12 + a02 * b22 + a03 * b32, a00 * b03 + a01 * b13 + a02 * b23 + a03 * b33, a10 * b00 +
			a11 * b10 + a12 * b20 + a13 * b30, a10 * b01 + a11 * b11 + a12 * b21 + a13 * b31, a10 * b02 + a11 * b12 +
			a12 * b22 + a13 * b32, a10 * b03 + a11 * b13 + a12 * b23 + a13 * b33, a20 * b00 + a21 * b10 + a22 * b20 +
			a23 * b30, a20 * b01 + a21 * b11 + a22 * b21 + a23 * b31, a20 * b02 + a21 * b12 + a22 * b22 + a23 * b32,
			a20 * b03 + a21 * b13 + a22 * b23 + a23 * b33, a30 * b00 + a31 * b10 + a32 * b20 + a33 * b30, a30 * b01 +
			a31 * b11 + a32 * b21 + a33 * b31, a30 * b02 + a31 * b12 + a32 * b22 + a33 * b32, a30 * b03 + a31 * b13 +
			a32 * b23 + a33 * b33);
	}

	@:op(A * B)
	extern static inline function mulVec(a:Mat4, b:Vec4):Vec4 {
		return Vec4.of(a.e00 * b.x + a.e01 * b.y + a.e02 * b.z + a.e03 * b.w, a.e10 * b.x + a.e11 * b.y + a.e12 * b.z +
			a.e13 * b.w, a.e20 * b.x + a.e21 * b.y + a.e22 * b.z + a.e23 * b.w, a.e30 * b.x + a.e31 * b.y +
			a.e32 * b.z + a.e33 * b.w);
	}

	@:op(A / B)
	extern static inline function div(a:Mat4, b:Mat4):Mat4 {
		return a * b.inv;
	}

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:Mat4, b:Float):Mat4 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern static inline function subf(a:Mat4, b:Float):Mat4 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern static inline function fsub(a:Float, b:Mat4):Mat4 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:Mat4, b:Float):Mat4 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern static inline function divf(a:Mat4, b:Float):Mat4 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:Mat4):Mat4 {
		return a * b.inv;
	}

	extern public inline function getRow(index:Int):Vec4 {
		return switch index {
			case 0:
				row0;
			case 1:
				row1;
			case 2:
				row2;
			case 3:
				row3;
			case _:
				throw "Mat4 row index out of bounds: " + index;
		}
	}

	extern public inline function getCol(index:Int):Vec4 {
		return switch index {
			case 0:
				col0;
			case 1:
				col1;
			case 2:
				col2;
			case 3:
				col3;
			case _:
				throw "Mat4 column index out of bounds: " + index;
		}
	}

	extern public inline function get(rowIndex:Int, colIndex:Int):Float {
		return getRow(rowIndex)[colIndex];
	}

	extern public inline function toMat2():Mat2 {
		return Mat2.of(a.e00, a.e01, a.e10, a.e11);
	}

	extern public inline function toMat3():Mat3 {
		return Mat3.of(a.e00, a.e01, a.e02, a.e10, a.e11, a.e12, a.e20, a.e21, a.e22);
	}

	extern public inline function toAffineMat2():Mat2 {
		return Mat2.of(a.e00, a.e03, 0, 1);
	}

	extern public inline function toAffineMat3():Mat3 {
		return Mat3.of(a.e00, a.e01, a.e03, a.e10, a.e11, a.e13, 0, 0, 1);
	}

	extern public inline function copy():Mat4 {
		return of(a.e00, a.e01, a.e02, a.e03, a.e10, a.e11, a.e12, a.e13, a.e20, a.e21, a.e22, a.e23, a.e30, a.e31,
			a.e32, a.e33);
	}

	public function toString():String {
		return
			'Mat4(${a.e00}, ${a.e01}, ${a.e02}, ${a.e03}; ${a.e10}, ${a.e11}, ${a.e12}, ${a.e13}; ${a.e20}, ${a.e21}, ${a.e22}, ${a.e23}; ${a.e30}, ${a.e31}, ${a.e32}, ${a.e33})';
	}

	// following methods mutate the state

	@:op(A <<= B)
	extern inline function assign(b:Mat4):Mat4 {
		a.e00 = b.e00;
		a.e01 = b.e01;
		a.e02 = b.e02;
		a.e03 = b.e03;
		a.e10 = b.e10;
		a.e11 = b.e11;
		a.e12 = b.e12;
		a.e13 = b.e13;
		a.e20 = b.e20;
		a.e21 = b.e21;
		a.e22 = b.e22;
		a.e23 = b.e23;
		a.e30 = b.e30;
		a.e31 = b.e31;
		a.e32 = b.e32;
		a.e33 = b.e33;
		return a;
	}

	@:op(A += B)
	extern inline function addEq(b:Mat4):Mat4 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subEq(b:Mat4):Mat4 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulEq(b:Mat4):Mat4 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divEq(b:Mat4):Mat4 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern inline function addfEq(b:Float):Mat4 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subfEq(b:Float):Mat4 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulfEq(b:Float):Mat4 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divfEq(b:Float):Mat4 {
		return a <<= a / b;
	}

	extern public inline function set(e00:Float, e01:Float, e02:Float, e03:Float, e10:Float, e11:Float, e12:Float,
			e13:Float, e20:Float, e21:Float, e22:Float, e23:Float, e30:Float, e31:Float, e32:Float, e33:Float):Mat4 {
		return assign(of(e00, e01, e02, e03, e10, e11, e12, e13, e20, e21, e22, e23, e30, e31, e32, e33));
	}

	extern inline function set_row0(v) {
		a.e00 = v.x;
		a.e01 = v.y;
		a.e02 = v.z;
		a.e03 = v.w;
		return row0;
	}

	extern inline function set_row1(v) {
		a.e10 = v.x;
		a.e11 = v.y;
		a.e12 = v.z;
		a.e13 = v.w;
		return row1;
	}

	extern inline function set_row2(v) {
		a.e20 = v.x;
		a.e21 = v.y;
		a.e22 = v.z;
		a.e23 = v.w;
		return row2;
	}

	extern inline function set_row3(v) {
		a.e30 = v.x;
		a.e31 = v.y;
		a.e32 = v.z;
		a.e33 = v.w;
		return row3;
	}

	extern inline function set_col0(v) {
		a.e00 = v.x;
		a.e10 = v.y;
		a.e20 = v.z;
		a.e30 = v.w;
		return col0;
	}

	extern inline function set_col1(v) {
		a.e01 = v.x;
		a.e11 = v.y;
		a.e21 = v.z;
		a.e31 = v.w;
		return col1;
	}

	extern inline function set_col2(v) {
		a.e02 = v.x;
		a.e12 = v.y;
		a.e22 = v.z;
		a.e32 = v.w;
		return col2;
	}

	extern inline function set_col3(v) {
		a.e03 = v.x;
		a.e13 = v.y;
		a.e23 = v.z;
		a.e33 = v.w;
		return col3;
	}
}

private class Mat4Data {
	public var e00:Float;
	public var e01:Float;
	public var e02:Float;
	public var e03:Float;
	public var e10:Float;
	public var e11:Float;
	public var e12:Float;
	public var e13:Float;
	public var e20:Float;
	public var e21:Float;
	public var e22:Float;
	public var e23:Float;
	public var e30:Float;
	public var e31:Float;
	public var e32:Float;
	public var e33:Float;

	public inline function new(e00:Float, e01:Float, e02:Float, e03:Float, e10:Float, e11:Float, e12:Float, e13:Float,
			e20:Float, e21:Float, e22:Float, e23:Float, e30:Float, e31:Float, e32:Float, e33:Float) {
		this.e00 = e00;
		this.e01 = e01;
		this.e02 = e02;
		this.e03 = e03;
		this.e10 = e10;
		this.e11 = e11;
		this.e12 = e12;
		this.e13 = e13;
		this.e20 = e20;
		this.e21 = e21;
		this.e22 = e22;
		this.e23 = e23;
		this.e30 = e30;
		this.e31 = e31;
		this.e32 = e32;
		this.e33 = e33;
	}
}
