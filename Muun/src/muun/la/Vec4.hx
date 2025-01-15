package muun.la;

@:forward(x, y, z, w)
abstract Vec4(Vec4Data) from Vec4Data {
	inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = new Vec4Data(x, y, z, w);
	}

	extern public static inline function of(x:Float, y:Float, z:Float, w:Float):Vec4 {
		return new Vec4(x, y, z, w);
	}

	var a(get, never):Vec4;

	extern inline function get_a()
		return this;

	public static var zero(get, never):Vec4;
	public static var one(get, never):Vec4;
	public static var ex(get, never):Vec4;
	public static var ey(get, never):Vec4;
	public static var ez(get, never):Vec4;
	public static var ew(get, never):Vec4;

	extern static inline function get_zero() {
		return of(0, 0, 0, 0);
	}

	extern static inline function get_one() {
		return of(1, 1, 1, 1);
	}

	extern static inline function get_ex() {
		return of(1, 0, 0, 0);
	}

	extern static inline function get_ey() {
		return of(0, 1, 0, 0);
	}

	extern static inline function get_ez() {
		return of(0, 0, 1, 0);
	}

	extern static inline function get_ew() {
		return of(0, 0, 0, 1);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var normalized(get, never):Vec4;
	public var diag(get, never):Mat4;

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
		return Mat4.of(a.x, 0, 0, 0, 0, a.y, 0, 0, 0, 0, a.z, 0, 0, 0, 0, a.w);
	}

	extern public inline function dot(b:Vec4):Float {
		return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
	}

	extern public inline function tensorDot(b:Vec4):Mat4 {
		return Mat4.of(a.x * b.x, a.x * b.y, a.x * b.z, a.x * b.w, a.y * b.x, a.y * b.y, a.y * b.z, a.y * b.w,
			a.z * b.x, a.z * b.y, a.z * b.z, a.z * b.w, a.w * b.x, a.w * b.y, a.w * b.z, a.w * b.w);
	}

	extern public inline function toQuat():Quat {
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
		return unary(a, x -> x < 0 ? -x : x);
	}

	extern public inline function min(b:Vec4):Vec4 {
		return binary(a, b, (x, y) -> x < y ? x : y);
	}

	extern public inline function max(b:Vec4):Vec4 {
		return binary(a, b, (x, y) -> x > y ? x : y);
	}

	extern public inline function clamp(min:Vec4, max:Vec4):Vec4 {
		return ternary(a, min, max, (x, min, max) -> x < min ? min : x > max ? max : x);
	}

	@:op(-A)
	extern static inline function neg(a:Vec4):Vec4 {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern static inline function add(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern static inline function sub(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern static inline function mul(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a * b);
	}

	@:op(A / B)
	extern static inline function div(a:Vec4, b:Vec4):Vec4 {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern static inline function subf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern static inline function fsub(a:Float, b:Vec4):Vec4 {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern static inline function divf(a:Vec4, b:Float):Vec4 {
		return unary(a, a -> a / b);
	}

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:Vec4):Vec4 {
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
			case 3:
				a.w;
			case _:
				throw "Vec4 index out of bounds: " + index;
		}
	}

	extern public inline function map(f:(component:Float) -> Float):Vec4 {
		return unary(a, f);
	}

	public function toString():String {
		return 'Vec4(${a.x}, ${a.y}, ${a.z}, ${a.w})';
	}

	// following methods mutate the state

	@:op(A <<= B)
	extern inline function assign(b:Vec4):Vec4 {
		a.x = b.x;
		a.y = b.y;
		a.z = b.z;
		a.w = b.w;
		return a;
	}

	@:op(A += B)
	extern inline function addEq(b:Vec4):Vec4 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subEq(b:Vec4):Vec4 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulEq(b:Vec4):Vec4 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divEq(b:Vec4):Vec4 {
		return a <<= a / b;
	}

	@:op(A += B)
	extern inline function addfEq(b:Float):Vec4 {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern inline function subfEq(b:Float):Vec4 {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern inline function mulfEq(b:Float):Vec4 {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern inline function divfEq(b:Float):Vec4 {
		return a <<= a / b;
	}

	extern public inline function set(x:Float, y:Float, z:Float, w:Float):Vec4 {
		return a <<= of(x, y, z, w);
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

	extern inline function get_xx()
		return Vec2.of(a.x, a.x);

	extern inline function get_xy()
		return Vec2.of(a.x, a.y);

	extern inline function get_xz()
		return Vec2.of(a.x, a.z);

	extern inline function get_xw()
		return Vec2.of(a.x, a.w);

	extern inline function get_yx()
		return Vec2.of(a.y, a.x);

	extern inline function get_yy()
		return Vec2.of(a.y, a.y);

	extern inline function get_yz()
		return Vec2.of(a.y, a.z);

	extern inline function get_yw()
		return Vec2.of(a.y, a.w);

	extern inline function get_zx()
		return Vec2.of(a.z, a.x);

	extern inline function get_zy()
		return Vec2.of(a.z, a.y);

	extern inline function get_zz()
		return Vec2.of(a.z, a.z);

	extern inline function get_zw()
		return Vec2.of(a.z, a.w);

	extern inline function get_wx()
		return Vec2.of(a.w, a.x);

	extern inline function get_wy()
		return Vec2.of(a.w, a.y);

	extern inline function get_wz()
		return Vec2.of(a.w, a.z);

	extern inline function get_ww()
		return Vec2.of(a.w, a.w);

	extern inline function get_xxx()
		return Vec3.of(a.x, a.x, a.x);

	extern inline function get_xxy()
		return Vec3.of(a.x, a.x, a.y);

	extern inline function get_xxz()
		return Vec3.of(a.x, a.x, a.z);

	extern inline function get_xxw()
		return Vec3.of(a.x, a.x, a.w);

	extern inline function get_xyx()
		return Vec3.of(a.x, a.y, a.x);

	extern inline function get_xyy()
		return Vec3.of(a.x, a.y, a.y);

	extern inline function get_xyz()
		return Vec3.of(a.x, a.y, a.z);

	extern inline function get_xyw()
		return Vec3.of(a.x, a.y, a.w);

	extern inline function get_xzx()
		return Vec3.of(a.x, a.z, a.x);

	extern inline function get_xzy()
		return Vec3.of(a.x, a.z, a.y);

	extern inline function get_xzz()
		return Vec3.of(a.x, a.z, a.z);

	extern inline function get_xzw()
		return Vec3.of(a.x, a.z, a.w);

	extern inline function get_xwx()
		return Vec3.of(a.x, a.w, a.x);

	extern inline function get_xwy()
		return Vec3.of(a.x, a.w, a.y);

	extern inline function get_xwz()
		return Vec3.of(a.x, a.w, a.z);

	extern inline function get_xww()
		return Vec3.of(a.x, a.w, a.w);

	extern inline function get_yxx()
		return Vec3.of(a.y, a.x, a.x);

	extern inline function get_yxy()
		return Vec3.of(a.y, a.x, a.y);

	extern inline function get_yxz()
		return Vec3.of(a.y, a.x, a.z);

	extern inline function get_yxw()
		return Vec3.of(a.y, a.x, a.w);

	extern inline function get_yyx()
		return Vec3.of(a.y, a.y, a.x);

	extern inline function get_yyy()
		return Vec3.of(a.y, a.y, a.y);

	extern inline function get_yyz()
		return Vec3.of(a.y, a.y, a.z);

	extern inline function get_yyw()
		return Vec3.of(a.y, a.y, a.w);

	extern inline function get_yzx()
		return Vec3.of(a.y, a.z, a.x);

	extern inline function get_yzy()
		return Vec3.of(a.y, a.z, a.y);

	extern inline function get_yzz()
		return Vec3.of(a.y, a.z, a.z);

	extern inline function get_yzw()
		return Vec3.of(a.y, a.z, a.w);

	extern inline function get_ywx()
		return Vec3.of(a.y, a.w, a.x);

	extern inline function get_ywy()
		return Vec3.of(a.y, a.w, a.y);

	extern inline function get_ywz()
		return Vec3.of(a.y, a.w, a.z);

	extern inline function get_yww()
		return Vec3.of(a.y, a.w, a.w);

	extern inline function get_zxx()
		return Vec3.of(a.z, a.x, a.x);

	extern inline function get_zxy()
		return Vec3.of(a.z, a.x, a.y);

	extern inline function get_zxz()
		return Vec3.of(a.z, a.x, a.z);

	extern inline function get_zxw()
		return Vec3.of(a.z, a.x, a.w);

	extern inline function get_zyx()
		return Vec3.of(a.z, a.y, a.x);

	extern inline function get_zyy()
		return Vec3.of(a.z, a.y, a.y);

	extern inline function get_zyz()
		return Vec3.of(a.z, a.y, a.z);

	extern inline function get_zyw()
		return Vec3.of(a.z, a.y, a.w);

	extern inline function get_zzx()
		return Vec3.of(a.z, a.z, a.x);

	extern inline function get_zzy()
		return Vec3.of(a.z, a.z, a.y);

	extern inline function get_zzz()
		return Vec3.of(a.z, a.z, a.z);

	extern inline function get_zzw()
		return Vec3.of(a.z, a.z, a.w);

	extern inline function get_zwx()
		return Vec3.of(a.z, a.w, a.x);

	extern inline function get_zwy()
		return Vec3.of(a.z, a.w, a.y);

	extern inline function get_zwz()
		return Vec3.of(a.z, a.w, a.z);

	extern inline function get_zww()
		return Vec3.of(a.z, a.w, a.w);

	extern inline function get_wxx()
		return Vec3.of(a.w, a.x, a.x);

	extern inline function get_wxy()
		return Vec3.of(a.w, a.x, a.y);

	extern inline function get_wxz()
		return Vec3.of(a.w, a.x, a.z);

	extern inline function get_wxw()
		return Vec3.of(a.w, a.x, a.w);

	extern inline function get_wyx()
		return Vec3.of(a.w, a.y, a.x);

	extern inline function get_wyy()
		return Vec3.of(a.w, a.y, a.y);

	extern inline function get_wyz()
		return Vec3.of(a.w, a.y, a.z);

	extern inline function get_wyw()
		return Vec3.of(a.w, a.y, a.w);

	extern inline function get_wzx()
		return Vec3.of(a.w, a.z, a.x);

	extern inline function get_wzy()
		return Vec3.of(a.w, a.z, a.y);

	extern inline function get_wzz()
		return Vec3.of(a.w, a.z, a.z);

	extern inline function get_wzw()
		return Vec3.of(a.w, a.z, a.w);

	extern inline function get_wwx()
		return Vec3.of(a.w, a.w, a.x);

	extern inline function get_wwy()
		return Vec3.of(a.w, a.w, a.y);

	extern inline function get_wwz()
		return Vec3.of(a.w, a.w, a.z);

	extern inline function get_www()
		return Vec3.of(a.w, a.w, a.w);

	extern inline function get_xxxx()
		return Vec4.of(a.x, a.x, a.x, a.x);

	extern inline function get_xxxy()
		return Vec4.of(a.x, a.x, a.x, a.y);

	extern inline function get_xxxz()
		return Vec4.of(a.x, a.x, a.x, a.z);

	extern inline function get_xxxw()
		return Vec4.of(a.x, a.x, a.x, a.w);

	extern inline function get_xxyx()
		return Vec4.of(a.x, a.x, a.y, a.x);

	extern inline function get_xxyy()
		return Vec4.of(a.x, a.x, a.y, a.y);

	extern inline function get_xxyz()
		return Vec4.of(a.x, a.x, a.y, a.z);

	extern inline function get_xxyw()
		return Vec4.of(a.x, a.x, a.y, a.w);

	extern inline function get_xxzx()
		return Vec4.of(a.x, a.x, a.z, a.x);

	extern inline function get_xxzy()
		return Vec4.of(a.x, a.x, a.z, a.y);

	extern inline function get_xxzz()
		return Vec4.of(a.x, a.x, a.z, a.z);

	extern inline function get_xxzw()
		return Vec4.of(a.x, a.x, a.z, a.w);

	extern inline function get_xxwx()
		return Vec4.of(a.x, a.x, a.w, a.x);

	extern inline function get_xxwy()
		return Vec4.of(a.x, a.x, a.w, a.y);

	extern inline function get_xxwz()
		return Vec4.of(a.x, a.x, a.w, a.z);

	extern inline function get_xxww()
		return Vec4.of(a.x, a.x, a.w, a.w);

	extern inline function get_xyxx()
		return Vec4.of(a.x, a.y, a.x, a.x);

	extern inline function get_xyxy()
		return Vec4.of(a.x, a.y, a.x, a.y);

	extern inline function get_xyxz()
		return Vec4.of(a.x, a.y, a.x, a.z);

	extern inline function get_xyxw()
		return Vec4.of(a.x, a.y, a.x, a.w);

	extern inline function get_xyyx()
		return Vec4.of(a.x, a.y, a.y, a.x);

	extern inline function get_xyyy()
		return Vec4.of(a.x, a.y, a.y, a.y);

	extern inline function get_xyyz()
		return Vec4.of(a.x, a.y, a.y, a.z);

	extern inline function get_xyyw()
		return Vec4.of(a.x, a.y, a.y, a.w);

	extern inline function get_xyzx()
		return Vec4.of(a.x, a.y, a.z, a.x);

	extern inline function get_xyzy()
		return Vec4.of(a.x, a.y, a.z, a.y);

	extern inline function get_xyzz()
		return Vec4.of(a.x, a.y, a.z, a.z);

	extern inline function get_xyzw()
		return Vec4.of(a.x, a.y, a.z, a.w);

	extern inline function get_xywx()
		return Vec4.of(a.x, a.y, a.w, a.x);

	extern inline function get_xywy()
		return Vec4.of(a.x, a.y, a.w, a.y);

	extern inline function get_xywz()
		return Vec4.of(a.x, a.y, a.w, a.z);

	extern inline function get_xyww()
		return Vec4.of(a.x, a.y, a.w, a.w);

	extern inline function get_xzxx()
		return Vec4.of(a.x, a.z, a.x, a.x);

	extern inline function get_xzxy()
		return Vec4.of(a.x, a.z, a.x, a.y);

	extern inline function get_xzxz()
		return Vec4.of(a.x, a.z, a.x, a.z);

	extern inline function get_xzxw()
		return Vec4.of(a.x, a.z, a.x, a.w);

	extern inline function get_xzyx()
		return Vec4.of(a.x, a.z, a.y, a.x);

	extern inline function get_xzyy()
		return Vec4.of(a.x, a.z, a.y, a.y);

	extern inline function get_xzyz()
		return Vec4.of(a.x, a.z, a.y, a.z);

	extern inline function get_xzyw()
		return Vec4.of(a.x, a.z, a.y, a.w);

	extern inline function get_xzzx()
		return Vec4.of(a.x, a.z, a.z, a.x);

	extern inline function get_xzzy()
		return Vec4.of(a.x, a.z, a.z, a.y);

	extern inline function get_xzzz()
		return Vec4.of(a.x, a.z, a.z, a.z);

	extern inline function get_xzzw()
		return Vec4.of(a.x, a.z, a.z, a.w);

	extern inline function get_xzwx()
		return Vec4.of(a.x, a.z, a.w, a.x);

	extern inline function get_xzwy()
		return Vec4.of(a.x, a.z, a.w, a.y);

	extern inline function get_xzwz()
		return Vec4.of(a.x, a.z, a.w, a.z);

	extern inline function get_xzww()
		return Vec4.of(a.x, a.z, a.w, a.w);

	extern inline function get_xwxx()
		return Vec4.of(a.x, a.w, a.x, a.x);

	extern inline function get_xwxy()
		return Vec4.of(a.x, a.w, a.x, a.y);

	extern inline function get_xwxz()
		return Vec4.of(a.x, a.w, a.x, a.z);

	extern inline function get_xwxw()
		return Vec4.of(a.x, a.w, a.x, a.w);

	extern inline function get_xwyx()
		return Vec4.of(a.x, a.w, a.y, a.x);

	extern inline function get_xwyy()
		return Vec4.of(a.x, a.w, a.y, a.y);

	extern inline function get_xwyz()
		return Vec4.of(a.x, a.w, a.y, a.z);

	extern inline function get_xwyw()
		return Vec4.of(a.x, a.w, a.y, a.w);

	extern inline function get_xwzx()
		return Vec4.of(a.x, a.w, a.z, a.x);

	extern inline function get_xwzy()
		return Vec4.of(a.x, a.w, a.z, a.y);

	extern inline function get_xwzz()
		return Vec4.of(a.x, a.w, a.z, a.z);

	extern inline function get_xwzw()
		return Vec4.of(a.x, a.w, a.z, a.w);

	extern inline function get_xwwx()
		return Vec4.of(a.x, a.w, a.w, a.x);

	extern inline function get_xwwy()
		return Vec4.of(a.x, a.w, a.w, a.y);

	extern inline function get_xwwz()
		return Vec4.of(a.x, a.w, a.w, a.z);

	extern inline function get_xwww()
		return Vec4.of(a.x, a.w, a.w, a.w);

	extern inline function get_yxxx()
		return Vec4.of(a.y, a.x, a.x, a.x);

	extern inline function get_yxxy()
		return Vec4.of(a.y, a.x, a.x, a.y);

	extern inline function get_yxxz()
		return Vec4.of(a.y, a.x, a.x, a.z);

	extern inline function get_yxxw()
		return Vec4.of(a.y, a.x, a.x, a.w);

	extern inline function get_yxyx()
		return Vec4.of(a.y, a.x, a.y, a.x);

	extern inline function get_yxyy()
		return Vec4.of(a.y, a.x, a.y, a.y);

	extern inline function get_yxyz()
		return Vec4.of(a.y, a.x, a.y, a.z);

	extern inline function get_yxyw()
		return Vec4.of(a.y, a.x, a.y, a.w);

	extern inline function get_yxzx()
		return Vec4.of(a.y, a.x, a.z, a.x);

	extern inline function get_yxzy()
		return Vec4.of(a.y, a.x, a.z, a.y);

	extern inline function get_yxzz()
		return Vec4.of(a.y, a.x, a.z, a.z);

	extern inline function get_yxzw()
		return Vec4.of(a.y, a.x, a.z, a.w);

	extern inline function get_yxwx()
		return Vec4.of(a.y, a.x, a.w, a.x);

	extern inline function get_yxwy()
		return Vec4.of(a.y, a.x, a.w, a.y);

	extern inline function get_yxwz()
		return Vec4.of(a.y, a.x, a.w, a.z);

	extern inline function get_yxww()
		return Vec4.of(a.y, a.x, a.w, a.w);

	extern inline function get_yyxx()
		return Vec4.of(a.y, a.y, a.x, a.x);

	extern inline function get_yyxy()
		return Vec4.of(a.y, a.y, a.x, a.y);

	extern inline function get_yyxz()
		return Vec4.of(a.y, a.y, a.x, a.z);

	extern inline function get_yyxw()
		return Vec4.of(a.y, a.y, a.x, a.w);

	extern inline function get_yyyx()
		return Vec4.of(a.y, a.y, a.y, a.x);

	extern inline function get_yyyy()
		return Vec4.of(a.y, a.y, a.y, a.y);

	extern inline function get_yyyz()
		return Vec4.of(a.y, a.y, a.y, a.z);

	extern inline function get_yyyw()
		return Vec4.of(a.y, a.y, a.y, a.w);

	extern inline function get_yyzx()
		return Vec4.of(a.y, a.y, a.z, a.x);

	extern inline function get_yyzy()
		return Vec4.of(a.y, a.y, a.z, a.y);

	extern inline function get_yyzz()
		return Vec4.of(a.y, a.y, a.z, a.z);

	extern inline function get_yyzw()
		return Vec4.of(a.y, a.y, a.z, a.w);

	extern inline function get_yywx()
		return Vec4.of(a.y, a.y, a.w, a.x);

	extern inline function get_yywy()
		return Vec4.of(a.y, a.y, a.w, a.y);

	extern inline function get_yywz()
		return Vec4.of(a.y, a.y, a.w, a.z);

	extern inline function get_yyww()
		return Vec4.of(a.y, a.y, a.w, a.w);

	extern inline function get_yzxx()
		return Vec4.of(a.y, a.z, a.x, a.x);

	extern inline function get_yzxy()
		return Vec4.of(a.y, a.z, a.x, a.y);

	extern inline function get_yzxz()
		return Vec4.of(a.y, a.z, a.x, a.z);

	extern inline function get_yzxw()
		return Vec4.of(a.y, a.z, a.x, a.w);

	extern inline function get_yzyx()
		return Vec4.of(a.y, a.z, a.y, a.x);

	extern inline function get_yzyy()
		return Vec4.of(a.y, a.z, a.y, a.y);

	extern inline function get_yzyz()
		return Vec4.of(a.y, a.z, a.y, a.z);

	extern inline function get_yzyw()
		return Vec4.of(a.y, a.z, a.y, a.w);

	extern inline function get_yzzx()
		return Vec4.of(a.y, a.z, a.z, a.x);

	extern inline function get_yzzy()
		return Vec4.of(a.y, a.z, a.z, a.y);

	extern inline function get_yzzz()
		return Vec4.of(a.y, a.z, a.z, a.z);

	extern inline function get_yzzw()
		return Vec4.of(a.y, a.z, a.z, a.w);

	extern inline function get_yzwx()
		return Vec4.of(a.y, a.z, a.w, a.x);

	extern inline function get_yzwy()
		return Vec4.of(a.y, a.z, a.w, a.y);

	extern inline function get_yzwz()
		return Vec4.of(a.y, a.z, a.w, a.z);

	extern inline function get_yzww()
		return Vec4.of(a.y, a.z, a.w, a.w);

	extern inline function get_ywxx()
		return Vec4.of(a.y, a.w, a.x, a.x);

	extern inline function get_ywxy()
		return Vec4.of(a.y, a.w, a.x, a.y);

	extern inline function get_ywxz()
		return Vec4.of(a.y, a.w, a.x, a.z);

	extern inline function get_ywxw()
		return Vec4.of(a.y, a.w, a.x, a.w);

	extern inline function get_ywyx()
		return Vec4.of(a.y, a.w, a.y, a.x);

	extern inline function get_ywyy()
		return Vec4.of(a.y, a.w, a.y, a.y);

	extern inline function get_ywyz()
		return Vec4.of(a.y, a.w, a.y, a.z);

	extern inline function get_ywyw()
		return Vec4.of(a.y, a.w, a.y, a.w);

	extern inline function get_ywzx()
		return Vec4.of(a.y, a.w, a.z, a.x);

	extern inline function get_ywzy()
		return Vec4.of(a.y, a.w, a.z, a.y);

	extern inline function get_ywzz()
		return Vec4.of(a.y, a.w, a.z, a.z);

	extern inline function get_ywzw()
		return Vec4.of(a.y, a.w, a.z, a.w);

	extern inline function get_ywwx()
		return Vec4.of(a.y, a.w, a.w, a.x);

	extern inline function get_ywwy()
		return Vec4.of(a.y, a.w, a.w, a.y);

	extern inline function get_ywwz()
		return Vec4.of(a.y, a.w, a.w, a.z);

	extern inline function get_ywww()
		return Vec4.of(a.y, a.w, a.w, a.w);

	extern inline function get_zxxx()
		return Vec4.of(a.z, a.x, a.x, a.x);

	extern inline function get_zxxy()
		return Vec4.of(a.z, a.x, a.x, a.y);

	extern inline function get_zxxz()
		return Vec4.of(a.z, a.x, a.x, a.z);

	extern inline function get_zxxw()
		return Vec4.of(a.z, a.x, a.x, a.w);

	extern inline function get_zxyx()
		return Vec4.of(a.z, a.x, a.y, a.x);

	extern inline function get_zxyy()
		return Vec4.of(a.z, a.x, a.y, a.y);

	extern inline function get_zxyz()
		return Vec4.of(a.z, a.x, a.y, a.z);

	extern inline function get_zxyw()
		return Vec4.of(a.z, a.x, a.y, a.w);

	extern inline function get_zxzx()
		return Vec4.of(a.z, a.x, a.z, a.x);

	extern inline function get_zxzy()
		return Vec4.of(a.z, a.x, a.z, a.y);

	extern inline function get_zxzz()
		return Vec4.of(a.z, a.x, a.z, a.z);

	extern inline function get_zxzw()
		return Vec4.of(a.z, a.x, a.z, a.w);

	extern inline function get_zxwx()
		return Vec4.of(a.z, a.x, a.w, a.x);

	extern inline function get_zxwy()
		return Vec4.of(a.z, a.x, a.w, a.y);

	extern inline function get_zxwz()
		return Vec4.of(a.z, a.x, a.w, a.z);

	extern inline function get_zxww()
		return Vec4.of(a.z, a.x, a.w, a.w);

	extern inline function get_zyxx()
		return Vec4.of(a.z, a.y, a.x, a.x);

	extern inline function get_zyxy()
		return Vec4.of(a.z, a.y, a.x, a.y);

	extern inline function get_zyxz()
		return Vec4.of(a.z, a.y, a.x, a.z);

	extern inline function get_zyxw()
		return Vec4.of(a.z, a.y, a.x, a.w);

	extern inline function get_zyyx()
		return Vec4.of(a.z, a.y, a.y, a.x);

	extern inline function get_zyyy()
		return Vec4.of(a.z, a.y, a.y, a.y);

	extern inline function get_zyyz()
		return Vec4.of(a.z, a.y, a.y, a.z);

	extern inline function get_zyyw()
		return Vec4.of(a.z, a.y, a.y, a.w);

	extern inline function get_zyzx()
		return Vec4.of(a.z, a.y, a.z, a.x);

	extern inline function get_zyzy()
		return Vec4.of(a.z, a.y, a.z, a.y);

	extern inline function get_zyzz()
		return Vec4.of(a.z, a.y, a.z, a.z);

	extern inline function get_zyzw()
		return Vec4.of(a.z, a.y, a.z, a.w);

	extern inline function get_zywx()
		return Vec4.of(a.z, a.y, a.w, a.x);

	extern inline function get_zywy()
		return Vec4.of(a.z, a.y, a.w, a.y);

	extern inline function get_zywz()
		return Vec4.of(a.z, a.y, a.w, a.z);

	extern inline function get_zyww()
		return Vec4.of(a.z, a.y, a.w, a.w);

	extern inline function get_zzxx()
		return Vec4.of(a.z, a.z, a.x, a.x);

	extern inline function get_zzxy()
		return Vec4.of(a.z, a.z, a.x, a.y);

	extern inline function get_zzxz()
		return Vec4.of(a.z, a.z, a.x, a.z);

	extern inline function get_zzxw()
		return Vec4.of(a.z, a.z, a.x, a.w);

	extern inline function get_zzyx()
		return Vec4.of(a.z, a.z, a.y, a.x);

	extern inline function get_zzyy()
		return Vec4.of(a.z, a.z, a.y, a.y);

	extern inline function get_zzyz()
		return Vec4.of(a.z, a.z, a.y, a.z);

	extern inline function get_zzyw()
		return Vec4.of(a.z, a.z, a.y, a.w);

	extern inline function get_zzzx()
		return Vec4.of(a.z, a.z, a.z, a.x);

	extern inline function get_zzzy()
		return Vec4.of(a.z, a.z, a.z, a.y);

	extern inline function get_zzzz()
		return Vec4.of(a.z, a.z, a.z, a.z);

	extern inline function get_zzzw()
		return Vec4.of(a.z, a.z, a.z, a.w);

	extern inline function get_zzwx()
		return Vec4.of(a.z, a.z, a.w, a.x);

	extern inline function get_zzwy()
		return Vec4.of(a.z, a.z, a.w, a.y);

	extern inline function get_zzwz()
		return Vec4.of(a.z, a.z, a.w, a.z);

	extern inline function get_zzww()
		return Vec4.of(a.z, a.z, a.w, a.w);

	extern inline function get_zwxx()
		return Vec4.of(a.z, a.w, a.x, a.x);

	extern inline function get_zwxy()
		return Vec4.of(a.z, a.w, a.x, a.y);

	extern inline function get_zwxz()
		return Vec4.of(a.z, a.w, a.x, a.z);

	extern inline function get_zwxw()
		return Vec4.of(a.z, a.w, a.x, a.w);

	extern inline function get_zwyx()
		return Vec4.of(a.z, a.w, a.y, a.x);

	extern inline function get_zwyy()
		return Vec4.of(a.z, a.w, a.y, a.y);

	extern inline function get_zwyz()
		return Vec4.of(a.z, a.w, a.y, a.z);

	extern inline function get_zwyw()
		return Vec4.of(a.z, a.w, a.y, a.w);

	extern inline function get_zwzx()
		return Vec4.of(a.z, a.w, a.z, a.x);

	extern inline function get_zwzy()
		return Vec4.of(a.z, a.w, a.z, a.y);

	extern inline function get_zwzz()
		return Vec4.of(a.z, a.w, a.z, a.z);

	extern inline function get_zwzw()
		return Vec4.of(a.z, a.w, a.z, a.w);

	extern inline function get_zwwx()
		return Vec4.of(a.z, a.w, a.w, a.x);

	extern inline function get_zwwy()
		return Vec4.of(a.z, a.w, a.w, a.y);

	extern inline function get_zwwz()
		return Vec4.of(a.z, a.w, a.w, a.z);

	extern inline function get_zwww()
		return Vec4.of(a.z, a.w, a.w, a.w);

	extern inline function get_wxxx()
		return Vec4.of(a.w, a.x, a.x, a.x);

	extern inline function get_wxxy()
		return Vec4.of(a.w, a.x, a.x, a.y);

	extern inline function get_wxxz()
		return Vec4.of(a.w, a.x, a.x, a.z);

	extern inline function get_wxxw()
		return Vec4.of(a.w, a.x, a.x, a.w);

	extern inline function get_wxyx()
		return Vec4.of(a.w, a.x, a.y, a.x);

	extern inline function get_wxyy()
		return Vec4.of(a.w, a.x, a.y, a.y);

	extern inline function get_wxyz()
		return Vec4.of(a.w, a.x, a.y, a.z);

	extern inline function get_wxyw()
		return Vec4.of(a.w, a.x, a.y, a.w);

	extern inline function get_wxzx()
		return Vec4.of(a.w, a.x, a.z, a.x);

	extern inline function get_wxzy()
		return Vec4.of(a.w, a.x, a.z, a.y);

	extern inline function get_wxzz()
		return Vec4.of(a.w, a.x, a.z, a.z);

	extern inline function get_wxzw()
		return Vec4.of(a.w, a.x, a.z, a.w);

	extern inline function get_wxwx()
		return Vec4.of(a.w, a.x, a.w, a.x);

	extern inline function get_wxwy()
		return Vec4.of(a.w, a.x, a.w, a.y);

	extern inline function get_wxwz()
		return Vec4.of(a.w, a.x, a.w, a.z);

	extern inline function get_wxww()
		return Vec4.of(a.w, a.x, a.w, a.w);

	extern inline function get_wyxx()
		return Vec4.of(a.w, a.y, a.x, a.x);

	extern inline function get_wyxy()
		return Vec4.of(a.w, a.y, a.x, a.y);

	extern inline function get_wyxz()
		return Vec4.of(a.w, a.y, a.x, a.z);

	extern inline function get_wyxw()
		return Vec4.of(a.w, a.y, a.x, a.w);

	extern inline function get_wyyx()
		return Vec4.of(a.w, a.y, a.y, a.x);

	extern inline function get_wyyy()
		return Vec4.of(a.w, a.y, a.y, a.y);

	extern inline function get_wyyz()
		return Vec4.of(a.w, a.y, a.y, a.z);

	extern inline function get_wyyw()
		return Vec4.of(a.w, a.y, a.y, a.w);

	extern inline function get_wyzx()
		return Vec4.of(a.w, a.y, a.z, a.x);

	extern inline function get_wyzy()
		return Vec4.of(a.w, a.y, a.z, a.y);

	extern inline function get_wyzz()
		return Vec4.of(a.w, a.y, a.z, a.z);

	extern inline function get_wyzw()
		return Vec4.of(a.w, a.y, a.z, a.w);

	extern inline function get_wywx()
		return Vec4.of(a.w, a.y, a.w, a.x);

	extern inline function get_wywy()
		return Vec4.of(a.w, a.y, a.w, a.y);

	extern inline function get_wywz()
		return Vec4.of(a.w, a.y, a.w, a.z);

	extern inline function get_wyww()
		return Vec4.of(a.w, a.y, a.w, a.w);

	extern inline function get_wzxx()
		return Vec4.of(a.w, a.z, a.x, a.x);

	extern inline function get_wzxy()
		return Vec4.of(a.w, a.z, a.x, a.y);

	extern inline function get_wzxz()
		return Vec4.of(a.w, a.z, a.x, a.z);

	extern inline function get_wzxw()
		return Vec4.of(a.w, a.z, a.x, a.w);

	extern inline function get_wzyx()
		return Vec4.of(a.w, a.z, a.y, a.x);

	extern inline function get_wzyy()
		return Vec4.of(a.w, a.z, a.y, a.y);

	extern inline function get_wzyz()
		return Vec4.of(a.w, a.z, a.y, a.z);

	extern inline function get_wzyw()
		return Vec4.of(a.w, a.z, a.y, a.w);

	extern inline function get_wzzx()
		return Vec4.of(a.w, a.z, a.z, a.x);

	extern inline function get_wzzy()
		return Vec4.of(a.w, a.z, a.z, a.y);

	extern inline function get_wzzz()
		return Vec4.of(a.w, a.z, a.z, a.z);

	extern inline function get_wzzw()
		return Vec4.of(a.w, a.z, a.z, a.w);

	extern inline function get_wzwx()
		return Vec4.of(a.w, a.z, a.w, a.x);

	extern inline function get_wzwy()
		return Vec4.of(a.w, a.z, a.w, a.y);

	extern inline function get_wzwz()
		return Vec4.of(a.w, a.z, a.w, a.z);

	extern inline function get_wzww()
		return Vec4.of(a.w, a.z, a.w, a.w);

	extern inline function get_wwxx()
		return Vec4.of(a.w, a.w, a.x, a.x);

	extern inline function get_wwxy()
		return Vec4.of(a.w, a.w, a.x, a.y);

	extern inline function get_wwxz()
		return Vec4.of(a.w, a.w, a.x, a.z);

	extern inline function get_wwxw()
		return Vec4.of(a.w, a.w, a.x, a.w);

	extern inline function get_wwyx()
		return Vec4.of(a.w, a.w, a.y, a.x);

	extern inline function get_wwyy()
		return Vec4.of(a.w, a.w, a.y, a.y);

	extern inline function get_wwyz()
		return Vec4.of(a.w, a.w, a.y, a.z);

	extern inline function get_wwyw()
		return Vec4.of(a.w, a.w, a.y, a.w);

	extern inline function get_wwzx()
		return Vec4.of(a.w, a.w, a.z, a.x);

	extern inline function get_wwzy()
		return Vec4.of(a.w, a.w, a.z, a.y);

	extern inline function get_wwzz()
		return Vec4.of(a.w, a.w, a.z, a.z);

	extern inline function get_wwzw()
		return Vec4.of(a.w, a.w, a.z, a.w);

	extern inline function get_wwwx()
		return Vec4.of(a.w, a.w, a.w, a.x);

	extern inline function get_wwwy()
		return Vec4.of(a.w, a.w, a.w, a.y);

	extern inline function get_wwwz()
		return Vec4.of(a.w, a.w, a.w, a.z);

	extern inline function get_wwww()
		return Vec4.of(a.w, a.w, a.w, a.w);
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
