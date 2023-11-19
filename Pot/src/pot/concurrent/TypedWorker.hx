package pot.concurrent;

import js.Browser;
import js.html.MessageEvent;
import js.html.ScriptElement;
import js.html.Worker;

class TypedWorker<T> {
	final worker:Worker;

	public var handler:(message:T) -> Void = null;

	public function new(source:String = null) {
		if (source == null) {
			final script:ScriptElement = cast Browser.document.currentScript;
			source = script.src;
		}
		worker = new Worker(source);
		worker.onmessage = (event:MessageEvent) -> {
			if (handler != null) {
				handler(cast event.data);
			}
		}
	}

	public function post(message:T):Void {
		worker.postMessage(cast message);
	}
}
