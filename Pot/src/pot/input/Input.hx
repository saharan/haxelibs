package pot.input;

import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
import pot.core.Pot;

/**
 * ...
 */
class Input {
	public var mouse(default, null):Mouse;
	public var touches(default, null):Touches;
	public var keyboard(default, null):Keyboard;

	public var scalingMode:InputScalingMode;

	@:allow(pot.core.App)
	function new(canvas:CanvasElement, pot:Pot, target:Element, captureKey:Bool, captureWheel:Bool) {
		mouse = new Mouse();
		touches = new Touches();
		keyboard = captureKey ? new Keyboard() : null;
		scalingMode = Screen;
		addEvents(canvas, target, pot, captureWheel);
	}

	function addEvents(canvas:CanvasElement, target:Element, pot:Pot, captureWheel:Bool):Void {
		mouse.addEvents(canvas, target, this, pot, captureWheel);
		touches.addEvents(canvas, target, this, pot);
		if (keyboard != null)
			keyboard.addEvents(canvas, Browser.document.documentElement);
	}

	@:allow(pot.core.Pot)
	function update(substepRatio:Float):Void {
		mouse.update(substepRatio);
		touches.update(substepRatio);
		if (keyboard != null)
			keyboard.update();
		if (touches.length > 0)
			mouse.hasInput = false;
	}
}
