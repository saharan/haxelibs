package pot.core;

import js.Browser;
import pot.concurrent.Async;
import pot.concurrent.Blocker;

/**
 * An accurate timer for frames
 */
class FrameRateManager {
	static var catchErrors:Bool = false;

	static inline final UPDATE_LOAD_COEFF:Float = 0.75;
	static inline final MAX_UPDATE_COUNT:Int = 4;

	static inline final MIN_UPDATE_TIME:Float = 4;
	static inline final MAX_FRAMERATE_RATIO:Float = 4;

	final update:(substepRatio:Float, callback:() -> Void) -> Void;
	final draw:() -> Void;
	var targetInterval:Float = 1000 / 60;
	var prevTime:Float;
	var lastDrawBegin:Float;
	var estimatedUpdateTime:Float;
	var running:Bool;
	var count:Int = 0;

	public var frameSkipEnabled:Bool = true;
	public var doNotAdjust:Bool = false;

	public function new(update:(substepRatio:Float, callback:() -> Void) -> Void, draw:() -> Void) {
		this.update = update;
		this.draw = draw;
	}

	public function start():Void {
		if (running)
			return;
		prevTime = now() - targetInterval;
		estimatedUpdateTime = targetInterval;
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
		Async.begin();
		if (!running)
			return;
		count++;
		if (doNotAdjust) {
			final blocker = new Blocker();
			doFunc(() -> update(1, blocker.unblock));
			Async.await(blocker.value);
			doFunc(draw);
		} else {
			final currentTime = now();

			final maxDrawBegin = max(lastDrawBegin + targetInterval * MAX_FRAMERATE_RATIO, currentTime +
				MIN_UPDATE_TIME);
			final maxUpdateCount = !frameSkipEnabled || count < 10 ? 1 : max(1,
				Math.round((maxDrawBegin - currentTime) / estimatedUpdateTime));
			final idealUpdateCountFloat = (currentTime - prevTime) / max(targetInterval * 0.01,
				targetInterval - estimatedUpdateTime);
			final idealUpdateCount = idealUpdateCountFloat > 0.2 && idealUpdateCountFloat < 1.8 ? 1 : Math.round(idealUpdateCountFloat);
			final updateCount = min(idealUpdateCount, maxUpdateCount);

			if (updateCount > 0) {
				var p = currentTime;
				var nextLast = false;
				for (i in 0...updateCount) {
					final blocker = new Blocker();
					doFunc(() -> update(nextLast ? 1 : (i + 1) / updateCount, blocker.unblock));
					Async.await(blocker.value);
					final n = now();
					final updateTime = n - p;
					estimatedUpdateTime += (updateTime - estimatedUpdateTime) * 0.5;
					p = n;
					prevTime += targetInterval;
					if (nextLast)
						break;
					if (n > maxDrawBegin)
						nextLast = true;
				}
				prevTime = max(prevTime, p - max(targetInterval * MAX_FRAMERATE_RATIO, MIN_UPDATE_TIME));
				lastDrawBegin = p;
				doFunc(draw);
			}
		}
		Browser.window.requestAnimationFrame(cast loop);
		Async.end();
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
		return Browser.window.performance.now();
	}
}
