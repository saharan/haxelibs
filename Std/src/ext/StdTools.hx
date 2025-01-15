package ext;

extern class StdTools {
	extern public static inline function clear<T>(as:Array<T>):Void {
		as.resize(0);
	}

	extern public static inline function first<T>(as:Array<T>):T {
		Std.assert(as.length > 0);
		return as[0];
	}

	extern public static inline function last<T>(as:Array<T>):T {
		Std.assert(as.length > 0);
		return as[as.length - 1];
	}
	
	extern public static inline function empty<T>(as:Array<T>):Bool {
		return as.length == 0;
	}
}
