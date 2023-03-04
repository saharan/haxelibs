package pot.input;

import js.html.CanvasElement;
import js.html.Element;

/**
 * ...
 */
class InputTools {
	public static inline function clientX(e:Element):Float {
		return e.getBoundingClientRect().left;
	}

	public static inline function clientY(e:Element):Float {
		return e.getBoundingClientRect().top;
	}

	public static inline function scaleX(canvas:CanvasElement, mode:InputScalingMode, pixelRatio:Float):Float {
		return switch (mode) {
			case Canvas: canvas.width / canvas.clientWidth;
			case Screen: canvas.width / pixelRatio / canvas.clientWidth;
		};
	}

	public static inline function scaleY(canvas:CanvasElement, mode:InputScalingMode, pixelRatio:Float):Float {
		return switch (mode) {
			case Canvas: canvas.height / canvas.clientHeight;
			case Screen: canvas.height / pixelRatio / canvas.clientHeight;
		};
	}
}
