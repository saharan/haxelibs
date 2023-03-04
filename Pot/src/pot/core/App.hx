package pot.core;

import js.Browser;
import js.html.CanvasElement;
import pot.input.Input;
import pot.input.InputTarget;

/**
 * Main application class
 */
@:allow(pot.core)
class App {
	/**
	 * Pot instance
	 */
	var pot:Pot;

	/**
	 * User input
	 */
	var input:Input;

	/**
	 * The canvas element
	 */
	var canvas:CanvasElement;

	/**
	 * The number of `App.frame()` calls. Count starts from `0`.
	 */
	var frameCount:Int;

	@:access(pot.core.Pot.beginObservation)
	public function new(canvas:CanvasElement, inputTarget:InputTarget = Canvas, captureKey:Bool = false, captureWheel:Bool = true) {
		this.canvas = canvas;
		pot = new Pot(this, canvas);
		switch inputTarget {
			case Canvas:
				input = new Input(canvas, pot, canvas, captureKey, captureWheel);
			case Document:
				input = new Input(canvas, pot, Browser.document.documentElement, captureKey, captureWheel);
			case None:
				input = null;
		}
		frameCount = -1;
		setup();
		pot.beginObservation();
	}

	/**
	 * Called on resize
	 */
	function resized():Void {
	}

	/**
	 * Called on initialization
	 */
	function setup():Void {
	}

	/**
	 * Called on every update
	 */
	function update():Void {
	}

	/**
	 * Called on every rendering
	 */
	function draw():Void {
	}
}
