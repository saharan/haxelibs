package muun.la;

// immutable version
@:forward(length, lengthSq, normalized, star, diag, dot, tensorDot, cross, abs, min, max, clamp, map, extend, extend,
	copy, xx, xy, yx, yy, xxx, xxy, xyx, xyy, yxx, yxy, yyx, yyy, xxxx, xxxy, xxyx, xxyy, xyxx, xyxy, xyyx, xyyy,
	yxxx, yxxy, yxyx, yxyy, yyxx, yyxy, yyyx, yyyy)
@:access(muun.la.Vec2)
abstract ImVec2(Vec2) from Vec2 to Vec2 {
	@:op(-A)
	extern static inline function neg(a:ImVec2):Vec2
		return Vec2.neg(a);

	@:op(A + B)
	extern static inline function add(a:ImVec2, b:ImVec2):Vec2
		return Vec2.add(a, b);

	@:op(A - B)
	extern static inline function sub(a:ImVec2, b:ImVec2):Vec2
		return Vec2.sub(a, b);

	@:op(A * B)
	extern static inline function mul(a:ImVec2, b:ImVec2):Vec2
		return Vec2.mul(a, b);

	@:op(A / B)
	extern static inline function div(a:ImVec2, b:ImVec2):Vec2
		return Vec2.div(a, b);

	@:op(A + B)
	@:commutative
	extern static inline function addf(a:ImVec2, b:Float):Vec2
		return Vec2.addf(a, b);

	@:op(A - B)
	extern static inline function subf(a:ImVec2, b:Float):Vec2
		return Vec2.subf(a, b);

	@:op(A - B)
	extern static inline function fsub(a:Float, b:ImVec2):Vec2
		return Vec2.fsub(a, b);

	@:op(A * B)
	@:commutative
	extern static inline function mulf(a:ImVec2, b:Float):Vec2
		return Vec2.mulf(a, b);

	@:op(A / B)
	extern static inline function divf(a:ImVec2, b:Float):Vec2
		return Vec2.divf(a, b);

	@:op(A / B)
	extern static inline function fdiv(a:Float, b:ImVec2):Vec2
		return Vec2.fdiv(a, b);

	@:arrayAccess
	function get(index:Int):Float;

	public var x(get, never):Float;
	public var y(get, never):Float;

	extern inline function get_x()
		return this.x;

	extern inline function get_y()
		return this.y;

	public function toString():String
		return 'ImVec2($x, $y)';
}
