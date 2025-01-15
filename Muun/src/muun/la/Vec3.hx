package muun.la;

@:forward(x, y, z)
abstract Vec3(Vec3Data) from Vec3Data {
	inline function new(x:Float, y:Float, z:Float) {
		this = new Vec3Data(x, y, z);
	}

	extern public static inline function of(x:Float, y:Float, z:Float):Vec3 {
		return new Vec3(x, y, z);
	}

	var a(get, never):Vec3;

	extern inline function get_a()
		return this;

	public static var zero(get, never):Vec3;
	public static var one(get, never):Vec3;
	public static var ex(get, never):Vec3;
	public static var ey(get, never):Vec3;
	public static var ez(get, never):Vec3;

	extern static inline function get_zero() {
		return of(0, 0, 0);
	}

	extern static inline function get_one() {
		return of(1, 1, 1);
	}

	extern static inline function get_ex() {
		return of(1, 0, 0);
	}

	extern static inline function get_ey() {
		return of(0, 1, 0);
	}

	extern static inline function get_ez() {
		return of(0, 0, 1);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var normalized(get, never):Vec3;
	public var diag(get, never):Mat3;

	extern inline function get_length() {
		return Math.sqrt(lengthSq);
	}

	extern inline function get_lengthSq() {
		return dot(a);
	}

	extern inline function get_normalized() {
		var l = length;
		if (l > 0)
			l = 1 / l;
		return mulf(a, l);
	}

	extern inline function get_diag() {
		return Mat3.of(a.x, 0, 0, 0, a.y, 0, 0, 0, a.z);
	}

	extern public inline function dot(b:Vec3):Float {
		return a.x * b.x + a.y * b.y + a.z * b.z;
	}

	extern public inline function tensorDot(b:Vec3):Mat3 {
		return Mat3.of(a.x * b.x, a.x * b.y, a.x * b.z, a.y * b.x, a.y * b.y, a.y * b.z, a.z * b.x, a.z * b.y,
			a.z * b.z);
	}

	extern public inline function cross(b:Vec3):Vec3 {
		return of(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
	}

	extern public inline function crossMat():Mat3 {
		return Mat3.of(0, -a.z, a.y, a.z, 0, -a.x, -a.y, a.x, 0);
	}

	extern static inline function unary(a:Vec3, f:(a:Float) -> Float):Vec3 {
		return of(f(a.x), f(a.y), f(a.z));
	}

	extern static inline function binary(a:Vec3, b:Vec3, f:(a:Float, b:Float) -> Float):Vec3 {
		return of(f(a.x, b.x), f(a.y, b.y), f(a.z, b.z));
	}

	extern static inline function ternary(a:Vec3, b:Vec3, c:Vec3, f:(a:Float, b:Float, c:Float) -> Float):Vec3 {
		return of(f(a.x, b.x, c.x), f(a.y, b.y, c.y), f(a.z, b.z, c.z));
	}

	extern public inline function abs():Vec3 {
		return unary(a, x -> x < 0 ? -x : x);
	}

	extern public inline function min(b:Vec3):Vec3 {
		return binary(a, b, (x, y) -> x < y ? x : y);
	}

	extern public inline function max(b:Vec3):Vec3 {
		return binary(a, b, (x, y) -> x > y ? x : y);
	}

	extern public inline function clamp(min:Vec3, max:Vec3):Vec3 {
		return ternary(a, min, max, (x, min, max) -> x < min ? min : x > max ? max : x);
	}

	@:op(-A)
	extern static inline function neg(a:Vec3):Vec3 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern static inline function add(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern static inline function sub(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern static inline function mul(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a * b);
	}

	@:op(A / B)
	extern static inline function div(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern static inline function subf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern static inline function fsub(a:Float, b:Vec3):Vec3 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern static inline function divf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:Vec3):Vec3 {
		return unary(b, b -> a / b);
	}

	@:arrayAccess
	extern inline function get(index:Int):Float {
		return switch index {
			case 0:
				a.x;
			case 1:
				a.y;
			case 2:
				a.z;
			case _:
				throw "Vec3 index out of bounds: " + index;
		}
	}

	extern public inline function map(f:(component:Float) -> Float):Vec3 {
		return unary(a, f);
	}

	extern public inline function extend(w:Float):Vec4 {
		return Vec4.of(a.x, a.y, a.z, w);
	}

	extern public inline function copy():Vec3 {
		return of(a.x, a.y, a.z);
	}

	public function toString():String {
		return 'Vec3(${a.x}, ${a.y}, ${a.z})';
	}

	// following methods mutate the state

	@:op(A <<= B)
	extern inline function assign(b:Vec3):Vec3 {
		a.x = b.x;
		a.y = b.y;
		a.z = b.z;
		return b;
	}

	@:op(A += B)
	extern inline function addEq(b:Vec3):Vec3 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subEq(b:Vec3):Vec3 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulEq(b:Vec3):Vec3 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divEq(b:Vec3):Vec3 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern inline function addfEq(b:Float):Vec3 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subfEq(b:Float):Vec3 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulfEq(b:Float):Vec3 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divfEq(b:Float):Vec3 {
		return a <<= a / b;
	}

	extern public inline function set(x:Float, y:Float, z:Float):Vec3 {
		return a <<= of(x, y, z);
	}

	public var xx(get, never):Vec2;
	public var xy(get, never):Vec2;
	public var xz(get, never):Vec2;
	public var yx(get, never):Vec2;
	public var yy(get, never):Vec2;
	public var yz(get, never):Vec2;
	public var zx(get, never):Vec2;
	public var zy(get, never):Vec2;
	public var zz(get, never):Vec2;
	public var xxx(get, never):Vec3;
	public var xxy(get, never):Vec3;
	public var xxz(get, never):Vec3;
	public var xyx(get, never):Vec3;
	public var xyy(get, never):Vec3;
	public var xyz(get, never):Vec3;
	public var xzx(get, never):Vec3;
	public var xzy(get, never):Vec3;
	public var xzz(get, never):Vec3;
	public var yxx(get, never):Vec3;
	public var yxy(get, never):Vec3;
	public var yxz(get, never):Vec3;
	public var yyx(get, never):Vec3;
	public var yyy(get, never):Vec3;
	public var yyz(get, never):Vec3;
	public var yzx(get, never):Vec3;
	public var yzy(get, never):Vec3;
	public var yzz(get, never):Vec3;
	public var zxx(get, never):Vec3;
	public var zxy(get, never):Vec3;
	public var zxz(get, never):Vec3;
	public var zyx(get, never):Vec3;
	public var zyy(get, never):Vec3;
	public var zyz(get, never):Vec3;
	public var zzx(get, never):Vec3;
	public var zzy(get, never):Vec3;
	public var zzz(get, never):Vec3;
	public var xxxx(get, never):Vec4;
	public var xxxy(get, never):Vec4;
	public var xxxz(get, never):Vec4;
	public var xxyx(get, never):Vec4;
	public var xxyy(get, never):Vec4;
	public var xxyz(get, never):Vec4;
	public var xxzx(get, never):Vec4;
	public var xxzy(get, never):Vec4;
	public var xxzz(get, never):Vec4;
	public var xyxx(get, never):Vec4;
	public var xyxy(get, never):Vec4;
	public var xyxz(get, never):Vec4;
	public var xyyx(get, never):Vec4;
	public var xyyy(get, never):Vec4;
	public var xyyz(get, never):Vec4;
	public var xyzx(get, never):Vec4;
	public var xyzy(get, never):Vec4;
	public var xyzz(get, never):Vec4;
	public var xzxx(get, never):Vec4;
	public var xzxy(get, never):Vec4;
	public var xzxz(get, never):Vec4;
	public var xzyx(get, never):Vec4;
	public var xzyy(get, never):Vec4;
	public var xzyz(get, never):Vec4;
	public var xzzx(get, never):Vec4;
	public var xzzy(get, never):Vec4;
	public var xzzz(get, never):Vec4;
	public var yxxx(get, never):Vec4;
	public var yxxy(get, never):Vec4;
	public var yxxz(get, never):Vec4;
	public var yxyx(get, never):Vec4;
	public var yxyy(get, never):Vec4;
	public var yxyz(get, never):Vec4;
	public var yxzx(get, never):Vec4;
	public var yxzy(get, never):Vec4;
	public var yxzz(get, never):Vec4;
	public var yyxx(get, never):Vec4;
	public var yyxy(get, never):Vec4;
	public var yyxz(get, never):Vec4;
	public var yyyx(get, never):Vec4;
	public var yyyy(get, never):Vec4;
	public var yyyz(get, never):Vec4;
	public var yyzx(get, never):Vec4;
	public var yyzy(get, never):Vec4;
	public var yyzz(get, never):Vec4;
	public var yzxx(get, never):Vec4;
	public var yzxy(get, never):Vec4;
	public var yzxz(get, never):Vec4;
	public var yzyx(get, never):Vec4;
	public var yzyy(get, never):Vec4;
	public var yzyz(get, never):Vec4;
	public var yzzx(get, never):Vec4;
	public var yzzy(get, never):Vec4;
	public var yzzz(get, never):Vec4;
	public var zxxx(get, never):Vec4;
	public var zxxy(get, never):Vec4;
	public var zxxz(get, never):Vec4;
	public var zxyx(get, never):Vec4;
	public var zxyy(get, never):Vec4;
	public var zxyz(get, never):Vec4;
	public var zxzx(get, never):Vec4;
	public var zxzy(get, never):Vec4;
	public var zxzz(get, never):Vec4;
	public var zyxx(get, never):Vec4;
	public var zyxy(get, never):Vec4;
	public var zyxz(get, never):Vec4;
	public var zyyx(get, never):Vec4;
	public var zyyy(get, never):Vec4;
	public var zyyz(get, never):Vec4;
	public var zyzx(get, never):Vec4;
	public var zyzy(get, never):Vec4;
	public var zyzz(get, never):Vec4;
	public var zzxx(get, never):Vec4;
	public var zzxy(get, never):Vec4;
	public var zzxz(get, never):Vec4;
	public var zzyx(get, never):Vec4;
	public var zzyy(get, never):Vec4;
	public var zzyz(get, never):Vec4;
	public var zzzx(get, never):Vec4;
	public var zzzy(get, never):Vec4;
	public var zzzz(get, never):Vec4;

	extern inline function get_xx()
		return Vec2.of(a.x, a.x);

	extern inline function get_xy()
		return Vec2.of(a.x, a.y);

	extern inline function get_xz()
		return Vec2.of(a.x, a.z);

	extern inline function get_yx()
		return Vec2.of(a.y, a.x);

	extern inline function get_yy()
		return Vec2.of(a.y, a.y);

	extern inline function get_yz()
		return Vec2.of(a.y, a.z);

	extern inline function get_zx()
		return Vec2.of(a.z, a.x);

	extern inline function get_zy()
		return Vec2.of(a.z, a.y);

	extern inline function get_zz()
		return Vec2.of(a.z, a.z);

	extern inline function get_xxx()
		return Vec3.of(a.x, a.x, a.x);

	extern inline function get_xxy()
		return Vec3.of(a.x, a.x, a.y);

	extern inline function get_xxz()
		return Vec3.of(a.x, a.x, a.z);

	extern inline function get_xyx()
		return Vec3.of(a.x, a.y, a.x);

	extern inline function get_xyy()
		return Vec3.of(a.x, a.y, a.y);

	extern inline function get_xyz()
		return Vec3.of(a.x, a.y, a.z);

	extern inline function get_xzx()
		return Vec3.of(a.x, a.z, a.x);

	extern inline function get_xzy()
		return Vec3.of(a.x, a.z, a.y);

	extern inline function get_xzz()
		return Vec3.of(a.x, a.z, a.z);

	extern inline function get_yxx()
		return Vec3.of(a.y, a.x, a.x);

	extern inline function get_yxy()
		return Vec3.of(a.y, a.x, a.y);

	extern inline function get_yxz()
		return Vec3.of(a.y, a.x, a.z);

	extern inline function get_yyx()
		return Vec3.of(a.y, a.y, a.x);

	extern inline function get_yyy()
		return Vec3.of(a.y, a.y, a.y);

	extern inline function get_yyz()
		return Vec3.of(a.y, a.y, a.z);

	extern inline function get_yzx()
		return Vec3.of(a.y, a.z, a.x);

	extern inline function get_yzy()
		return Vec3.of(a.y, a.z, a.y);

	extern inline function get_yzz()
		return Vec3.of(a.y, a.z, a.z);

	extern inline function get_zxx()
		return Vec3.of(a.z, a.x, a.x);

	extern inline function get_zxy()
		return Vec3.of(a.z, a.x, a.y);

	extern inline function get_zxz()
		return Vec3.of(a.z, a.x, a.z);

	extern inline function get_zyx()
		return Vec3.of(a.z, a.y, a.x);

	extern inline function get_zyy()
		return Vec3.of(a.z, a.y, a.y);

	extern inline function get_zyz()
		return Vec3.of(a.z, a.y, a.z);

	extern inline function get_zzx()
		return Vec3.of(a.z, a.z, a.x);

	extern inline function get_zzy()
		return Vec3.of(a.z, a.z, a.y);

	extern inline function get_zzz()
		return Vec3.of(a.z, a.z, a.z);

	extern inline function get_xxxx()
		return Vec4.of(a.x, a.x, a.x, a.x);

	extern inline function get_xxxy()
		return Vec4.of(a.x, a.x, a.x, a.y);

	extern inline function get_xxxz()
		return Vec4.of(a.x, a.x, a.x, a.z);

	extern inline function get_xxyx()
		return Vec4.of(a.x, a.x, a.y, a.x);

	extern inline function get_xxyy()
		return Vec4.of(a.x, a.x, a.y, a.y);

	extern inline function get_xxyz()
		return Vec4.of(a.x, a.x, a.y, a.z);

	extern inline function get_xxzx()
		return Vec4.of(a.x, a.x, a.z, a.x);

	extern inline function get_xxzy()
		return Vec4.of(a.x, a.x, a.z, a.y);

	extern inline function get_xxzz()
		return Vec4.of(a.x, a.x, a.z, a.z);

	extern inline function get_xyxx()
		return Vec4.of(a.x, a.y, a.x, a.x);

	extern inline function get_xyxy()
		return Vec4.of(a.x, a.y, a.x, a.y);

	extern inline function get_xyxz()
		return Vec4.of(a.x, a.y, a.x, a.z);

	extern inline function get_xyyx()
		return Vec4.of(a.x, a.y, a.y, a.x);

	extern inline function get_xyyy()
		return Vec4.of(a.x, a.y, a.y, a.y);

	extern inline function get_xyyz()
		return Vec4.of(a.x, a.y, a.y, a.z);

	extern inline function get_xyzx()
		return Vec4.of(a.x, a.y, a.z, a.x);

	extern inline function get_xyzy()
		return Vec4.of(a.x, a.y, a.z, a.y);

	extern inline function get_xyzz()
		return Vec4.of(a.x, a.y, a.z, a.z);

	extern inline function get_xzxx()
		return Vec4.of(a.x, a.z, a.x, a.x);

	extern inline function get_xzxy()
		return Vec4.of(a.x, a.z, a.x, a.y);

	extern inline function get_xzxz()
		return Vec4.of(a.x, a.z, a.x, a.z);

	extern inline function get_xzyx()
		return Vec4.of(a.x, a.z, a.y, a.x);

	extern inline function get_xzyy()
		return Vec4.of(a.x, a.z, a.y, a.y);

	extern inline function get_xzyz()
		return Vec4.of(a.x, a.z, a.y, a.z);

	extern inline function get_xzzx()
		return Vec4.of(a.x, a.z, a.z, a.x);

	extern inline function get_xzzy()
		return Vec4.of(a.x, a.z, a.z, a.y);

	extern inline function get_xzzz()
		return Vec4.of(a.x, a.z, a.z, a.z);

	extern inline function get_yxxx()
		return Vec4.of(a.y, a.x, a.x, a.x);

	extern inline function get_yxxy()
		return Vec4.of(a.y, a.x, a.x, a.y);

	extern inline function get_yxxz()
		return Vec4.of(a.y, a.x, a.x, a.z);

	extern inline function get_yxyx()
		return Vec4.of(a.y, a.x, a.y, a.x);

	extern inline function get_yxyy()
		return Vec4.of(a.y, a.x, a.y, a.y);

	extern inline function get_yxyz()
		return Vec4.of(a.y, a.x, a.y, a.z);

	extern inline function get_yxzx()
		return Vec4.of(a.y, a.x, a.z, a.x);

	extern inline function get_yxzy()
		return Vec4.of(a.y, a.x, a.z, a.y);

	extern inline function get_yxzz()
		return Vec4.of(a.y, a.x, a.z, a.z);

	extern inline function get_yyxx()
		return Vec4.of(a.y, a.y, a.x, a.x);

	extern inline function get_yyxy()
		return Vec4.of(a.y, a.y, a.x, a.y);

	extern inline function get_yyxz()
		return Vec4.of(a.y, a.y, a.x, a.z);

	extern inline function get_yyyx()
		return Vec4.of(a.y, a.y, a.y, a.x);

	extern inline function get_yyyy()
		return Vec4.of(a.y, a.y, a.y, a.y);

	extern inline function get_yyyz()
		return Vec4.of(a.y, a.y, a.y, a.z);

	extern inline function get_yyzx()
		return Vec4.of(a.y, a.y, a.z, a.x);

	extern inline function get_yyzy()
		return Vec4.of(a.y, a.y, a.z, a.y);

	extern inline function get_yyzz()
		return Vec4.of(a.y, a.y, a.z, a.z);

	extern inline function get_yzxx()
		return Vec4.of(a.y, a.z, a.x, a.x);

	extern inline function get_yzxy()
		return Vec4.of(a.y, a.z, a.x, a.y);

	extern inline function get_yzxz()
		return Vec4.of(a.y, a.z, a.x, a.z);

	extern inline function get_yzyx()
		return Vec4.of(a.y, a.z, a.y, a.x);

	extern inline function get_yzyy()
		return Vec4.of(a.y, a.z, a.y, a.y);

	extern inline function get_yzyz()
		return Vec4.of(a.y, a.z, a.y, a.z);

	extern inline function get_yzzx()
		return Vec4.of(a.y, a.z, a.z, a.x);

	extern inline function get_yzzy()
		return Vec4.of(a.y, a.z, a.z, a.y);

	extern inline function get_yzzz()
		return Vec4.of(a.y, a.z, a.z, a.z);

	extern inline function get_zxxx()
		return Vec4.of(a.z, a.x, a.x, a.x);

	extern inline function get_zxxy()
		return Vec4.of(a.z, a.x, a.x, a.y);

	extern inline function get_zxxz()
		return Vec4.of(a.z, a.x, a.x, a.z);

	extern inline function get_zxyx()
		return Vec4.of(a.z, a.x, a.y, a.x);

	extern inline function get_zxyy()
		return Vec4.of(a.z, a.x, a.y, a.y);

	extern inline function get_zxyz()
		return Vec4.of(a.z, a.x, a.y, a.z);

	extern inline function get_zxzx()
		return Vec4.of(a.z, a.x, a.z, a.x);

	extern inline function get_zxzy()
		return Vec4.of(a.z, a.x, a.z, a.y);

	extern inline function get_zxzz()
		return Vec4.of(a.z, a.x, a.z, a.z);

	extern inline function get_zyxx()
		return Vec4.of(a.z, a.y, a.x, a.x);

	extern inline function get_zyxy()
		return Vec4.of(a.z, a.y, a.x, a.y);

	extern inline function get_zyxz()
		return Vec4.of(a.z, a.y, a.x, a.z);

	extern inline function get_zyyx()
		return Vec4.of(a.z, a.y, a.y, a.x);

	extern inline function get_zyyy()
		return Vec4.of(a.z, a.y, a.y, a.y);

	extern inline function get_zyyz()
		return Vec4.of(a.z, a.y, a.y, a.z);

	extern inline function get_zyzx()
		return Vec4.of(a.z, a.y, a.z, a.x);

	extern inline function get_zyzy()
		return Vec4.of(a.z, a.y, a.z, a.y);

	extern inline function get_zyzz()
		return Vec4.of(a.z, a.y, a.z, a.z);

	extern inline function get_zzxx()
		return Vec4.of(a.z, a.z, a.x, a.x);

	extern inline function get_zzxy()
		return Vec4.of(a.z, a.z, a.x, a.y);

	extern inline function get_zzxz()
		return Vec4.of(a.z, a.z, a.x, a.z);

	extern inline function get_zzyx()
		return Vec4.of(a.z, a.z, a.y, a.x);

	extern inline function get_zzyy()
		return Vec4.of(a.z, a.z, a.y, a.y);

	extern inline function get_zzyz()
		return Vec4.of(a.z, a.z, a.y, a.z);

	extern inline function get_zzzx()
		return Vec4.of(a.z, a.z, a.z, a.x);

	extern inline function get_zzzy()
		return Vec4.of(a.z, a.z, a.z, a.y);

	extern inline function get_zzzz()
		return Vec4.of(a.z, a.z, a.z, a.z);
}

private class Vec3Data {
	public var x:Float;
	public var y:Float;
	public var z:Float;

	public inline function new(x:Float, y:Float, z:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
	}
}
