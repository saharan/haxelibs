package pot.concurrent;

import js.html.MessageEvent;
import js.html.DedicatedWorkerGlobalScope;

class TypedWorkerApp<T> {
	final context:DedicatedWorkerGlobalScope;

	public function new() {
		this.context = untyped self;
		context.onmessage = (event:MessageEvent) -> {
			final message = cast event.data;
			received(message);
		}
	}

	function post(message:T):Void {
		context.postMessage(message);
	}

	function received(message:T):Void {
	}
}
