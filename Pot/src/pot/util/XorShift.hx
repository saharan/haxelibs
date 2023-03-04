package pot.util;

/**
 * ...
 */
class XorShift {
	var x:Int = 0;

	public function new(seed:Int = 0) {
		setSeed(seed);
	}

	public function setSeed(seed:Int = 0):Void {
		x = seed == 0 ? Std.random(2147483647) + 1 : seed;
	}

	extern inline function next():Int {
		x = x ^ (x << 13);
		x = x ^ (x >>> 17);
		return (x = x ^ (x << 15)) & 0x7fffffff;
	}

	overload extern public inline function nextInt():Int {
		return next();
	}

	overload extern public inline function nextInt(mod:Int):Int {
		return nextInt() % mod;
	}

	overload extern public inline function nextInt(min:Int, max:Int):Int {
		return min + nextInt(max - min + 1);
	}

	overload extern public inline function nextFloat():Float {
		return nextInt() / 2147483648.0;
	}

	overload extern public inline function nextFloat(max:Float):Float {
		return nextFloat() * max;
	}

	overload extern public inline function nextFloat(min:Float, max:Float):Float {
		return min + nextFloat(max - min);
	}
}
