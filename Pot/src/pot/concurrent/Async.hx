package pot.concurrent;

import js.lib.Promise;
import js.Syntax;

class Async {
	extern public static inline function await<T>(promise:Promise<T>):T {
		return Syntax.code("await {0}", promise);
	}

	extern public static inline function begin():Void {
		Syntax.code("(async () => {");
	}

	extern public static inline function end():Void {
		Syntax.code("})()");
	}
}
