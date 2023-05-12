package muun.la;

@:forward(x, y, z)
abstract Vec3(Vec3Data) from Vec3Data {
	inline function new(x:Float, y:Float, z:Float) {
		this = new Vec3Data(x, y, z);
	}

	extern public static inline function of(x:Float, y:Float, z:Float):Vec3 {
		return new Vec3(x, y, z);
	}

	public static var zero(get, never):Vec3;
	public static var one(get, never):Vec3;
	public static var ex(get, never):Vec3;
	public static var ey(get, never):Vec3;
	public static var ez(get, never):Vec3;

	extern static inline function get_zero():Vec3 {
		return of(0, 0, 0);
	}

	extern static inline function get_one():Vec3 {
		return of(1, 1, 1);
	}

	extern static inline function get_ex():Vec3 {
		return of(1, 0, 0);
	}

	extern static inline function get_ey():Vec3 {
		return of(0, 1, 0);
	}

	extern static inline function get_ez():Vec3 {
		return of(0, 0, 1);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var normalized(get, never):Vec3;
	public var diag(get, never):Mat3;

	extern inline function get_length():Float {
		return Math.sqrt(lengthSq);
	}

	extern inline function get_lengthSq():Float {
		return dot(this);
	}

	extern inline function get_normalized():Vec3 {
		var l = length;
		if (l > 0)
			l = 1 / l;
		return mulf(this, l);
	}

	extern inline function get_diag():Mat3 {
		final a = this;
		return Mat3.of(a.x, 0, 0, 0, a.y, 0, 0, 0, a.z);
	}

	extern public inline function dot(b:Vec3):Float {
		final a = this;
		return a.x * b.x + a.y * b.y + a.z * b.z;
	}

	extern public inline function tensorDot(b:Vec3):Mat3 {
		final a = this;
		return Mat3.of(a.x * b.x, a.x * b.y, a.x * b.z, a.y * b.x, a.y * b.y, a.y * b.z, a.z * b.x, a.z * b.y, a.z * b.z);
	}

	extern public inline function cross(b:Vec3):Vec3 {
		final a = this;
		return of(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x);
	}

	extern public inline function crossMat():Mat3 {
		final a = this;
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
		return unary(this, x -> x < 0 ? -x : x);
	}

	extern public inline function min(b:Vec3):Vec3 {
		return binary(this, b, (x, y) -> x < y ? x : y);
	}

	extern public inline function max(b:Vec3):Vec3 {
		return binary(this, b, (x, y) -> x > y ? x : y);
	}

	extern public inline function clamp(min:Vec3, max:Vec3):Vec3 {
		return ternary(this, min, max, (x, min, max) -> x < min ? min : x > max ? max : x);
	}

	@:op(-A)
	extern public static inline function neg(a:Vec3):Vec3 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern public static inline function add(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern public static inline function sub(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern public static inline function mul(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a * b);
	}

	@:op(A / B)
	extern public static inline function div(a:Vec3, b:Vec3):Vec3 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern public static inline function addf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern public static inline function subf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern public static inline function fsub(a:Float, b:Vec3):Vec3 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern public static inline function mulf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern public static inline function divf(a:Vec3, b:Float):Vec3 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern public static inline function fdiv(a:Float, b:Vec3):Vec3 {
		return unary(b, b -> a / b);
	}

	@:op(A <<= B)
	extern public static inline function assign(a:Vec3, b:Vec3):Vec3 {
		a.x = b.x;
		a.y = b.y;
		a.z = b.z;
		return b;
	}

	@:op(A += B)
	extern public static inline function addEq(a:Vec3, b:Vec3):Vec3 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subEq(a:Vec3, b:Vec3):Vec3 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulEq(a:Vec3, b:Vec3):Vec3 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divEq(a:Vec3, b:Vec3):Vec3 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern public static inline function addfEq(a:Vec3, b:Float):Vec3 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subfEq(a:Vec3, b:Float):Vec3 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulfEq(a:Vec3, b:Float):Vec3 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divfEq(a:Vec3, b:Float):Vec3 {
		return a <<= a / b;
	}

	@:arrayAccess
	extern public inline function get(index:Int):Float {
		return switch index {
			case 0:
				this.x;
			case 1:
				this.y;
			case 2:
				this.z;
			case _:
				throw "Vec3 index out of bounds: " + index;
		}
	}

	extern public inline function map(f:(component:Float) -> Float):Vec3 {
		return unary(this, f);
	}

	extern public inline function set(x:Float, y:Float, z:Float):Vec3 {
		return assign(this, of(x, y, z));
	}

	extern public inline function extend(w:Float):Vec4 {
		final a = this;
		return Vec4.of(a.x, a.y, a.z, w);
	}

	extern public inline function copy():Vec3 {
		final a = this;
		return of(a.x, a.y, a.z);
	}

	public function toString():String {
		final a = this;
		return 'Vec3(${a.x}, ${a.y}, ${a.z})';
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

	extern inline function get_xx():Vec2
		return Vec2.of(this.x, this.x);

	extern inline function get_xy():Vec2
		return Vec2.of(this.x, this.y);

	extern inline function get_xz():Vec2
		return Vec2.of(this.x, this.z);

	extern inline function get_yx():Vec2
		return Vec2.of(this.y, this.x);

	extern inline function get_yy():Vec2
		return Vec2.of(this.y, this.y);

	extern inline function get_yz():Vec2
		return Vec2.of(this.y, this.z);

	extern inline function get_zx():Vec2
		return Vec2.of(this.z, this.x);

	extern inline function get_zy():Vec2
		return Vec2.of(this.z, this.y);

	extern inline function get_zz():Vec2
		return Vec2.of(this.z, this.z);

	extern inline function get_xxx():Vec3
		return Vec3.of(this.x, this.x, this.x);

	extern inline function get_xxy():Vec3
		return Vec3.of(this.x, this.x, this.y);

	extern inline function get_xxz():Vec3
		return Vec3.of(this.x, this.x, this.z);

	extern inline function get_xyx():Vec3
		return Vec3.of(this.x, this.y, this.x);

	extern inline function get_xyy():Vec3
		return Vec3.of(this.x, this.y, this.y);

	extern inline function get_xyz():Vec3
		return Vec3.of(this.x, this.y, this.z);

	extern inline function get_xzx():Vec3
		return Vec3.of(this.x, this.z, this.x);

	extern inline function get_xzy():Vec3
		return Vec3.of(this.x, this.z, this.y);

	extern inline function get_xzz():Vec3
		return Vec3.of(this.x, this.z, this.z);

	extern inline function get_yxx():Vec3
		return Vec3.of(this.y, this.x, this.x);

	extern inline function get_yxy():Vec3
		return Vec3.of(this.y, this.x, this.y);

	extern inline function get_yxz():Vec3
		return Vec3.of(this.y, this.x, this.z);

	extern inline function get_yyx():Vec3
		return Vec3.of(this.y, this.y, this.x);

	extern inline function get_yyy():Vec3
		return Vec3.of(this.y, this.y, this.y);

	extern inline function get_yyz():Vec3
		return Vec3.of(this.y, this.y, this.z);

	extern inline function get_yzx():Vec3
		return Vec3.of(this.y, this.z, this.x);

	extern inline function get_yzy():Vec3
		return Vec3.of(this.y, this.z, this.y);

	extern inline function get_yzz():Vec3
		return Vec3.of(this.y, this.z, this.z);

	extern inline function get_zxx():Vec3
		return Vec3.of(this.z, this.x, this.x);

	extern inline function get_zxy():Vec3
		return Vec3.of(this.z, this.x, this.y);

	extern inline function get_zxz():Vec3
		return Vec3.of(this.z, this.x, this.z);

	extern inline function get_zyx():Vec3
		return Vec3.of(this.z, this.y, this.x);

	extern inline function get_zyy():Vec3
		return Vec3.of(this.z, this.y, this.y);

	extern inline function get_zyz():Vec3
		return Vec3.of(this.z, this.y, this.z);

	extern inline function get_zzx():Vec3
		return Vec3.of(this.z, this.z, this.x);

	extern inline function get_zzy():Vec3
		return Vec3.of(this.z, this.z, this.y);

	extern inline function get_zzz():Vec3
		return Vec3.of(this.z, this.z, this.z);

	extern inline function get_xxxx():Vec4
		return Vec4.of(this.x, this.x, this.x, this.x);

	extern inline function get_xxxy():Vec4
		return Vec4.of(this.x, this.x, this.x, this.y);

	extern inline function get_xxxz():Vec4
		return Vec4.of(this.x, this.x, this.x, this.z);

	extern inline function get_xxyx():Vec4
		return Vec4.of(this.x, this.x, this.y, this.x);

	extern inline function get_xxyy():Vec4
		return Vec4.of(this.x, this.x, this.y, this.y);

	extern inline function get_xxyz():Vec4
		return Vec4.of(this.x, this.x, this.y, this.z);

	extern inline function get_xxzx():Vec4
		return Vec4.of(this.x, this.x, this.z, this.x);

	extern inline function get_xxzy():Vec4
		return Vec4.of(this.x, this.x, this.z, this.y);

	extern inline function get_xxzz():Vec4
		return Vec4.of(this.x, this.x, this.z, this.z);

	extern inline function get_xyxx():Vec4
		return Vec4.of(this.x, this.y, this.x, this.x);

	extern inline function get_xyxy():Vec4
		return Vec4.of(this.x, this.y, this.x, this.y);

	extern inline function get_xyxz():Vec4
		return Vec4.of(this.x, this.y, this.x, this.z);

	extern inline function get_xyyx():Vec4
		return Vec4.of(this.x, this.y, this.y, this.x);

	extern inline function get_xyyy():Vec4
		return Vec4.of(this.x, this.y, this.y, this.y);

	extern inline function get_xyyz():Vec4
		return Vec4.of(this.x, this.y, this.y, this.z);

	extern inline function get_xyzx():Vec4
		return Vec4.of(this.x, this.y, this.z, this.x);

	extern inline function get_xyzy():Vec4
		return Vec4.of(this.x, this.y, this.z, this.y);

	extern inline function get_xyzz():Vec4
		return Vec4.of(this.x, this.y, this.z, this.z);

	extern inline function get_xzxx():Vec4
		return Vec4.of(this.x, this.z, this.x, this.x);

	extern inline function get_xzxy():Vec4
		return Vec4.of(this.x, this.z, this.x, this.y);

	extern inline function get_xzxz():Vec4
		return Vec4.of(this.x, this.z, this.x, this.z);

	extern inline function get_xzyx():Vec4
		return Vec4.of(this.x, this.z, this.y, this.x);

	extern inline function get_xzyy():Vec4
		return Vec4.of(this.x, this.z, this.y, this.y);

	extern inline function get_xzyz():Vec4
		return Vec4.of(this.x, this.z, this.y, this.z);

	extern inline function get_xzzx():Vec4
		return Vec4.of(this.x, this.z, this.z, this.x);

	extern inline function get_xzzy():Vec4
		return Vec4.of(this.x, this.z, this.z, this.y);

	extern inline function get_xzzz():Vec4
		return Vec4.of(this.x, this.z, this.z, this.z);

	extern inline function get_yxxx():Vec4
		return Vec4.of(this.y, this.x, this.x, this.x);

	extern inline function get_yxxy():Vec4
		return Vec4.of(this.y, this.x, this.x, this.y);

	extern inline function get_yxxz():Vec4
		return Vec4.of(this.y, this.x, this.x, this.z);

	extern inline function get_yxyx():Vec4
		return Vec4.of(this.y, this.x, this.y, this.x);

	extern inline function get_yxyy():Vec4
		return Vec4.of(this.y, this.x, this.y, this.y);

	extern inline function get_yxyz():Vec4
		return Vec4.of(this.y, this.x, this.y, this.z);

	extern inline function get_yxzx():Vec4
		return Vec4.of(this.y, this.x, this.z, this.x);

	extern inline function get_yxzy():Vec4
		return Vec4.of(this.y, this.x, this.z, this.y);

	extern inline function get_yxzz():Vec4
		return Vec4.of(this.y, this.x, this.z, this.z);

	extern inline function get_yyxx():Vec4
		return Vec4.of(this.y, this.y, this.x, this.x);

	extern inline function get_yyxy():Vec4
		return Vec4.of(this.y, this.y, this.x, this.y);

	extern inline function get_yyxz():Vec4
		return Vec4.of(this.y, this.y, this.x, this.z);

	extern inline function get_yyyx():Vec4
		return Vec4.of(this.y, this.y, this.y, this.x);

	extern inline function get_yyyy():Vec4
		return Vec4.of(this.y, this.y, this.y, this.y);

	extern inline function get_yyyz():Vec4
		return Vec4.of(this.y, this.y, this.y, this.z);

	extern inline function get_yyzx():Vec4
		return Vec4.of(this.y, this.y, this.z, this.x);

	extern inline function get_yyzy():Vec4
		return Vec4.of(this.y, this.y, this.z, this.y);

	extern inline function get_yyzz():Vec4
		return Vec4.of(this.y, this.y, this.z, this.z);

	extern inline function get_yzxx():Vec4
		return Vec4.of(this.y, this.z, this.x, this.x);

	extern inline function get_yzxy():Vec4
		return Vec4.of(this.y, this.z, this.x, this.y);

	extern inline function get_yzxz():Vec4
		return Vec4.of(this.y, this.z, this.x, this.z);

	extern inline function get_yzyx():Vec4
		return Vec4.of(this.y, this.z, this.y, this.x);

	extern inline function get_yzyy():Vec4
		return Vec4.of(this.y, this.z, this.y, this.y);

	extern inline function get_yzyz():Vec4
		return Vec4.of(this.y, this.z, this.y, this.z);

	extern inline function get_yzzx():Vec4
		return Vec4.of(this.y, this.z, this.z, this.x);

	extern inline function get_yzzy():Vec4
		return Vec4.of(this.y, this.z, this.z, this.y);

	extern inline function get_yzzz():Vec4
		return Vec4.of(this.y, this.z, this.z, this.z);

	extern inline function get_zxxx():Vec4
		return Vec4.of(this.z, this.x, this.x, this.x);

	extern inline function get_zxxy():Vec4
		return Vec4.of(this.z, this.x, this.x, this.y);

	extern inline function get_zxxz():Vec4
		return Vec4.of(this.z, this.x, this.x, this.z);

	extern inline function get_zxyx():Vec4
		return Vec4.of(this.z, this.x, this.y, this.x);

	extern inline function get_zxyy():Vec4
		return Vec4.of(this.z, this.x, this.y, this.y);

	extern inline function get_zxyz():Vec4
		return Vec4.of(this.z, this.x, this.y, this.z);

	extern inline function get_zxzx():Vec4
		return Vec4.of(this.z, this.x, this.z, this.x);

	extern inline function get_zxzy():Vec4
		return Vec4.of(this.z, this.x, this.z, this.y);

	extern inline function get_zxzz():Vec4
		return Vec4.of(this.z, this.x, this.z, this.z);

	extern inline function get_zyxx():Vec4
		return Vec4.of(this.z, this.y, this.x, this.x);

	extern inline function get_zyxy():Vec4
		return Vec4.of(this.z, this.y, this.x, this.y);

	extern inline function get_zyxz():Vec4
		return Vec4.of(this.z, this.y, this.x, this.z);

	extern inline function get_zyyx():Vec4
		return Vec4.of(this.z, this.y, this.y, this.x);

	extern inline function get_zyyy():Vec4
		return Vec4.of(this.z, this.y, this.y, this.y);

	extern inline function get_zyyz():Vec4
		return Vec4.of(this.z, this.y, this.y, this.z);

	extern inline function get_zyzx():Vec4
		return Vec4.of(this.z, this.y, this.z, this.x);

	extern inline function get_zyzy():Vec4
		return Vec4.of(this.z, this.y, this.z, this.y);

	extern inline function get_zyzz():Vec4
		return Vec4.of(this.z, this.y, this.z, this.z);

	extern inline function get_zzxx():Vec4
		return Vec4.of(this.z, this.z, this.x, this.x);

	extern inline function get_zzxy():Vec4
		return Vec4.of(this.z, this.z, this.x, this.y);

	extern inline function get_zzxz():Vec4
		return Vec4.of(this.z, this.z, this.x, this.z);

	extern inline function get_zzyx():Vec4
		return Vec4.of(this.z, this.z, this.y, this.x);

	extern inline function get_zzyy():Vec4
		return Vec4.of(this.z, this.z, this.y, this.y);

	extern inline function get_zzyz():Vec4
		return Vec4.of(this.z, this.z, this.y, this.z);

	extern inline function get_zzzx():Vec4
		return Vec4.of(this.z, this.z, this.z, this.x);

	extern inline function get_zzzy():Vec4
		return Vec4.of(this.z, this.z, this.z, this.y);

	extern inline function get_zzzz():Vec4
		return Vec4.of(this.z, this.z, this.z, this.z);
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
