package muun.la;

@:forward(x, y, z, w)
abstract Vec4(Vec4Data) from Vec4Data {
	inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = new Vec4Data(x, y, z, w);
	}

	extern public static inline function of(x:Float, y:Float, z:Float, w:Float):Vec4 {
		return new Vec4(x, y, z, w);
	}

	public static var zero(get, never):Vec4;
	public static var one(get, never):Vec4;
	public static var ex(get, never):Vec4;
	public static var ey(get, never):Vec4;
	public static var ez(get, never):Vec4;
	public static var ew(get, never):Vec4;

	extern static inline function get_zero():Vec4 {
		return of(0, 0, 0, 0);
	}

	extern static inline function get_one():Vec4 {
		return of(1, 1, 1, 1);
	}

	extern static inline function get_ex():Vec4 {
		return of(1, 0, 0, 0);
	}

	extern static inline function get_ey():Vec4 {
		return of(0, 1, 0, 0);
	}

	extern static inline function get_ez():Vec4 {
		return of(0, 0, 1, 0);
	}

	extern static inline function get_ew():Vec4 {
		return of(0, 0, 0, 1);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var normalized(get, never):Vec4;
	public var diag(get, never):Mat4;

	extern inline function get_length():Float {
		return Math.sqrt(lengthSq);
	}

	extern inline function get_lengthSq():Float {
		return dot(this);
	}

	extern inline function get_normalized():Vec4 {
		var l = length;
		if (l > 0)
			l = 1 / l;
		return mulf(this, l);
	}

	extern inline function get_diag():Mat4 {
		final a = this;
		return Mat4.of(a.x, 0, 0, 0, 0, a.y, 0, 0, 0, 0, a.z, 0, 0, 0, 0, a.w);
	}

	extern public inline function dot(b:Vec4):Float {
		final a = this;
		return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
	}

	extern public inline function tensorDot(b:Vec4):Mat4 {
		final a = this;
		return Mat4.of(a.x * b.x, a.x * b.y, a.x * b.z, a.x * b.w, a.y * b.x, a.y * b.y, a.y * b.z, a.y * b.w, a.z * b.x, a.z * b.y,
			a.z * b.z, a.z * b.w, a.w * b.x, a.w * b.y, a.w * b.z, a.w * b.w);
	}

	extern public inline function toQuat():Quat {
		final a = this;
		return Quat.of(a.x, a.y, a.z, a.w);
	}

	extern static inline function unary(a:Vec4, f:(a:Float) -> Float):Vec4 {
		return of(f(a.x), f(a.y), f(a.z), f(a.w));
	}

	extern static inline function binary(a:Vec4, b:Vec4, f:(a:Float, b:Float) -> Float):Vec4 {
		return of(f(a.x, b.x), f(a.y, b.y), f(a.z, b.z), f(a.w, b.w));
	}

	extern static inline function ternary(a:Vec4, b:Vec4, c:Vec4, f:(a:Float, b:Float, c:Float) -> Float):Vec4 {
		return of(f(a.x, b.x, c.x), f(a.y, b.y, c.y), f(a.z, b.z, c.z), f(a.w, b.w, c.w));
	}

	extern public inline function abs():Vec4 {
		return unary(this, x -> x < 0 ? -x : x);
	}

	extern public inline function min(b:Vec4):Vec4 {
		return binary(this, b, (x, y) -> x < y ? x : y);
	}

	extern public inline function max(b:Vec4):Vec4 {
		return binary(this, b, (x, y) -> x > y ? x : y);
	}

	extern public inline function clamp(min:Vec4, max:Vec4):Vec4 {
		return ternary(this, min, max, (x, min, max) -> x < min ? min : x > max ? max : x);
	}

	@:op(-A)
	extern public static inline function neg(a:Vec4):Vec4 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern public static inline function add(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern public static inline function sub(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern public static inline function mul(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a * b);
	}

	@:op(A / B)
	extern public static inline function div(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern public static inline function addf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern public static inline function subf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern public static inline function fsub(a:Float, b:Vec4):Vec4 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern public static inline function mulf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern public static inline function divf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern public static inline function fdiv(a:Float, b:Vec4):Vec4 {
		return unary(b, b -> a / b);
	}

	@:op(A << B)
	extern public static inline function assign(a:Vec4, b:Vec4):Vec4 {
		a.x = b.x;
		a.y = b.y;
		a.z = b.z;
		a.w = b.w;
		return a;
	}

	@:op(A += B)
	extern public static inline function addEq(a:Vec4, b:Vec4):Vec4 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subEq(a:Vec4, b:Vec4):Vec4 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulEq(a:Vec4, b:Vec4):Vec4 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divEq(a:Vec4, b:Vec4):Vec4 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern public static inline function addfEq(a:Vec4, b:Float):Vec4 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subfEq(a:Vec4, b:Float):Vec4 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulfEq(a:Vec4, b:Float):Vec4 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divfEq(a:Vec4, b:Float):Vec4 {
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
			case 3:
				this.w;
			case _:
				throw "Vec4 index out of bounds: " + index;
		}
	}

	extern public inline function map(f:(component:Float) -> Float):Vec4 {
		return unary(this, f);
	}

	extern public inline function set(x:Float, y:Float, z:Float, w:Float):Vec4 {
		return assign(this, of(x, y, z, w));
	}

	public function toString():String {
		final a = this;
		return 'Vec4(${a.x}, ${a.y}, ${a.z}, ${a.w})';
	}

	public var xx(get, never):Vec2;
	public var xy(get, never):Vec2;
	public var xz(get, never):Vec2;
	public var xw(get, never):Vec2;
	public var yx(get, never):Vec2;
	public var yy(get, never):Vec2;
	public var yz(get, never):Vec2;
	public var yw(get, never):Vec2;
	public var zx(get, never):Vec2;
	public var zy(get, never):Vec2;
	public var zz(get, never):Vec2;
	public var zw(get, never):Vec2;
	public var wx(get, never):Vec2;
	public var wy(get, never):Vec2;
	public var wz(get, never):Vec2;
	public var ww(get, never):Vec2;
	public var xxx(get, never):Vec3;
	public var xxy(get, never):Vec3;
	public var xxz(get, never):Vec3;
	public var xxw(get, never):Vec3;
	public var xyx(get, never):Vec3;
	public var xyy(get, never):Vec3;
	public var xyz(get, never):Vec3;
	public var xyw(get, never):Vec3;
	public var xzx(get, never):Vec3;
	public var xzy(get, never):Vec3;
	public var xzz(get, never):Vec3;
	public var xzw(get, never):Vec3;
	public var xwx(get, never):Vec3;
	public var xwy(get, never):Vec3;
	public var xwz(get, never):Vec3;
	public var xww(get, never):Vec3;
	public var yxx(get, never):Vec3;
	public var yxy(get, never):Vec3;
	public var yxz(get, never):Vec3;
	public var yxw(get, never):Vec3;
	public var yyx(get, never):Vec3;
	public var yyy(get, never):Vec3;
	public var yyz(get, never):Vec3;
	public var yyw(get, never):Vec3;
	public var yzx(get, never):Vec3;
	public var yzy(get, never):Vec3;
	public var yzz(get, never):Vec3;
	public var yzw(get, never):Vec3;
	public var ywx(get, never):Vec3;
	public var ywy(get, never):Vec3;
	public var ywz(get, never):Vec3;
	public var yww(get, never):Vec3;
	public var zxx(get, never):Vec3;
	public var zxy(get, never):Vec3;
	public var zxz(get, never):Vec3;
	public var zxw(get, never):Vec3;
	public var zyx(get, never):Vec3;
	public var zyy(get, never):Vec3;
	public var zyz(get, never):Vec3;
	public var zyw(get, never):Vec3;
	public var zzx(get, never):Vec3;
	public var zzy(get, never):Vec3;
	public var zzz(get, never):Vec3;
	public var zzw(get, never):Vec3;
	public var zwx(get, never):Vec3;
	public var zwy(get, never):Vec3;
	public var zwz(get, never):Vec3;
	public var zww(get, never):Vec3;
	public var wxx(get, never):Vec3;
	public var wxy(get, never):Vec3;
	public var wxz(get, never):Vec3;
	public var wxw(get, never):Vec3;
	public var wyx(get, never):Vec3;
	public var wyy(get, never):Vec3;
	public var wyz(get, never):Vec3;
	public var wyw(get, never):Vec3;
	public var wzx(get, never):Vec3;
	public var wzy(get, never):Vec3;
	public var wzz(get, never):Vec3;
	public var wzw(get, never):Vec3;
	public var wwx(get, never):Vec3;
	public var wwy(get, never):Vec3;
	public var wwz(get, never):Vec3;
	public var www(get, never):Vec3;
	public var xxxx(get, never):Vec4;
	public var xxxy(get, never):Vec4;
	public var xxxz(get, never):Vec4;
	public var xxxw(get, never):Vec4;
	public var xxyx(get, never):Vec4;
	public var xxyy(get, never):Vec4;
	public var xxyz(get, never):Vec4;
	public var xxyw(get, never):Vec4;
	public var xxzx(get, never):Vec4;
	public var xxzy(get, never):Vec4;
	public var xxzz(get, never):Vec4;
	public var xxzw(get, never):Vec4;
	public var xxwx(get, never):Vec4;
	public var xxwy(get, never):Vec4;
	public var xxwz(get, never):Vec4;
	public var xxww(get, never):Vec4;
	public var xyxx(get, never):Vec4;
	public var xyxy(get, never):Vec4;
	public var xyxz(get, never):Vec4;
	public var xyxw(get, never):Vec4;
	public var xyyx(get, never):Vec4;
	public var xyyy(get, never):Vec4;
	public var xyyz(get, never):Vec4;
	public var xyyw(get, never):Vec4;
	public var xyzx(get, never):Vec4;
	public var xyzy(get, never):Vec4;
	public var xyzz(get, never):Vec4;
	public var xyzw(get, never):Vec4;
	public var xywx(get, never):Vec4;
	public var xywy(get, never):Vec4;
	public var xywz(get, never):Vec4;
	public var xyww(get, never):Vec4;
	public var xzxx(get, never):Vec4;
	public var xzxy(get, never):Vec4;
	public var xzxz(get, never):Vec4;
	public var xzxw(get, never):Vec4;
	public var xzyx(get, never):Vec4;
	public var xzyy(get, never):Vec4;
	public var xzyz(get, never):Vec4;
	public var xzyw(get, never):Vec4;
	public var xzzx(get, never):Vec4;
	public var xzzy(get, never):Vec4;
	public var xzzz(get, never):Vec4;
	public var xzzw(get, never):Vec4;
	public var xzwx(get, never):Vec4;
	public var xzwy(get, never):Vec4;
	public var xzwz(get, never):Vec4;
	public var xzww(get, never):Vec4;
	public var xwxx(get, never):Vec4;
	public var xwxy(get, never):Vec4;
	public var xwxz(get, never):Vec4;
	public var xwxw(get, never):Vec4;
	public var xwyx(get, never):Vec4;
	public var xwyy(get, never):Vec4;
	public var xwyz(get, never):Vec4;
	public var xwyw(get, never):Vec4;
	public var xwzx(get, never):Vec4;
	public var xwzy(get, never):Vec4;
	public var xwzz(get, never):Vec4;
	public var xwzw(get, never):Vec4;
	public var xwwx(get, never):Vec4;
	public var xwwy(get, never):Vec4;
	public var xwwz(get, never):Vec4;
	public var xwww(get, never):Vec4;
	public var yxxx(get, never):Vec4;
	public var yxxy(get, never):Vec4;
	public var yxxz(get, never):Vec4;
	public var yxxw(get, never):Vec4;
	public var yxyx(get, never):Vec4;
	public var yxyy(get, never):Vec4;
	public var yxyz(get, never):Vec4;
	public var yxyw(get, never):Vec4;
	public var yxzx(get, never):Vec4;
	public var yxzy(get, never):Vec4;
	public var yxzz(get, never):Vec4;
	public var yxzw(get, never):Vec4;
	public var yxwx(get, never):Vec4;
	public var yxwy(get, never):Vec4;
	public var yxwz(get, never):Vec4;
	public var yxww(get, never):Vec4;
	public var yyxx(get, never):Vec4;
	public var yyxy(get, never):Vec4;
	public var yyxz(get, never):Vec4;
	public var yyxw(get, never):Vec4;
	public var yyyx(get, never):Vec4;
	public var yyyy(get, never):Vec4;
	public var yyyz(get, never):Vec4;
	public var yyyw(get, never):Vec4;
	public var yyzx(get, never):Vec4;
	public var yyzy(get, never):Vec4;
	public var yyzz(get, never):Vec4;
	public var yyzw(get, never):Vec4;
	public var yywx(get, never):Vec4;
	public var yywy(get, never):Vec4;
	public var yywz(get, never):Vec4;
	public var yyww(get, never):Vec4;
	public var yzxx(get, never):Vec4;
	public var yzxy(get, never):Vec4;
	public var yzxz(get, never):Vec4;
	public var yzxw(get, never):Vec4;
	public var yzyx(get, never):Vec4;
	public var yzyy(get, never):Vec4;
	public var yzyz(get, never):Vec4;
	public var yzyw(get, never):Vec4;
	public var yzzx(get, never):Vec4;
	public var yzzy(get, never):Vec4;
	public var yzzz(get, never):Vec4;
	public var yzzw(get, never):Vec4;
	public var yzwx(get, never):Vec4;
	public var yzwy(get, never):Vec4;
	public var yzwz(get, never):Vec4;
	public var yzww(get, never):Vec4;
	public var ywxx(get, never):Vec4;
	public var ywxy(get, never):Vec4;
	public var ywxz(get, never):Vec4;
	public var ywxw(get, never):Vec4;
	public var ywyx(get, never):Vec4;
	public var ywyy(get, never):Vec4;
	public var ywyz(get, never):Vec4;
	public var ywyw(get, never):Vec4;
	public var ywzx(get, never):Vec4;
	public var ywzy(get, never):Vec4;
	public var ywzz(get, never):Vec4;
	public var ywzw(get, never):Vec4;
	public var ywwx(get, never):Vec4;
	public var ywwy(get, never):Vec4;
	public var ywwz(get, never):Vec4;
	public var ywww(get, never):Vec4;
	public var zxxx(get, never):Vec4;
	public var zxxy(get, never):Vec4;
	public var zxxz(get, never):Vec4;
	public var zxxw(get, never):Vec4;
	public var zxyx(get, never):Vec4;
	public var zxyy(get, never):Vec4;
	public var zxyz(get, never):Vec4;
	public var zxyw(get, never):Vec4;
	public var zxzx(get, never):Vec4;
	public var zxzy(get, never):Vec4;
	public var zxzz(get, never):Vec4;
	public var zxzw(get, never):Vec4;
	public var zxwx(get, never):Vec4;
	public var zxwy(get, never):Vec4;
	public var zxwz(get, never):Vec4;
	public var zxww(get, never):Vec4;
	public var zyxx(get, never):Vec4;
	public var zyxy(get, never):Vec4;
	public var zyxz(get, never):Vec4;
	public var zyxw(get, never):Vec4;
	public var zyyx(get, never):Vec4;
	public var zyyy(get, never):Vec4;
	public var zyyz(get, never):Vec4;
	public var zyyw(get, never):Vec4;
	public var zyzx(get, never):Vec4;
	public var zyzy(get, never):Vec4;
	public var zyzz(get, never):Vec4;
	public var zyzw(get, never):Vec4;
	public var zywx(get, never):Vec4;
	public var zywy(get, never):Vec4;
	public var zywz(get, never):Vec4;
	public var zyww(get, never):Vec4;
	public var zzxx(get, never):Vec4;
	public var zzxy(get, never):Vec4;
	public var zzxz(get, never):Vec4;
	public var zzxw(get, never):Vec4;
	public var zzyx(get, never):Vec4;
	public var zzyy(get, never):Vec4;
	public var zzyz(get, never):Vec4;
	public var zzyw(get, never):Vec4;
	public var zzzx(get, never):Vec4;
	public var zzzy(get, never):Vec4;
	public var zzzz(get, never):Vec4;
	public var zzzw(get, never):Vec4;
	public var zzwx(get, never):Vec4;
	public var zzwy(get, never):Vec4;
	public var zzwz(get, never):Vec4;
	public var zzww(get, never):Vec4;
	public var zwxx(get, never):Vec4;
	public var zwxy(get, never):Vec4;
	public var zwxz(get, never):Vec4;
	public var zwxw(get, never):Vec4;
	public var zwyx(get, never):Vec4;
	public var zwyy(get, never):Vec4;
	public var zwyz(get, never):Vec4;
	public var zwyw(get, never):Vec4;
	public var zwzx(get, never):Vec4;
	public var zwzy(get, never):Vec4;
	public var zwzz(get, never):Vec4;
	public var zwzw(get, never):Vec4;
	public var zwwx(get, never):Vec4;
	public var zwwy(get, never):Vec4;
	public var zwwz(get, never):Vec4;
	public var zwww(get, never):Vec4;
	public var wxxx(get, never):Vec4;
	public var wxxy(get, never):Vec4;
	public var wxxz(get, never):Vec4;
	public var wxxw(get, never):Vec4;
	public var wxyx(get, never):Vec4;
	public var wxyy(get, never):Vec4;
	public var wxyz(get, never):Vec4;
	public var wxyw(get, never):Vec4;
	public var wxzx(get, never):Vec4;
	public var wxzy(get, never):Vec4;
	public var wxzz(get, never):Vec4;
	public var wxzw(get, never):Vec4;
	public var wxwx(get, never):Vec4;
	public var wxwy(get, never):Vec4;
	public var wxwz(get, never):Vec4;
	public var wxww(get, never):Vec4;
	public var wyxx(get, never):Vec4;
	public var wyxy(get, never):Vec4;
	public var wyxz(get, never):Vec4;
	public var wyxw(get, never):Vec4;
	public var wyyx(get, never):Vec4;
	public var wyyy(get, never):Vec4;
	public var wyyz(get, never):Vec4;
	public var wyyw(get, never):Vec4;
	public var wyzx(get, never):Vec4;
	public var wyzy(get, never):Vec4;
	public var wyzz(get, never):Vec4;
	public var wyzw(get, never):Vec4;
	public var wywx(get, never):Vec4;
	public var wywy(get, never):Vec4;
	public var wywz(get, never):Vec4;
	public var wyww(get, never):Vec4;
	public var wzxx(get, never):Vec4;
	public var wzxy(get, never):Vec4;
	public var wzxz(get, never):Vec4;
	public var wzxw(get, never):Vec4;
	public var wzyx(get, never):Vec4;
	public var wzyy(get, never):Vec4;
	public var wzyz(get, never):Vec4;
	public var wzyw(get, never):Vec4;
	public var wzzx(get, never):Vec4;
	public var wzzy(get, never):Vec4;
	public var wzzz(get, never):Vec4;
	public var wzzw(get, never):Vec4;
	public var wzwx(get, never):Vec4;
	public var wzwy(get, never):Vec4;
	public var wzwz(get, never):Vec4;
	public var wzww(get, never):Vec4;
	public var wwxx(get, never):Vec4;
	public var wwxy(get, never):Vec4;
	public var wwxz(get, never):Vec4;
	public var wwxw(get, never):Vec4;
	public var wwyx(get, never):Vec4;
	public var wwyy(get, never):Vec4;
	public var wwyz(get, never):Vec4;
	public var wwyw(get, never):Vec4;
	public var wwzx(get, never):Vec4;
	public var wwzy(get, never):Vec4;
	public var wwzz(get, never):Vec4;
	public var wwzw(get, never):Vec4;
	public var wwwx(get, never):Vec4;
	public var wwwy(get, never):Vec4;
	public var wwwz(get, never):Vec4;
	public var wwww(get, never):Vec4;

	extern inline function get_xx():Vec2
		return Vec2.of(this.x, this.x);

	extern inline function get_xy():Vec2
		return Vec2.of(this.x, this.y);

	extern inline function get_xz():Vec2
		return Vec2.of(this.x, this.z);

	extern inline function get_xw():Vec2
		return Vec2.of(this.x, this.w);

	extern inline function get_yx():Vec2
		return Vec2.of(this.y, this.x);

	extern inline function get_yy():Vec2
		return Vec2.of(this.y, this.y);

	extern inline function get_yz():Vec2
		return Vec2.of(this.y, this.z);

	extern inline function get_yw():Vec2
		return Vec2.of(this.y, this.w);

	extern inline function get_zx():Vec2
		return Vec2.of(this.z, this.x);

	extern inline function get_zy():Vec2
		return Vec2.of(this.z, this.y);

	extern inline function get_zz():Vec2
		return Vec2.of(this.z, this.z);

	extern inline function get_zw():Vec2
		return Vec2.of(this.z, this.w);

	extern inline function get_wx():Vec2
		return Vec2.of(this.w, this.x);

	extern inline function get_wy():Vec2
		return Vec2.of(this.w, this.y);

	extern inline function get_wz():Vec2
		return Vec2.of(this.w, this.z);

	extern inline function get_ww():Vec2
		return Vec2.of(this.w, this.w);

	extern inline function get_xxx():Vec3
		return Vec3.of(this.x, this.x, this.x);

	extern inline function get_xxy():Vec3
		return Vec3.of(this.x, this.x, this.y);

	extern inline function get_xxz():Vec3
		return Vec3.of(this.x, this.x, this.z);

	extern inline function get_xxw():Vec3
		return Vec3.of(this.x, this.x, this.w);

	extern inline function get_xyx():Vec3
		return Vec3.of(this.x, this.y, this.x);

	extern inline function get_xyy():Vec3
		return Vec3.of(this.x, this.y, this.y);

	extern inline function get_xyz():Vec3
		return Vec3.of(this.x, this.y, this.z);

	extern inline function get_xyw():Vec3
		return Vec3.of(this.x, this.y, this.w);

	extern inline function get_xzx():Vec3
		return Vec3.of(this.x, this.z, this.x);

	extern inline function get_xzy():Vec3
		return Vec3.of(this.x, this.z, this.y);

	extern inline function get_xzz():Vec3
		return Vec3.of(this.x, this.z, this.z);

	extern inline function get_xzw():Vec3
		return Vec3.of(this.x, this.z, this.w);

	extern inline function get_xwx():Vec3
		return Vec3.of(this.x, this.w, this.x);

	extern inline function get_xwy():Vec3
		return Vec3.of(this.x, this.w, this.y);

	extern inline function get_xwz():Vec3
		return Vec3.of(this.x, this.w, this.z);

	extern inline function get_xww():Vec3
		return Vec3.of(this.x, this.w, this.w);

	extern inline function get_yxx():Vec3
		return Vec3.of(this.y, this.x, this.x);

	extern inline function get_yxy():Vec3
		return Vec3.of(this.y, this.x, this.y);

	extern inline function get_yxz():Vec3
		return Vec3.of(this.y, this.x, this.z);

	extern inline function get_yxw():Vec3
		return Vec3.of(this.y, this.x, this.w);

	extern inline function get_yyx():Vec3
		return Vec3.of(this.y, this.y, this.x);

	extern inline function get_yyy():Vec3
		return Vec3.of(this.y, this.y, this.y);

	extern inline function get_yyz():Vec3
		return Vec3.of(this.y, this.y, this.z);

	extern inline function get_yyw():Vec3
		return Vec3.of(this.y, this.y, this.w);

	extern inline function get_yzx():Vec3
		return Vec3.of(this.y, this.z, this.x);

	extern inline function get_yzy():Vec3
		return Vec3.of(this.y, this.z, this.y);

	extern inline function get_yzz():Vec3
		return Vec3.of(this.y, this.z, this.z);

	extern inline function get_yzw():Vec3
		return Vec3.of(this.y, this.z, this.w);

	extern inline function get_ywx():Vec3
		return Vec3.of(this.y, this.w, this.x);

	extern inline function get_ywy():Vec3
		return Vec3.of(this.y, this.w, this.y);

	extern inline function get_ywz():Vec3
		return Vec3.of(this.y, this.w, this.z);

	extern inline function get_yww():Vec3
		return Vec3.of(this.y, this.w, this.w);

	extern inline function get_zxx():Vec3
		return Vec3.of(this.z, this.x, this.x);

	extern inline function get_zxy():Vec3
		return Vec3.of(this.z, this.x, this.y);

	extern inline function get_zxz():Vec3
		return Vec3.of(this.z, this.x, this.z);

	extern inline function get_zxw():Vec3
		return Vec3.of(this.z, this.x, this.w);

	extern inline function get_zyx():Vec3
		return Vec3.of(this.z, this.y, this.x);

	extern inline function get_zyy():Vec3
		return Vec3.of(this.z, this.y, this.y);

	extern inline function get_zyz():Vec3
		return Vec3.of(this.z, this.y, this.z);

	extern inline function get_zyw():Vec3
		return Vec3.of(this.z, this.y, this.w);

	extern inline function get_zzx():Vec3
		return Vec3.of(this.z, this.z, this.x);

	extern inline function get_zzy():Vec3
		return Vec3.of(this.z, this.z, this.y);

	extern inline function get_zzz():Vec3
		return Vec3.of(this.z, this.z, this.z);

	extern inline function get_zzw():Vec3
		return Vec3.of(this.z, this.z, this.w);

	extern inline function get_zwx():Vec3
		return Vec3.of(this.z, this.w, this.x);

	extern inline function get_zwy():Vec3
		return Vec3.of(this.z, this.w, this.y);

	extern inline function get_zwz():Vec3
		return Vec3.of(this.z, this.w, this.z);

	extern inline function get_zww():Vec3
		return Vec3.of(this.z, this.w, this.w);

	extern inline function get_wxx():Vec3
		return Vec3.of(this.w, this.x, this.x);

	extern inline function get_wxy():Vec3
		return Vec3.of(this.w, this.x, this.y);

	extern inline function get_wxz():Vec3
		return Vec3.of(this.w, this.x, this.z);

	extern inline function get_wxw():Vec3
		return Vec3.of(this.w, this.x, this.w);

	extern inline function get_wyx():Vec3
		return Vec3.of(this.w, this.y, this.x);

	extern inline function get_wyy():Vec3
		return Vec3.of(this.w, this.y, this.y);

	extern inline function get_wyz():Vec3
		return Vec3.of(this.w, this.y, this.z);

	extern inline function get_wyw():Vec3
		return Vec3.of(this.w, this.y, this.w);

	extern inline function get_wzx():Vec3
		return Vec3.of(this.w, this.z, this.x);

	extern inline function get_wzy():Vec3
		return Vec3.of(this.w, this.z, this.y);

	extern inline function get_wzz():Vec3
		return Vec3.of(this.w, this.z, this.z);

	extern inline function get_wzw():Vec3
		return Vec3.of(this.w, this.z, this.w);

	extern inline function get_wwx():Vec3
		return Vec3.of(this.w, this.w, this.x);

	extern inline function get_wwy():Vec3
		return Vec3.of(this.w, this.w, this.y);

	extern inline function get_wwz():Vec3
		return Vec3.of(this.w, this.w, this.z);

	extern inline function get_www():Vec3
		return Vec3.of(this.w, this.w, this.w);

	extern inline function get_xxxx():Vec4
		return Vec4.of(this.x, this.x, this.x, this.x);

	extern inline function get_xxxy():Vec4
		return Vec4.of(this.x, this.x, this.x, this.y);

	extern inline function get_xxxz():Vec4
		return Vec4.of(this.x, this.x, this.x, this.z);

	extern inline function get_xxxw():Vec4
		return Vec4.of(this.x, this.x, this.x, this.w);

	extern inline function get_xxyx():Vec4
		return Vec4.of(this.x, this.x, this.y, this.x);

	extern inline function get_xxyy():Vec4
		return Vec4.of(this.x, this.x, this.y, this.y);

	extern inline function get_xxyz():Vec4
		return Vec4.of(this.x, this.x, this.y, this.z);

	extern inline function get_xxyw():Vec4
		return Vec4.of(this.x, this.x, this.y, this.w);

	extern inline function get_xxzx():Vec4
		return Vec4.of(this.x, this.x, this.z, this.x);

	extern inline function get_xxzy():Vec4
		return Vec4.of(this.x, this.x, this.z, this.y);

	extern inline function get_xxzz():Vec4
		return Vec4.of(this.x, this.x, this.z, this.z);

	extern inline function get_xxzw():Vec4
		return Vec4.of(this.x, this.x, this.z, this.w);

	extern inline function get_xxwx():Vec4
		return Vec4.of(this.x, this.x, this.w, this.x);

	extern inline function get_xxwy():Vec4
		return Vec4.of(this.x, this.x, this.w, this.y);

	extern inline function get_xxwz():Vec4
		return Vec4.of(this.x, this.x, this.w, this.z);

	extern inline function get_xxww():Vec4
		return Vec4.of(this.x, this.x, this.w, this.w);

	extern inline function get_xyxx():Vec4
		return Vec4.of(this.x, this.y, this.x, this.x);

	extern inline function get_xyxy():Vec4
		return Vec4.of(this.x, this.y, this.x, this.y);

	extern inline function get_xyxz():Vec4
		return Vec4.of(this.x, this.y, this.x, this.z);

	extern inline function get_xyxw():Vec4
		return Vec4.of(this.x, this.y, this.x, this.w);

	extern inline function get_xyyx():Vec4
		return Vec4.of(this.x, this.y, this.y, this.x);

	extern inline function get_xyyy():Vec4
		return Vec4.of(this.x, this.y, this.y, this.y);

	extern inline function get_xyyz():Vec4
		return Vec4.of(this.x, this.y, this.y, this.z);

	extern inline function get_xyyw():Vec4
		return Vec4.of(this.x, this.y, this.y, this.w);

	extern inline function get_xyzx():Vec4
		return Vec4.of(this.x, this.y, this.z, this.x);

	extern inline function get_xyzy():Vec4
		return Vec4.of(this.x, this.y, this.z, this.y);

	extern inline function get_xyzz():Vec4
		return Vec4.of(this.x, this.y, this.z, this.z);

	extern inline function get_xyzw():Vec4
		return Vec4.of(this.x, this.y, this.z, this.w);

	extern inline function get_xywx():Vec4
		return Vec4.of(this.x, this.y, this.w, this.x);

	extern inline function get_xywy():Vec4
		return Vec4.of(this.x, this.y, this.w, this.y);

	extern inline function get_xywz():Vec4
		return Vec4.of(this.x, this.y, this.w, this.z);

	extern inline function get_xyww():Vec4
		return Vec4.of(this.x, this.y, this.w, this.w);

	extern inline function get_xzxx():Vec4
		return Vec4.of(this.x, this.z, this.x, this.x);

	extern inline function get_xzxy():Vec4
		return Vec4.of(this.x, this.z, this.x, this.y);

	extern inline function get_xzxz():Vec4
		return Vec4.of(this.x, this.z, this.x, this.z);

	extern inline function get_xzxw():Vec4
		return Vec4.of(this.x, this.z, this.x, this.w);

	extern inline function get_xzyx():Vec4
		return Vec4.of(this.x, this.z, this.y, this.x);

	extern inline function get_xzyy():Vec4
		return Vec4.of(this.x, this.z, this.y, this.y);

	extern inline function get_xzyz():Vec4
		return Vec4.of(this.x, this.z, this.y, this.z);

	extern inline function get_xzyw():Vec4
		return Vec4.of(this.x, this.z, this.y, this.w);

	extern inline function get_xzzx():Vec4
		return Vec4.of(this.x, this.z, this.z, this.x);

	extern inline function get_xzzy():Vec4
		return Vec4.of(this.x, this.z, this.z, this.y);

	extern inline function get_xzzz():Vec4
		return Vec4.of(this.x, this.z, this.z, this.z);

	extern inline function get_xzzw():Vec4
		return Vec4.of(this.x, this.z, this.z, this.w);

	extern inline function get_xzwx():Vec4
		return Vec4.of(this.x, this.z, this.w, this.x);

	extern inline function get_xzwy():Vec4
		return Vec4.of(this.x, this.z, this.w, this.y);

	extern inline function get_xzwz():Vec4
		return Vec4.of(this.x, this.z, this.w, this.z);

	extern inline function get_xzww():Vec4
		return Vec4.of(this.x, this.z, this.w, this.w);

	extern inline function get_xwxx():Vec4
		return Vec4.of(this.x, this.w, this.x, this.x);

	extern inline function get_xwxy():Vec4
		return Vec4.of(this.x, this.w, this.x, this.y);

	extern inline function get_xwxz():Vec4
		return Vec4.of(this.x, this.w, this.x, this.z);

	extern inline function get_xwxw():Vec4
		return Vec4.of(this.x, this.w, this.x, this.w);

	extern inline function get_xwyx():Vec4
		return Vec4.of(this.x, this.w, this.y, this.x);

	extern inline function get_xwyy():Vec4
		return Vec4.of(this.x, this.w, this.y, this.y);

	extern inline function get_xwyz():Vec4
		return Vec4.of(this.x, this.w, this.y, this.z);

	extern inline function get_xwyw():Vec4
		return Vec4.of(this.x, this.w, this.y, this.w);

	extern inline function get_xwzx():Vec4
		return Vec4.of(this.x, this.w, this.z, this.x);

	extern inline function get_xwzy():Vec4
		return Vec4.of(this.x, this.w, this.z, this.y);

	extern inline function get_xwzz():Vec4
		return Vec4.of(this.x, this.w, this.z, this.z);

	extern inline function get_xwzw():Vec4
		return Vec4.of(this.x, this.w, this.z, this.w);

	extern inline function get_xwwx():Vec4
		return Vec4.of(this.x, this.w, this.w, this.x);

	extern inline function get_xwwy():Vec4
		return Vec4.of(this.x, this.w, this.w, this.y);

	extern inline function get_xwwz():Vec4
		return Vec4.of(this.x, this.w, this.w, this.z);

	extern inline function get_xwww():Vec4
		return Vec4.of(this.x, this.w, this.w, this.w);

	extern inline function get_yxxx():Vec4
		return Vec4.of(this.y, this.x, this.x, this.x);

	extern inline function get_yxxy():Vec4
		return Vec4.of(this.y, this.x, this.x, this.y);

	extern inline function get_yxxz():Vec4
		return Vec4.of(this.y, this.x, this.x, this.z);

	extern inline function get_yxxw():Vec4
		return Vec4.of(this.y, this.x, this.x, this.w);

	extern inline function get_yxyx():Vec4
		return Vec4.of(this.y, this.x, this.y, this.x);

	extern inline function get_yxyy():Vec4
		return Vec4.of(this.y, this.x, this.y, this.y);

	extern inline function get_yxyz():Vec4
		return Vec4.of(this.y, this.x, this.y, this.z);

	extern inline function get_yxyw():Vec4
		return Vec4.of(this.y, this.x, this.y, this.w);

	extern inline function get_yxzx():Vec4
		return Vec4.of(this.y, this.x, this.z, this.x);

	extern inline function get_yxzy():Vec4
		return Vec4.of(this.y, this.x, this.z, this.y);

	extern inline function get_yxzz():Vec4
		return Vec4.of(this.y, this.x, this.z, this.z);

	extern inline function get_yxzw():Vec4
		return Vec4.of(this.y, this.x, this.z, this.w);

	extern inline function get_yxwx():Vec4
		return Vec4.of(this.y, this.x, this.w, this.x);

	extern inline function get_yxwy():Vec4
		return Vec4.of(this.y, this.x, this.w, this.y);

	extern inline function get_yxwz():Vec4
		return Vec4.of(this.y, this.x, this.w, this.z);

	extern inline function get_yxww():Vec4
		return Vec4.of(this.y, this.x, this.w, this.w);

	extern inline function get_yyxx():Vec4
		return Vec4.of(this.y, this.y, this.x, this.x);

	extern inline function get_yyxy():Vec4
		return Vec4.of(this.y, this.y, this.x, this.y);

	extern inline function get_yyxz():Vec4
		return Vec4.of(this.y, this.y, this.x, this.z);

	extern inline function get_yyxw():Vec4
		return Vec4.of(this.y, this.y, this.x, this.w);

	extern inline function get_yyyx():Vec4
		return Vec4.of(this.y, this.y, this.y, this.x);

	extern inline function get_yyyy():Vec4
		return Vec4.of(this.y, this.y, this.y, this.y);

	extern inline function get_yyyz():Vec4
		return Vec4.of(this.y, this.y, this.y, this.z);

	extern inline function get_yyyw():Vec4
		return Vec4.of(this.y, this.y, this.y, this.w);

	extern inline function get_yyzx():Vec4
		return Vec4.of(this.y, this.y, this.z, this.x);

	extern inline function get_yyzy():Vec4
		return Vec4.of(this.y, this.y, this.z, this.y);

	extern inline function get_yyzz():Vec4
		return Vec4.of(this.y, this.y, this.z, this.z);

	extern inline function get_yyzw():Vec4
		return Vec4.of(this.y, this.y, this.z, this.w);

	extern inline function get_yywx():Vec4
		return Vec4.of(this.y, this.y, this.w, this.x);

	extern inline function get_yywy():Vec4
		return Vec4.of(this.y, this.y, this.w, this.y);

	extern inline function get_yywz():Vec4
		return Vec4.of(this.y, this.y, this.w, this.z);

	extern inline function get_yyww():Vec4
		return Vec4.of(this.y, this.y, this.w, this.w);

	extern inline function get_yzxx():Vec4
		return Vec4.of(this.y, this.z, this.x, this.x);

	extern inline function get_yzxy():Vec4
		return Vec4.of(this.y, this.z, this.x, this.y);

	extern inline function get_yzxz():Vec4
		return Vec4.of(this.y, this.z, this.x, this.z);

	extern inline function get_yzxw():Vec4
		return Vec4.of(this.y, this.z, this.x, this.w);

	extern inline function get_yzyx():Vec4
		return Vec4.of(this.y, this.z, this.y, this.x);

	extern inline function get_yzyy():Vec4
		return Vec4.of(this.y, this.z, this.y, this.y);

	extern inline function get_yzyz():Vec4
		return Vec4.of(this.y, this.z, this.y, this.z);

	extern inline function get_yzyw():Vec4
		return Vec4.of(this.y, this.z, this.y, this.w);

	extern inline function get_yzzx():Vec4
		return Vec4.of(this.y, this.z, this.z, this.x);

	extern inline function get_yzzy():Vec4
		return Vec4.of(this.y, this.z, this.z, this.y);

	extern inline function get_yzzz():Vec4
		return Vec4.of(this.y, this.z, this.z, this.z);

	extern inline function get_yzzw():Vec4
		return Vec4.of(this.y, this.z, this.z, this.w);

	extern inline function get_yzwx():Vec4
		return Vec4.of(this.y, this.z, this.w, this.x);

	extern inline function get_yzwy():Vec4
		return Vec4.of(this.y, this.z, this.w, this.y);

	extern inline function get_yzwz():Vec4
		return Vec4.of(this.y, this.z, this.w, this.z);

	extern inline function get_yzww():Vec4
		return Vec4.of(this.y, this.z, this.w, this.w);

	extern inline function get_ywxx():Vec4
		return Vec4.of(this.y, this.w, this.x, this.x);

	extern inline function get_ywxy():Vec4
		return Vec4.of(this.y, this.w, this.x, this.y);

	extern inline function get_ywxz():Vec4
		return Vec4.of(this.y, this.w, this.x, this.z);

	extern inline function get_ywxw():Vec4
		return Vec4.of(this.y, this.w, this.x, this.w);

	extern inline function get_ywyx():Vec4
		return Vec4.of(this.y, this.w, this.y, this.x);

	extern inline function get_ywyy():Vec4
		return Vec4.of(this.y, this.w, this.y, this.y);

	extern inline function get_ywyz():Vec4
		return Vec4.of(this.y, this.w, this.y, this.z);

	extern inline function get_ywyw():Vec4
		return Vec4.of(this.y, this.w, this.y, this.w);

	extern inline function get_ywzx():Vec4
		return Vec4.of(this.y, this.w, this.z, this.x);

	extern inline function get_ywzy():Vec4
		return Vec4.of(this.y, this.w, this.z, this.y);

	extern inline function get_ywzz():Vec4
		return Vec4.of(this.y, this.w, this.z, this.z);

	extern inline function get_ywzw():Vec4
		return Vec4.of(this.y, this.w, this.z, this.w);

	extern inline function get_ywwx():Vec4
		return Vec4.of(this.y, this.w, this.w, this.x);

	extern inline function get_ywwy():Vec4
		return Vec4.of(this.y, this.w, this.w, this.y);

	extern inline function get_ywwz():Vec4
		return Vec4.of(this.y, this.w, this.w, this.z);

	extern inline function get_ywww():Vec4
		return Vec4.of(this.y, this.w, this.w, this.w);

	extern inline function get_zxxx():Vec4
		return Vec4.of(this.z, this.x, this.x, this.x);

	extern inline function get_zxxy():Vec4
		return Vec4.of(this.z, this.x, this.x, this.y);

	extern inline function get_zxxz():Vec4
		return Vec4.of(this.z, this.x, this.x, this.z);

	extern inline function get_zxxw():Vec4
		return Vec4.of(this.z, this.x, this.x, this.w);

	extern inline function get_zxyx():Vec4
		return Vec4.of(this.z, this.x, this.y, this.x);

	extern inline function get_zxyy():Vec4
		return Vec4.of(this.z, this.x, this.y, this.y);

	extern inline function get_zxyz():Vec4
		return Vec4.of(this.z, this.x, this.y, this.z);

	extern inline function get_zxyw():Vec4
		return Vec4.of(this.z, this.x, this.y, this.w);

	extern inline function get_zxzx():Vec4
		return Vec4.of(this.z, this.x, this.z, this.x);

	extern inline function get_zxzy():Vec4
		return Vec4.of(this.z, this.x, this.z, this.y);

	extern inline function get_zxzz():Vec4
		return Vec4.of(this.z, this.x, this.z, this.z);

	extern inline function get_zxzw():Vec4
		return Vec4.of(this.z, this.x, this.z, this.w);

	extern inline function get_zxwx():Vec4
		return Vec4.of(this.z, this.x, this.w, this.x);

	extern inline function get_zxwy():Vec4
		return Vec4.of(this.z, this.x, this.w, this.y);

	extern inline function get_zxwz():Vec4
		return Vec4.of(this.z, this.x, this.w, this.z);

	extern inline function get_zxww():Vec4
		return Vec4.of(this.z, this.x, this.w, this.w);

	extern inline function get_zyxx():Vec4
		return Vec4.of(this.z, this.y, this.x, this.x);

	extern inline function get_zyxy():Vec4
		return Vec4.of(this.z, this.y, this.x, this.y);

	extern inline function get_zyxz():Vec4
		return Vec4.of(this.z, this.y, this.x, this.z);

	extern inline function get_zyxw():Vec4
		return Vec4.of(this.z, this.y, this.x, this.w);

	extern inline function get_zyyx():Vec4
		return Vec4.of(this.z, this.y, this.y, this.x);

	extern inline function get_zyyy():Vec4
		return Vec4.of(this.z, this.y, this.y, this.y);

	extern inline function get_zyyz():Vec4
		return Vec4.of(this.z, this.y, this.y, this.z);

	extern inline function get_zyyw():Vec4
		return Vec4.of(this.z, this.y, this.y, this.w);

	extern inline function get_zyzx():Vec4
		return Vec4.of(this.z, this.y, this.z, this.x);

	extern inline function get_zyzy():Vec4
		return Vec4.of(this.z, this.y, this.z, this.y);

	extern inline function get_zyzz():Vec4
		return Vec4.of(this.z, this.y, this.z, this.z);

	extern inline function get_zyzw():Vec4
		return Vec4.of(this.z, this.y, this.z, this.w);

	extern inline function get_zywx():Vec4
		return Vec4.of(this.z, this.y, this.w, this.x);

	extern inline function get_zywy():Vec4
		return Vec4.of(this.z, this.y, this.w, this.y);

	extern inline function get_zywz():Vec4
		return Vec4.of(this.z, this.y, this.w, this.z);

	extern inline function get_zyww():Vec4
		return Vec4.of(this.z, this.y, this.w, this.w);

	extern inline function get_zzxx():Vec4
		return Vec4.of(this.z, this.z, this.x, this.x);

	extern inline function get_zzxy():Vec4
		return Vec4.of(this.z, this.z, this.x, this.y);

	extern inline function get_zzxz():Vec4
		return Vec4.of(this.z, this.z, this.x, this.z);

	extern inline function get_zzxw():Vec4
		return Vec4.of(this.z, this.z, this.x, this.w);

	extern inline function get_zzyx():Vec4
		return Vec4.of(this.z, this.z, this.y, this.x);

	extern inline function get_zzyy():Vec4
		return Vec4.of(this.z, this.z, this.y, this.y);

	extern inline function get_zzyz():Vec4
		return Vec4.of(this.z, this.z, this.y, this.z);

	extern inline function get_zzyw():Vec4
		return Vec4.of(this.z, this.z, this.y, this.w);

	extern inline function get_zzzx():Vec4
		return Vec4.of(this.z, this.z, this.z, this.x);

	extern inline function get_zzzy():Vec4
		return Vec4.of(this.z, this.z, this.z, this.y);

	extern inline function get_zzzz():Vec4
		return Vec4.of(this.z, this.z, this.z, this.z);

	extern inline function get_zzzw():Vec4
		return Vec4.of(this.z, this.z, this.z, this.w);

	extern inline function get_zzwx():Vec4
		return Vec4.of(this.z, this.z, this.w, this.x);

	extern inline function get_zzwy():Vec4
		return Vec4.of(this.z, this.z, this.w, this.y);

	extern inline function get_zzwz():Vec4
		return Vec4.of(this.z, this.z, this.w, this.z);

	extern inline function get_zzww():Vec4
		return Vec4.of(this.z, this.z, this.w, this.w);

	extern inline function get_zwxx():Vec4
		return Vec4.of(this.z, this.w, this.x, this.x);

	extern inline function get_zwxy():Vec4
		return Vec4.of(this.z, this.w, this.x, this.y);

	extern inline function get_zwxz():Vec4
		return Vec4.of(this.z, this.w, this.x, this.z);

	extern inline function get_zwxw():Vec4
		return Vec4.of(this.z, this.w, this.x, this.w);

	extern inline function get_zwyx():Vec4
		return Vec4.of(this.z, this.w, this.y, this.x);

	extern inline function get_zwyy():Vec4
		return Vec4.of(this.z, this.w, this.y, this.y);

	extern inline function get_zwyz():Vec4
		return Vec4.of(this.z, this.w, this.y, this.z);

	extern inline function get_zwyw():Vec4
		return Vec4.of(this.z, this.w, this.y, this.w);

	extern inline function get_zwzx():Vec4
		return Vec4.of(this.z, this.w, this.z, this.x);

	extern inline function get_zwzy():Vec4
		return Vec4.of(this.z, this.w, this.z, this.y);

	extern inline function get_zwzz():Vec4
		return Vec4.of(this.z, this.w, this.z, this.z);

	extern inline function get_zwzw():Vec4
		return Vec4.of(this.z, this.w, this.z, this.w);

	extern inline function get_zwwx():Vec4
		return Vec4.of(this.z, this.w, this.w, this.x);

	extern inline function get_zwwy():Vec4
		return Vec4.of(this.z, this.w, this.w, this.y);

	extern inline function get_zwwz():Vec4
		return Vec4.of(this.z, this.w, this.w, this.z);

	extern inline function get_zwww():Vec4
		return Vec4.of(this.z, this.w, this.w, this.w);

	extern inline function get_wxxx():Vec4
		return Vec4.of(this.w, this.x, this.x, this.x);

	extern inline function get_wxxy():Vec4
		return Vec4.of(this.w, this.x, this.x, this.y);

	extern inline function get_wxxz():Vec4
		return Vec4.of(this.w, this.x, this.x, this.z);

	extern inline function get_wxxw():Vec4
		return Vec4.of(this.w, this.x, this.x, this.w);

	extern inline function get_wxyx():Vec4
		return Vec4.of(this.w, this.x, this.y, this.x);

	extern inline function get_wxyy():Vec4
		return Vec4.of(this.w, this.x, this.y, this.y);

	extern inline function get_wxyz():Vec4
		return Vec4.of(this.w, this.x, this.y, this.z);

	extern inline function get_wxyw():Vec4
		return Vec4.of(this.w, this.x, this.y, this.w);

	extern inline function get_wxzx():Vec4
		return Vec4.of(this.w, this.x, this.z, this.x);

	extern inline function get_wxzy():Vec4
		return Vec4.of(this.w, this.x, this.z, this.y);

	extern inline function get_wxzz():Vec4
		return Vec4.of(this.w, this.x, this.z, this.z);

	extern inline function get_wxzw():Vec4
		return Vec4.of(this.w, this.x, this.z, this.w);

	extern inline function get_wxwx():Vec4
		return Vec4.of(this.w, this.x, this.w, this.x);

	extern inline function get_wxwy():Vec4
		return Vec4.of(this.w, this.x, this.w, this.y);

	extern inline function get_wxwz():Vec4
		return Vec4.of(this.w, this.x, this.w, this.z);

	extern inline function get_wxww():Vec4
		return Vec4.of(this.w, this.x, this.w, this.w);

	extern inline function get_wyxx():Vec4
		return Vec4.of(this.w, this.y, this.x, this.x);

	extern inline function get_wyxy():Vec4
		return Vec4.of(this.w, this.y, this.x, this.y);

	extern inline function get_wyxz():Vec4
		return Vec4.of(this.w, this.y, this.x, this.z);

	extern inline function get_wyxw():Vec4
		return Vec4.of(this.w, this.y, this.x, this.w);

	extern inline function get_wyyx():Vec4
		return Vec4.of(this.w, this.y, this.y, this.x);

	extern inline function get_wyyy():Vec4
		return Vec4.of(this.w, this.y, this.y, this.y);

	extern inline function get_wyyz():Vec4
		return Vec4.of(this.w, this.y, this.y, this.z);

	extern inline function get_wyyw():Vec4
		return Vec4.of(this.w, this.y, this.y, this.w);

	extern inline function get_wyzx():Vec4
		return Vec4.of(this.w, this.y, this.z, this.x);

	extern inline function get_wyzy():Vec4
		return Vec4.of(this.w, this.y, this.z, this.y);

	extern inline function get_wyzz():Vec4
		return Vec4.of(this.w, this.y, this.z, this.z);

	extern inline function get_wyzw():Vec4
		return Vec4.of(this.w, this.y, this.z, this.w);

	extern inline function get_wywx():Vec4
		return Vec4.of(this.w, this.y, this.w, this.x);

	extern inline function get_wywy():Vec4
		return Vec4.of(this.w, this.y, this.w, this.y);

	extern inline function get_wywz():Vec4
		return Vec4.of(this.w, this.y, this.w, this.z);

	extern inline function get_wyww():Vec4
		return Vec4.of(this.w, this.y, this.w, this.w);

	extern inline function get_wzxx():Vec4
		return Vec4.of(this.w, this.z, this.x, this.x);

	extern inline function get_wzxy():Vec4
		return Vec4.of(this.w, this.z, this.x, this.y);

	extern inline function get_wzxz():Vec4
		return Vec4.of(this.w, this.z, this.x, this.z);

	extern inline function get_wzxw():Vec4
		return Vec4.of(this.w, this.z, this.x, this.w);

	extern inline function get_wzyx():Vec4
		return Vec4.of(this.w, this.z, this.y, this.x);

	extern inline function get_wzyy():Vec4
		return Vec4.of(this.w, this.z, this.y, this.y);

	extern inline function get_wzyz():Vec4
		return Vec4.of(this.w, this.z, this.y, this.z);

	extern inline function get_wzyw():Vec4
		return Vec4.of(this.w, this.z, this.y, this.w);

	extern inline function get_wzzx():Vec4
		return Vec4.of(this.w, this.z, this.z, this.x);

	extern inline function get_wzzy():Vec4
		return Vec4.of(this.w, this.z, this.z, this.y);

	extern inline function get_wzzz():Vec4
		return Vec4.of(this.w, this.z, this.z, this.z);

	extern inline function get_wzzw():Vec4
		return Vec4.of(this.w, this.z, this.z, this.w);

	extern inline function get_wzwx():Vec4
		return Vec4.of(this.w, this.z, this.w, this.x);

	extern inline function get_wzwy():Vec4
		return Vec4.of(this.w, this.z, this.w, this.y);

	extern inline function get_wzwz():Vec4
		return Vec4.of(this.w, this.z, this.w, this.z);

	extern inline function get_wzww():Vec4
		return Vec4.of(this.w, this.z, this.w, this.w);

	extern inline function get_wwxx():Vec4
		return Vec4.of(this.w, this.w, this.x, this.x);

	extern inline function get_wwxy():Vec4
		return Vec4.of(this.w, this.w, this.x, this.y);

	extern inline function get_wwxz():Vec4
		return Vec4.of(this.w, this.w, this.x, this.z);

	extern inline function get_wwxw():Vec4
		return Vec4.of(this.w, this.w, this.x, this.w);

	extern inline function get_wwyx():Vec4
		return Vec4.of(this.w, this.w, this.y, this.x);

	extern inline function get_wwyy():Vec4
		return Vec4.of(this.w, this.w, this.y, this.y);

	extern inline function get_wwyz():Vec4
		return Vec4.of(this.w, this.w, this.y, this.z);

	extern inline function get_wwyw():Vec4
		return Vec4.of(this.w, this.w, this.y, this.w);

	extern inline function get_wwzx():Vec4
		return Vec4.of(this.w, this.w, this.z, this.x);

	extern inline function get_wwzy():Vec4
		return Vec4.of(this.w, this.w, this.z, this.y);

	extern inline function get_wwzz():Vec4
		return Vec4.of(this.w, this.w, this.z, this.z);

	extern inline function get_wwzw():Vec4
		return Vec4.of(this.w, this.w, this.z, this.w);

	extern inline function get_wwwx():Vec4
		return Vec4.of(this.w, this.w, this.w, this.x);

	extern inline function get_wwwy():Vec4
		return Vec4.of(this.w, this.w, this.w, this.y);

	extern inline function get_wwwz():Vec4
		return Vec4.of(this.w, this.w, this.w, this.z);

	extern inline function get_wwww():Vec4
		return Vec4.of(this.w, this.w, this.w, this.w);
}

private class Vec4Data {
	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var w:Float;

	public inline function new(x:Float, y:Float, z:Float, w:Float) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}
}
