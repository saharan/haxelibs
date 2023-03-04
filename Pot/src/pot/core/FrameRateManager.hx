package pot.core;

import js.Browser;
import js.lib.Date;

/**
 * An accurate timer for frames
 */
class FrameRateManager {
	static var catchErrors:Bool = false;

	static inline final UPDATE_LOAD_COEFF:Float = 0.75;
	static inline final MAX_UPDATE_COUNT:Int = 4;

	final update:() -> Void;
	final draw:() -> Void;
	var targetInterval:Float = 1000 / 60;
	var prevTime:Float;
	var running:Bool;
	var count:Int = 0;

	public var doNotAdjust:Bool = false;

	public function new(update:() -> Void, draw:() -> Void) {
		this.update = update;
		this.draw = draw;
	}

	public function start():Void {
		if (running)
			return;
		prevTime = now() - targetInterval;
		running = true;
		Browser.window.setTimeout(loop, 0);
	}

	public function stop():Void {
		if (!running)
			return;
		running = false;
	}

	public function setFrameRate(frameRate:Float):Void {
		targetInterval = 1000 / frameRate;
	}

	function loop():Void {
		if (!running)
			return;
		if (doNotAdjust) {
			doFunc(update);
			doFunc(draw);
		} else {
			final currentTime = now();
			var updated = false;
			var updateCount = 0;
			while (currentTime - prevTime > targetInterval * 0.5) {
				updateCount++;
				doFunc(update);
				updated = true;
				prevTime += targetInterval;
				final now = now();
				final updateTime = now - currentTime;
				final maxConsecutiveUpdates = count > 30 ? MAX_UPDATE_COUNT : 1;
				if (updateTime > targetInterval * UPDATE_LOAD_COEFF || updateCount >= maxConsecutiveUpdates) { // overloaded
					if (prevTime < now - targetInterval) { // do not accumulate too much
						prevTime = now - targetInterval;
					}
					break;
				}
			}
			if (updated) {
				doFunc(draw);
			}
		}
		Browser.window.requestAnimationFrame(cast loop);
	}

	extern inline function doFunc(f:() -> Void):Void {
		if (catchErrors) {
			try {
				f();
			} catch (e) {
				Browser.alert(e);
			}
		} else {
			f();
		}
	}

	extern inline function now():Float {
		return Date.now();
	}
}
