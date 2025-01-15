package pot.core;

import muun.la.Vec2;
import js.html.Element;
import js.Browser;
import js.html.CanvasElement;

/**
 * Pot Engine
 */
class Pot {
	public var width(default, null):Float;
	public var height(default, null):Float;
	public var size(get, never):Vec2;
	public var pixelRatio(default, null):Float;
	public var asyncUpdate:Bool = false;

	var app:App;
	var canvas:CanvasElement;
	var frameRateManager:FrameRateManager;
	var obs:ResizeObserver;
	var onEndUpdate:() -> Void = null;

	var sticking:Element;

	public function new(app:App, canvas:CanvasElement) {
		this.app = app;
		this.canvas = canvas;
		resize();
		frameRateManager = new FrameRateManager(update, draw);
		frameRate(Fixed(60));
	}

	public function frameRate(frameRate:FrameRate):Void {
		switch frameRate {
			case Auto:
				frameRateManager.setFrameRate(60);
				frameRateManager.doNotAdjust = true;
			case Fixed(fps):
				frameRateManager.setFrameRate(fps);
				frameRateManager.doNotAdjust = false;
		}
	}

	public function frameSkip(enable:Bool):Void {
		frameRateManager.frameSkipEnabled = enable;
	}

	public function isMobile():Bool {
		return ~/iPhone|Android.+Mobile/.match(Browser.navigator.userAgent);
	}

	function beginObservation():Void {
		obs = new ResizeObserver(_ -> {
			if (resize()) {
				app.resized();
			}
		});
		obs.observe(canvas);
		obs.observe(Browser.document.documentElement);
		app.resized();
	}

	function get_size():Vec2 {
		return Vec2.of(width, height);
	}

	function resize():Bool {
		final w = canvas.clientWidth;
		final h = canvas.clientHeight;
		final dpr = Browser.window.devicePixelRatio;
		if (width != w || height != h || pixelRatio != dpr) {
			width = w;
			height = h;
			pixelRatio = dpr;
			canvas.width = Std.int(width * pixelRatio + 0.5);
			canvas.height = Std.int(height * pixelRatio + 0.5);
			return true;
		} else {
			return false;
		}
	}

	public function start():Void {
		frameRateManager.start();
	}

	public function stop():Void {
		frameRateManager.stop();
	}

	function update(substepRatio:Float, callback:() -> Void):Void {
		app.frameCount++;
		if (app.input != null)
			app.input.update(substepRatio);
		if (asyncUpdate) {
			onEndUpdate = callback;
			app.update();
		} else {
			app.update();
			callback();
		}
	}

	public function endUpdate():Void {
		assert(asyncUpdate, "async update is disabled");
		assert(onEndUpdate != null, "callback function not set");
		onEndUpdate();
		onEndUpdate = null;
	}

	function draw():Void {
		app.draw();
	}
}

@:native("ResizeObserver")
private extern class ResizeObserver {
	function new(onResize:(entries:Array<Element>) -> Void);
	function observe(target:Element):Void;
	function unobserve(target:Element):Void;
	function disconnect():Void;
}
