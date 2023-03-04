package muun.la;

@:forward(x, y, z, w)
abstract Quat(QuatData) from QuatData {
	extern inline function new(x:Float, y:Float, z:Float, w:Float) {
		this = new QuatData(x, y, z, w);
	}

	extern public static inline function of(x:Float, y:Float, z:Float, w:Float):Quat {
		return new Quat(x, y, z, w);
	}

	public static var zero(get, never):Quat;
	public static var one(get, never):Quat;
	public static var id(get, never):Quat;
	public static var ex(get, never):Quat;
	public static var ey(get, never):Quat;
	public static var ez(get, never):Quat;
	public static var ew(get, never):Quat;

	extern static inline function get_zero():Quat {
		return of(0, 0, 0, 0);
	}

	extern static inline function get_one():Quat {
		return of(1, 1, 1, 1);
	}

	extern static inline function get_id():Quat {
		return of(0, 0, 0, 1);
	}

	extern static inline function get_ex():Quat {
		return of(1, 0, 0, 0);
	}

	extern static inline function get_ey():Quat {
		return of(0, 1, 0, 0);
	}

	extern static inline function get_ez():Quat {
		return of(0, 0, 1, 0);
	}

	extern static inline function get_ew():Quat {
		return of(0, 0, 0, 1);
	}

	extern public static inline function rot(angle:Float, axis:Vec3):Quat {
		final sinHalfAngle = Math.sin(angle * 0.5);
		final cosHalfAngle = Math.cos(angle * 0.5);
		final im = axis * sinHalfAngle;
		return of(im.x, im.y, im.z, cosHalfAngle);
	}

	extern public static inline function arc(v1:Vec3, v2:Vec3):Quat {
		final d = v1.dot(v2);
		final w = Math.sqrt((1 + d) * 0.5);
		final v = if (w == 0) { // PI rot, set a vector perpendicular to v1
			final sq = v1 * v1;
			final perp = Vec3.zero;
			if (sq.x < sq.y) {
				if (sq.x < sq.z)
					perp.x = 1;
				else
					perp.z = 1;
			} else {
				if (sq.y < sq.z)
					perp.y = 1;
				else
					perp.z = 1;
			}
			v1.cross(perp).normalized;
		} else {
			// cos(theta/2) = sqrt((1 + cos(theta)) / 2)
			// sin(theta/2) / sin(theta) = sin(theta/2) / (2 * sin(theta/2) * cos(theta/2))
			//                           = 1 / (2 * cos(theta/2))
			// x^2 + y^2 + z^2 = sin(theta/2)
			v1.cross(v2) * 0.5 / w;
		}
		return of(v.x, v.y, v.z, w);
	}

	public var length(get, never):Float;
	public var lengthSq(get, never):Float;
	public var conj(get, never):Quat;
	public var inv(get, never):Quat;
	public var normalized(get, never):Quat;
	public var vec(get, set):Vec3;

	extern inline function get_length():Float {
		return Math.sqrt(lengthSq);
	}

	extern inline function get_lengthSq():Float {
		return dot(this);
	}

	extern inline function get_conj():Quat {
		final a = this;
		return of(-a.x, -a.y, -a.z, a.w);
	}

	extern inline function get_inv():Quat {
		final a = this;
		var invLen2 = dot(a);
		if (invLen2 > 0)
			invLen2 = 1 / invLen2;
		return of(-a.x, -a.y, -a.z, a.w) * invLen2;
	}

	extern inline function get_normalized():Quat {
		var l = length;
		if (l > 0)
			l = 1 / l;
		return mulf(this, l);
	}

	extern inline function get_vec():Vec3 {
		final a = this;
		return Vec3.of(a.x, a.y, a.z);
	}

	extern inline function set_vec(v:Vec3):Vec3 {
		final a = this;
		a.x = v.x;
		a.y = v.y;
		a.z = v.z;
		return vec;
	}

	extern public inline function dot(b:Quat):Float {
		final a = this;
		return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
	}

	extern public inline function toMat3():Mat3 {
		final a = this;
		final x2 = a.x * 2;
		final y2 = a.y * 2;
		final z2 = a.z * 2;
		final xx = a.x * x2;
		final yy = a.y * y2;
		final zz = a.z * z2;
		final xy = a.x * y2;
		final yz = a.y * z2;
		final xz = a.x * z2;
		final wx = a.w * x2;
		final wy = a.w * y2;
		final wz = a.w * z2;
		return Mat3.of(1 - yy - zz, xy - wz, xz + wy, xy + wz, 1 - xx - zz, yz - wx, xz - wy, yz + wx, 1 - xx - yy);
	}

	extern public inline function toVec4():Vec4 {
		final a = this;
		return Vec4.of(a.x, a.y, a.z, a.w);
	}

	extern static inline function unary(a:Quat, f:(a:Float) -> Float):Quat {
		return of(f(a.x), f(a.y), f(a.z), f(a.w));
	}

	extern static inline function binary(a:Quat, b:Quat, f:(a:Float, b:Float) -> Float):Quat {
		return of(f(a.x, b.x), f(a.y, b.y), f(a.z, b.z), f(a.w, b.w));
	}

	@:op(-A)
	extern public static inline function neg(a:Quat):Quat {
		return unary(a, a -> -a);
	}

	@:op(A + B)
	extern public static inline function add(a:Quat, b:Quat):Quat {
		return binary(a, b, (a, b) -> a + b);
	}

	@:op(A - B)
	extern public static inline function sub(a:Quat, b:Quat):Quat {
		return binary(a, b, (a, b) -> a - b);
	}

	@:op(A * B)
	extern public static inline function mul(a:Quat, b:Quat):Quat {
		return of(a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y, a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x, a.w * b.z +
			a.x * b.y - a.y * b.x + a.z * b.w, a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z);
	}

	@:op(A * B)
	extern public static inline function mulVec(a:Quat, b:Vec3):Vec3 {
		return a.toMat3() * b;
	}

	@:op(A / B)
	extern public static inline function div(a:Quat, b:Quat):Quat {
		return a * b.inv;
	}

	extern public static inline function emul(a:Quat, b:Quat):Quat {
		return binary(a, b, (a, b) -> a * b);
	}

	extern public static inline function ediv(a:Quat, b:Quat):Quat {
		return binary(a, b, (a, b) -> a / b);
	}

	@:op(A + B)
	@:commutative
	extern public static inline function addf(a:Quat, b:Float):Quat {
		return unary(a, a -> a + b);
	}

	@:op(A - B)
	extern public static inline function subf(a:Quat, b:Float):Quat {
		return unary(a, a -> a - b);
	}

	@:op(A - B)
	extern public static inline function fsub(a:Float, b:Quat):Quat {
		return unary(b, b -> a - b);
	}

	@:op(A * B)
	@:commutative
	extern public static inline function mulf(a:Quat, b:Float):Quat {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern public static inline function divf(a:Quat, b:Float):Quat {
		return unary(a, a -> a * b);
	}

	@:op(A / B)
	extern public static inline function fdiv(a:Float, b:Quat):Quat {
		return unary(b, b -> a / b);
	}

	@:op(A << B)
	extern public static inline function assign(a:Quat, b:Quat):Quat {
		a.x = b.x;
		a.y = b.y;
		a.z = b.z;
		a.w = b.w;
		return a;
	}

	@:op(A += B)
	extern public static inline function addEq(a:Quat, b:Quat):Quat {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subEq(a:Quat, b:Quat):Quat {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulEq(a:Quat, b:Quat):Quat {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divEq(a:Quat, b:Quat):Quat {
		return a <<= a / b;
	}

	@:op(A += B)
	extern public static inline function addfEq(a:Quat, b:Float):Quat {
		return a <<= a + b;
	}

	@:op(A -= B)
	extern public static inline function subfEq(a:Quat, b:Float):Quat {
		return a <<= a - b;
	}

	@:op(A *= B)
	extern public static inline function mulfEq(a:Quat, b:Float):Quat {
		return a <<= a * b;
	}

	@:op(A /= B)
	extern public static inline function divfEq(a:Quat, b:Float):Quat {
		return a <<= a / b;
	}

	extern public inline function set(x:Float, y:Float, z:Float, w:Float):Quat {
		return assign(this, of(x, y, z, w));
	}

	extern public inline function copy():Quat {
		final a = this;
		return of(a.x, a.y, a.z, a.w);
	}

	public function toString():String {
		final a = this;
		return 'Quat(${a.x}, ${a.y}, ${a.z}; ${a.w})';
	}
}

private class QuatData {
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
