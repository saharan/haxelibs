package muun.la;

@:forward(x, y, z)
abstract Vec2(Vec2Data) from Vec2Data {
	inline function new(x:Float, y:Float) {
		this = new Vec2Data(x, y);
	}

	extern public static inline function of(x:Float, y:Float):Vec2 {
		return new Vec2(x, y);
	}

	var a(get, never):Vec2;

	extern inline function get_a()
		return this;

	public static var zero(get, never):Vec2;
	public static var one(get, never):Vec2;
	public static var ex(get, never):Vec2;
	public static var ey(get, never):Vec2;

	extern static inline function get_zero() {
		return of(0, 0);
	}

	extern static inline function get_one() {
		return of(1, 1);
	}

	extern static inline function get_ex() {
		return of(1, 0);
	}

	extern static inline function get_ey() {
		return of(0, 1);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var normalized(get, never):Vec2;
	public var star(get, never):Vec2;
	public var diag(get, never):Mat2;

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

	extern inline function get_star() {
		return of(-a.y, a.x);
	}

	extern inline function get_diag() {
		return Mat2.of(a.x, 0, 0, a.y);
	}

	extern public inline function dot(b:Vec2):Float {
		return a.x * b.x + a.y * b.y;
	}

	extern public inline function tensorDot(b:Vec2):Mat2 {
		return Mat2.of(a.x * b.x, a.x * b.y, a.y * b.x, a.y * b.y);
	}

	extern public inline function cross(b:Vec2):Float {
		return a.x * b.y - a.y * b.x;
	}

	extern static inline function unary(a:Vec2, f:(a:Float) -> Float):Vec2 {
		return of(f(a.x), f(a.y));
	}

	extern static inline function binary(a:Vec2, b:Vec2, f:(a:Float, b:Float) -> Float):Vec2 {
		return of(f(a.x, b.x), f(a.y, b.y));
	}

	extern static inline function ternary(a:Vec2, b:Vec2, c:Vec2, f:(a:Float, b:Float, c:Float) -> Float):Vec2 {
		return of(f(a.x, b.x, c.x), f(a.y, b.y, c.y));
	}

	extern public inline function abs():Vec2 {
		return unary(a, x -> x < 0 ? -x : x);
	}

	extern public inline function min(b:Vec2):Vec2 {
		return binary(a, b, (x, y) -> x < y ? x : y);
	}

	extern public inline function max(b:Vec2):Vec2 {
		return binary(a, b, (x, y) -> x > y ? x : y);
	}

	extern public inline function clamp(min:Vec2, max:Vec2):Vec2 {
		return ternary(a, min, max, (x, min, max) -> x < min ? min : x > max ? max : x);
	}

	@:op(-A)
	extern static inline function neg(a:Vec2):Vec2 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern static inline function add(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern static inline function sub(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern static inline function mul(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a * b);
	}

	@:op(A / B)
	extern static inline function div(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern static inline function subf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern static inline function fsub(a:Float, b:Vec2):Vec2 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern static inline function divf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:Vec2):Vec2 {
		return unary(b, b -> a / b);
	}

	@:arrayAccess
	extern inline function get(index:Int):Float {
		return switch index {
			case 0:
				a.x;
			case 1:
				a.y;
			case _:
				throw "Vec2 index out of bounds: " + index;
		}
	}

	extern public inline function map(f:(component:Float) -> Float):Vec2 {
		return unary(a, f);
	}

	overload extern public inline function extend(z:Float):Vec3 {
		return Vec3.of(a.x, a.y, z);
	}

	overload extern public inline function extend(z:Float, w:Float):Vec4 {
		return Vec4.of(a.x, a.y, z, w);
	}

	extern public inline function copy():Vec2 {
		return of(a.x, a.y);
	}

	public function toString():String {
		return 'Vec2(${a.x}, ${a.y})';
	}

	// following methods mutate the state

	@:op(A <<= B)
	extern inline function assign(b:Vec2):Vec2 {
		a.x = b.x;
		a.y = b.y;
		return a;
	}

	@:op(A += B)
	extern inline function addEq(b:Vec2):Vec2 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subEq(b:Vec2):Vec2 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulEq(b:Vec2):Vec2 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divEq(b:Vec2):Vec2 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern inline function addfEq(b:Float):Vec2 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subfEq(b:Float):Vec2 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulfEq(b:Float):Vec2 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divfEq(b:Float):Vec2 {
		return a <<= a / b;
	}

	extern public inline function set(x:Float, y:Float):Vec2 {
		return a <<= of(x, y);
	}

	public var xx(get, never):Vec2;
	public var xy(get, never):Vec2;
	public var yx(get, never):Vec2;
	public var yy(get, never):Vec2;
	public var xxx(get, never):Vec3;
	public var xxy(get, never):Vec3;
	public var xyx(get, never):Vec3;
	public var xyy(get, never):Vec3;
	public var yxx(get, never):Vec3;
	public var yxy(get, never):Vec3;
	public var yyx(get, never):Vec3;
	public var yyy(get, never):Vec3;
	public var xxxx(get, never):Vec4;
	public var xxxy(get, never):Vec4;
	public var xxyx(get, never):Vec4;
	public var xxyy(get, never):Vec4;
	public var xyxx(get, never):Vec4;
	public var xyxy(get, never):Vec4;
	public var xyyx(get, never):Vec4;
	public var xyyy(get, never):Vec4;
	public var yxxx(get, never):Vec4;
	public var yxxy(get, never):Vec4;
	public var yxyx(get, never):Vec4;
	public var yxyy(get, never):Vec4;
	public var yyxx(get, never):Vec4;
	public var yyxy(get, never):Vec4;
	public var yyyx(get, never):Vec4;
	public var yyyy(get, never):Vec4;

	extern inline function get_xx()
		return Vec2.of(a.x, a.x);

	extern inline function get_xy()
		return Vec2.of(a.x, a.y);

	extern inline function get_yx()
		return Vec2.of(a.y, a.x);

	extern inline function get_yy()
		return Vec2.of(a.y, a.y);

	extern inline function get_xxx()
		return Vec3.of(a.x, a.x, a.x);

	extern inline function get_xxy()
		return Vec3.of(a.x, a.x, a.y);

	extern inline function get_xyx()
		return Vec3.of(a.x, a.y, a.x);

	extern inline function get_xyy()
		return Vec3.of(a.x, a.y, a.y);

	extern inline function get_yxx()
		return Vec3.of(a.y, a.x, a.x);

	extern inline function get_yxy()
		return Vec3.of(a.y, a.x, a.y);

	extern inline function get_yyx()
		return Vec3.of(a.y, a.y, a.x);

	extern inline function get_yyy()
		return Vec3.of(a.y, a.y, a.y);

	extern inline function get_xxxx()
		return Vec4.of(a.x, a.x, a.x, a.x);

	extern inline function get_xxxy()
		return Vec4.of(a.x, a.x, a.x, a.y);

	extern inline function get_xxyx()
		return Vec4.of(a.x, a.x, a.y, a.x);

	extern inline function get_xxyy()
		return Vec4.of(a.x, a.x, a.y, a.y);

	extern inline function get_xyxx()
		return Vec4.of(a.x, a.y, a.x, a.x);

	extern inline function get_xyxy()
		return Vec4.of(a.x, a.y, a.x, a.y);

	extern inline function get_xyyx()
		return Vec4.of(a.x, a.y, a.y, a.x);

	extern inline function get_xyyy()
		return Vec4.of(a.x, a.y, a.y, a.y);

	extern inline function get_yxxx()
		return Vec4.of(a.y, a.x, a.x, a.x);

	extern inline function get_yxxy()
		return Vec4.of(a.y, a.x, a.x, a.y);

	extern inline function get_yxyx()
		return Vec4.of(a.y, a.x, a.y, a.x);

	extern inline function get_yxyy()
		return Vec4.of(a.y, a.x, a.y, a.y);

	extern inline function get_yyxx()
		return Vec4.of(a.y, a.y, a.x, a.x);

	extern inline function get_yyxy()
		return Vec4.of(a.y, a.y, a.x, a.y);

	extern inline function get_yyyx()
		return Vec4.of(a.y, a.y, a.y, a.x);

	extern inline function get_yyyy()
		return Vec4.of(a.y, a.y, a.y, a.y);
}

private class Vec2Data {
	public var x:Float;
	public var y:Float;

	public inline function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}
}
