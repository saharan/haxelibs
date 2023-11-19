package pot.concurrent;

import js.lib.Promise;

class Blocker {
	public final value:Promise<Any>;
	public final unblock:() -> Void;

	public function new() {
		var resolveFunc;
		value = new Promise((resolve, reject) -> {
			resolveFunc = resolve;
		});
		unblock = () -> resolveFunc(null);
	}
}
