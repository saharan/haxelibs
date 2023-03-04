package pot.input;

import js.html.CanvasElement;
import js.html.Element;
import js.html.TouchEvent;
import js.html.TouchList;
import pot.core.Pot;

using pot.input.InputTools;

/**
 * ...
 */
@:allow(pot.input.Input)
abstract Touches(TouchesData) {
	inline function new() {
		this = new TouchesData();
	}

	public var length(get, never):Int;

	inline function get_length():Int {
		return this.touches.length;
	}

	@:arrayAccess
	inline function get(index:Int):Touch {
		return this.touches[index];
	}

	inline function addEvents(canvas:CanvasElement, elem:Element, input:Input, pot:Pot):Void {
		elem.addEventListener("touchstart", (e:TouchEvent) -> {
			if (e.cancelable)
				e.preventDefault();
			var touches = e.changedTouches;
			for (i in 0...touches.length) {
				var rawTouch:js.html.Touch = touches[i];
				var rawId = rawTouch.identifier;
				var touch = this.getByRawId(rawId, true);
				var x = (rawTouch.clientX - elem.clientX()) * canvas.scaleX(input.scalingMode, pot.pixelRatio);
				var y = (rawTouch.clientY - elem.clientY()) * canvas.scaleY(input.scalingMode, pot.pixelRatio);
				touch.begin(x, y);
			}
		}, {passive: false});
		elem.addEventListener("touchmove", (e:TouchEvent) -> {
			if (e.cancelable)
				e.preventDefault();
			var touches = e.changedTouches;
			for (i in 0...touches.length) {
				var rawTouch:js.html.Touch = touches[i];
				var rawId = rawTouch.identifier;
				var touch = this.getByRawId(rawId);
				if (touch != null) {
					var x = (rawTouch.clientX - elem.clientX()) * canvas.scaleX(input.scalingMode, pot.pixelRatio);
					var y = (rawTouch.clientY - elem.clientY()) * canvas.scaleY(input.scalingMode, pot.pixelRatio);
					touch.move(x, y);
				}
			}
		}, {passive: false});
		var end:TouchEvent->Void = (e:TouchEvent) -> {
			if (e.cancelable)
				e.preventDefault();
			var touches = e.changedTouches;
			for (i in 0...touches.length) {
				var rawTouch:js.html.Touch = touches[i];
				var rawId = rawTouch.identifier;
				var touch = this.getByRawId(rawId);
				if (touch != null) {
					var x = (rawTouch.clientX - elem.clientX()) * canvas.scaleX(input.scalingMode, pot.pixelRatio);
					var y = (rawTouch.clientY - elem.clientY()) * canvas.scaleY(input.scalingMode, pot.pixelRatio);
					touch.end(x, y);
				}
			}
		};
		elem.addEventListener("touchend", end);
		elem.addEventListener("touchcancel", end);
	}

	inline function update():Void {
		var i = 0;
		while (i < this.touches.length) {
			var touch = this.touches[i];
			touch.update();
			if (!touch.ptouching && !touch.touching && !touch.ntouching) {
				// outdated
				this.touches.remove(touch);
			} else {
				i++;
			}
		}
	}
}

@:access(pot.input.Touch)
private class TouchesData {
	public final touches:Array<Touch> = [];

	public function new() {
	}

	public function getByRawId(rawId:Int, create:Bool = false):Touch {
		for (t in touches) {
			if (t.rawId == rawId) {
				return t;
			}
		}
		return create ? newTouch(rawId) : null;
	}

	public function newTouch(rawId:Int):Touch {
		var minId = 0;
		while (true) {
			var tmp = minId;
			for (t in touches) {
				if (t.id == minId)
					minId++;
			}
			if (tmp == minId)
				break;
		}
		final touch = new Touch(minId, rawId);
		touches.push(touch);
		return touch;
	}
}
