package pot.util;

@:generic
@:forward(a, b)
abstract Pair<A, B>(PairData<A, B>) {
	function new(a:A, b:B) {
		this = new PairData<A, B>(a, b);
	}

	extern public static inline function of<A, B>(a:A, b:B):Pair<A, B> {
		return new Pair<A, B>(a, b);
	}
}

@:generic
class PairData<A, B> {
	public var a:A;
	public var b:B;

	public function new(a:A, b:B) {
		this.a = a;
		this.b = b;
	}
}
