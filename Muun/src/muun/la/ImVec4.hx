package muun.la;

// immutable version
@:forward(length, lengthSq, normalized, diag, dot, tensorDot, cross, crossMat, abs, min, max, clamp, map, extend,
	extend, copy, xx, xy, xz, xw, yx, yy, yz, yw, zx, zy, zz, zw, wx, wy, wz, ww, xxx, xxy, xxz, xxw, xyx,
	xyy, xyz, xyw, xzx, xzy, xzz, xzw, xwx, xwy, xwz, xww, yxx, yxy, yxz, yxw, yyx, yyy, yyz, yyw, yzx, yzy, yzz, yzw,
	ywx, ywy, ywz, yww, zxx, zxy, zxz, zxw, zyx, zyy, zyz, zyw, zzx, zzy, zzz, zzw, zwx, zwy, zwz, zww, wxx, wxy, wxz,
	wxw, wyx, wyy, wyz, wyw, wzx, wzy, wzz, wzw, wwx, wwy, wwz, www, xxxx, xxxy, xxxz, xxxw, xxyx, xxyy, xxyz, xxyw,
	xxzx, xxzy, xxzz, xxzw, xxwx, xxwy, xxwz, xxww, xyxx, xyxy, xyxz, xyxw, xyyx, xyyy, xyyz, xyyw, xyzx, xyzy, xyzz,
	xyzw, xywx, xywy, xywz, xyww, xzxx, xzxy, xzxz, xzxw, xzyx, xzyy, xzyz, xzyw, xzzx, xzzy, xzzz, xzzw, xzwx, xzwy,
	xzwz, xzww, xwxx, xwxy, xwxz, xwxw, xwyx, xwyy, xwyz, xwyw, xwzx, xwzy, xwzz, xwzw, xwwx, xwwy, xwwz, xwww, yxxx,
	yxxy, yxxz, yxxw, yxyx, yxyy, yxyz, yxyw, yxzx, yxzy, yxzz, yxzw, yxwx, yxwy, yxwz, yxww, yyxx, yyxy, yyxz, yyxw,
	yyyx, yyyy, yyyz, yyyw, yyzx, yyzy, yyzz, yyzw, yywx, yywy, yywz, yyww, yzxx, yzxy, yzxz, yzxw, yzyx, yzyy, yzyz,
	yzyw, yzzx, yzzy, yzzz, yzzw, yzwx, yzwy, yzwz, yzww, ywxx, ywxy, ywxz, ywxw, ywyx, ywyy, ywyz, ywyw, ywzx, ywzy,
	ywzz, ywzw, ywwx, ywwy, ywwz, ywww, zxxx, zxxy, zxxz, zxxw, zxyx, zxyy, zxyz, zxyw, zxzx, zxzy, zxzz, zxzw, zxwx,
	zxwy, zxwz, zxww, zyxx, zyxy, zyxz, zyxw, zyyx, zyyy, zyyz, zyyw, zyzx, zyzy, zyzz, zyzw, zywx, zywy, zywz, zyww,
	zzxx, zzxy, zzxz, zzxw, zzyx, zzyy, zzyz, zzyw, zzzx, zzzy, zzzz, zzzw, zzwx, zzwy, zzwz, zzww, zwxx, zwxy, zwxz,
	zwxw, zwyx, zwyy, zwyz, zwyw, zwzx, zwzy, zwzz, zwzw, zwwx, zwwy, zwwz, zwww, wxxx, wxxy, wxxz, wxxw, wxyx, wxyy,
	wxyz, wxyw, wxzx, wxzy, wxzz, wxzw, wxwx, wxwy, wxwz, wxww, wyxx, wyxy, wyxz, wyxw, wyyx, wyyy, wyyz, wyyw, wyzx,
	wyzy, wyzz, wyzw, wywx, wywy, wywz, wyww, wzxx, wzxy, wzxz, wzxw, wzyx, wzyy, wzyz, wzyw, wzzx, wzzy, wzzz, wzzw,
	wzwx, wzwy, wzwz, wzww, wwxx, wwxy, wwxz, wwxw, wwyx, wwyy, wwyz, wwyw, wwzx, wwzy, wwzz, wwzw, wwwx, wwwy, wwwz,
	wwww)
@:access(muun.la.Vec4)
abstract ImVec4(Vec4) from Vec4 to Vec4 {
	@:op(-A)
	extern static inline function neg(a:ImVec4):Vec4
		return Vec4.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImVec4, b:ImVec4):Vec4
		return Vec4.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImVec4, b:ImVec4):Vec4
		return Vec4.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImVec4, b:ImVec4):Vec4
		return Vec4.mul(a, b);

	@:op(A / B)
	extern static inline function div(a:ImVec4, b:ImVec4):Vec4
		return Vec4.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImVec4, b:Float):Vec4
		return Vec4.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImVec4, b:Float):Vec4
		return Vec4.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImVec4):Vec4
		return Vec4.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImVec4, b:Float):Vec4
		return Vec4.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImVec4, b:Float):Vec4
		return Vec4.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImVec4):Vec4
		return Vec4.fdiv(a, b);

	@:arrayAccess
	function get(index:Int):Float;

	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;
	public var w(get, never):Float;

	extern inline function get_x()
		return this.x;

	extern inline function get_y()
		return this.y;

	extern inline function get_z()
		return this.z;

	extern inline function get_w()
		return this.w;

	public function toString():String
		return 'ImVec4($x, $y, $z, $w)';
}
