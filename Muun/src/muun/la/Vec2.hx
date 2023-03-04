package muun.la;

@:forward(x, y, z)
abstract Vec2(Vec2Data) from Vec2Data {
	inline function new(x:Float, y:Float) {
		this = new Vec2Data(x, y);
	}

	extern public static inline function of(x:Float, y:Float):Vec2 {
		return new Vec2(x, y);
	}

	public static var zero(get, never):Vec2;
	public static var one(get, never):Vec2;
	public static var ex(get, never):Vec2;
	public static var ey(get, never):Vec2;

	extern static inline function get_zero():Vec2 {
		return of(0, 0);
	}

	extern static inline function get_one():Vec2 {
		return of(1, 1);
	}

	extern static inline function get_ex():Vec2 {
		return of(1, 0);
	}

	extern static inline function get_ey():Vec2 {
		return of(0, 1);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var normalized(get, never):Vec2;
	public var star(get, never):Vec2;
	public var diag(get, never):Mat2;

	extern inline function get_length():Float {
		return Math.sqrt(lengthSq);
	}

	extern inline function get_lengthSq():Float {
		return dot(this);
	}

	extern inline function get_normalized():Vec2 {
		var l = length;
		if (l > 0)
			l = 1 / l;
		return mulf(this, l);
	}

	extern inline function get_star():Vec2 {
		final a = this;
		return of(-a.y, a.x);
	}

	extern inline function get_diag():Mat2 {
		final a = this;
		return Mat2.of(a.x, 0, 0, a.y);
	}

	extern public inline function dot(b:Vec2):Float {
		final a = this;
		return a.x * b.x + a.y * b.y;
	}

	extern public inline function tensorDot(b:Vec2):Mat2 {
		final a = this;
		return Mat2.of(a.x * b.x, a.x * b.y, a.y * b.x, a.y * b.y);
	}

	extern public inline function cross(b:Vec2):Float {
		final a = this;
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
		return unary(this, x -> x < 0 ? -x : x);
	}

	extern public inline function min(b:Vec2):Vec2 {
		return binary(this, b, (x, y) -> x < y ? x : y);
	}

	extern public inline function max(b:Vec2):Vec2 {
		return binary(this, b, (x, y) -> x > y ? x : y);
	}

	extern public inline function clamp(min:Vec2, max:Vec2):Vec2 {
		return ternary(this, min, max, (x, min, max) -> x < min ? min : x > max ? max : x);
	}

	@:op(-A)
	extern public static inline function neg(a:Vec2):Vec2 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern public static inline function add(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern public static inline function sub(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern public static inline function mul(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a * b);
	}

	@:op(A / B)
	extern public static inline function div(a:Vec2, b:Vec2):Vec2 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern public static inline function addf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern public static inline function subf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern public static inline function fsub(a:Float, b:Vec2):Vec2 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern public static inline function mulf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern public static inline function divf(a:Vec2, b:Float):Vec2 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern public static inline function fdiv(a:Float, b:Vec2):Vec2 {
		return unary(b, b -> a / b);
	}

	@:op(A << B)
	extern public static inline function assign(a:Vec2, b:Vec2):Vec2 {
		a.x = b.x;
		a.y = b.y;
		return a;
	}

	@:op(A += B)
	extern public static inline function addEq(a:Vec2, b:Vec2):Vec2 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subEq(a:Vec2, b:Vec2):Vec2 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulEq(a:Vec2, b:Vec2):Vec2 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divEq(a:Vec2, b:Vec2):Vec2 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern public static inline function addfEq(a:Vec2, b:Float):Vec2 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subfEq(a:Vec2, b:Float):Vec2 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulfEq(a:Vec2, b:Float):Vec2 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divfEq(a:Vec2, b:Float):Vec2 {
		return a <<= a / b;
	}

	@:arrayAccess
	extern public inline function get(index:Int):Float {
		return switch index {
			case 0:
				this.x;
			case 1:
				this.y;
			case _:
				throw "Vec2 index out of bounds: " + index;
		}
	}

	extern public inline function map(f:(component:Float) -> Float):Vec2 {
		return unary(this, f);
	}

	extern public inline function set(x:Float, y:Float):Vec2 {
		return assign(this, of(x, y));
	}

	overload extern public inline function extend(z:Float):Vec3 {
		final a = this;
		return Vec3.of(a.x, a.y, z);
	}

	overload extern public inline function extend(z:Float, w:Float):Vec4 {
		final a = this;
		return Vec4.of(a.x, a.y, z, w);
	}

	extern public inline function copy():Vec2 {
		final a = this;
		return of(a.x, a.y);
	}

	public function toString():String {
		final a = this;
		return 'Vec2(${a.x}, ${a.y})';
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

	extern inline function get_xx():Vec2
		return Vec2.of(this.x, this.x);

	extern inline function get_xy():Vec2
		return Vec2.of(this.x, this.y);

	extern inline function get_yx():Vec2
		return Vec2.of(this.y, this.x);

	extern inline function get_yy():Vec2
		return Vec2.of(this.y, this.y);

	extern inline function get_xxx():Vec3
		return Vec3.of(this.x, this.x, this.x);

	extern inline function get_xxy():Vec3
		return Vec3.of(this.x, this.x, this.y);

	extern inline function get_xyx():Vec3
		return Vec3.of(this.x, this.y, this.x);

	extern inline function get_xyy():Vec3
		return Vec3.of(this.x, this.y, this.y);

	extern inline function get_yxx():Vec3
		return Vec3.of(this.y, this.x, this.x);

	extern inline function get_yxy():Vec3
		return Vec3.of(this.y, this.x, this.y);

	extern inline function get_yyx():Vec3
		return Vec3.of(this.y, this.y, this.x);

	extern inline function get_yyy():Vec3
		return Vec3.of(this.y, this.y, this.y);

	extern inline function get_xxxx():Vec4
		return Vec4.of(this.x, this.x, this.x, this.x);

	extern inline function get_xxxy():Vec4
		return Vec4.of(this.x, this.x, this.x, this.y);

	extern inline function get_xxyx():Vec4
		return Vec4.of(this.x, this.x, this.y, this.x);

	extern inline function get_xxyy():Vec4
		return Vec4.of(this.x, this.x, this.y, this.y);

	extern inline function get_xyxx():Vec4
		return Vec4.of(this.x, this.y, this.x, this.x);

	extern inline function get_xyxy():Vec4
		return Vec4.of(this.x, this.y, this.x, this.y);

	extern inline function get_xyyx():Vec4
		return Vec4.of(this.x, this.y, this.y, this.x);

	extern inline function get_xyyy():Vec4
		return Vec4.of(this.x, this.y, this.y, this.y);

	extern inline function get_yxxx():Vec4
		return Vec4.of(this.y, this.x, this.x, this.x);

	extern inline function get_yxxy():Vec4
		return Vec4.of(this.y, this.x, this.x, this.y);

	extern inline function get_yxyx():Vec4
		return Vec4.of(this.y, this.x, this.y, this.x);

	extern inline function get_yxyy():Vec4
		return Vec4.of(this.y, this.x, this.y, this.y);

	extern inline function get_yyxx():Vec4
		return Vec4.of(this.y, this.y, this.x, this.x);

	extern inline function get_yyxy():Vec4
		return Vec4.of(this.y, this.y, this.x, this.y);

	extern inline function get_yyyx():Vec4
		return Vec4.of(this.y, this.y, this.y, this.x);

	extern inline function get_yyyy():Vec4
		return Vec4.of(this.y, this.y, this.y, this.y);
}

private class Vec2Data {
	public var x:Float;
	public var y:Float;

	public inline function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}
}
