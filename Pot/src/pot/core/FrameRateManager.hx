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

	static inline final MIN_UPDATE_TIME:Float = 4;
	static inline final MAX_FRAMERATE_RATIO:Float = 4;

	final update:(substepRatio:Float) -> Void;
	final draw:() -> Void;
	var targetInterval:Float = 1000 / 60;
	var prevTime:Float;
	var lastDrawBegin:Float;
	var estimatedUpdateTime:Float;
	var running:Bool;
	var count:Int = 0;

	public var doNotAdjust:Bool = false;

	public function new(update:(substepRatio:Float) -> Void, draw:() -> Void) {
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
		if (!running)
			return;
		count++;
		if (doNotAdjust) {
			doFunc(() -> update(1));
			doFunc(draw);
		} else {
			final currentTime = now();

			final maxDrawBegin = max(lastDrawBegin + targetInterval * MAX_FRAMERATE_RATIO, currentTime + MIN_UPDATE_TIME);
			final maxUpdateCount = count < 10 ? 1 : max(1, Math.round((maxDrawBegin - currentTime) / estimatedUpdateTime));
			final idealUpdateCount = Math.round((currentTime - prevTime) / max(targetInterval * 0.01,
				targetInterval - estimatedUpdateTime));
			final updateCount = min(idealUpdateCount, maxUpdateCount);

			if (updateCount > 0) {
				var p = currentTime;
				var nextLast = false;
				for (i in 0...updateCount) {
					doFunc(() -> update(nextLast ? 1 : (i + 1) / updateCount));
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
				// trace(prevTime + " " + p + " " + (p - prevTime) + " behind " + (maxDrawBegin - p) + " " + maxUpdateCount + " " +
				// 	idealUpdateCount);
				lastDrawBegin = p;
				doFunc(draw);
			}

			// final maxConsecutiveUpdates = count > 10 ? MAX_UPDATE_COUNT : 1;
			// final updateCount = min(MAX_UPDATE_COUNT, Math.round(idealUpdateCount));
			// if (updateCount > 0) {
			// 	for (i in 0...updateCount) {
			// 		doFunc(update);
			// 		prevTime += targetInterval;
			// 	}
			// }

			// while (currentTime - prevTime > targetInterval * 0.5) {
			// 	updateCount++;
			// 	doFunc(update);
			// 	updated = true;
			// 	prevTime += targetInterval;
			// 	final now = now();
			// 	final updateTime = now - currentTime;
			// 	estimatedUpdateTime = max(estimatedUpdateTime * 0.9, updateTime);
			// 	final maxConsecutiveUpdates = count > 30 ? MAX_UPDATE_COUNT : 1;
			// 	if (updateTime > targetInterval * UPDATE_LOAD_COEFF || updateCount >= maxConsecutiveUpdates) { // overloaded
			// 		if (prevTime < now - targetInterval) { // do not accumulate too much
			// 			prevTime = now - targetInterval;
			// 		}
			// 		break;
			// 	}
			// }
			// if (updated) {
			// 	lastDrawBegin = now();
			// 	doFunc(draw);
			// }
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
		return Browser.window.performance.now();
	}
}
