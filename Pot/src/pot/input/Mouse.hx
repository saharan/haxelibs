package pot.input;

import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
import js.html.MouseEvent;
import js.html.PointerEvent;
import js.html.WheelEvent;
import js.html.webgl.ContextEvent;
import pot.core.Pot;

using pot.input.InputTools;

/**
 * ...
 */
@:allow(pot.input.Input)
class Mouse {
	public var px(default, null):Float;
	public var py(default, null):Float;
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var dx(default, null):Float;
	public var dy(default, null):Float;
	public var pleft(default, null):Bool;
	public var pmiddle(default, null):Bool;
	public var pright(default, null):Bool;
	public var left(default, null):Bool;
	public var middle(default, null):Bool;
	public var right(default, null):Bool;
	public var dleft(default, null):Int;
	public var dmiddle(default, null):Int;
	public var dright(default, null):Int;

	/**
	 * unit: pixel
	 */
	public var wheelX(default, null):Float;

	/**
	 * unit: pixel
	 */
	public var wheelY(default, null):Float;

	public var onContent(default, null):Bool;
	public var hasInput(default, null):Bool;

	var px2:Float;
	var py2:Float;
	var nx:Float;
	var ny:Float;
	var nleft:Bool;
	var nleft2:Bool;
	var nmiddle:Bool;
	var nmiddle2:Bool;
	var nright:Bool;
	var nright2:Bool;
	var nwheelX:Float;
	var nwheelY:Float;

	public function new() {
		px = 0;
		py = 0;
		px2 = 0;
		py2 = 0;
		x = 0;
		y = 0;
		nx = 0;
		ny = 0;
		dx = 0;
		dy = 0;
		wheelX = 0;
		wheelY = 0;
		nwheelX = 0;
		nwheelY = 0;
		pleft = false;
		pmiddle = false;
		pright = false;
		left = false;
		middle = false;
		right = false;
		nleft = false;
		nmiddle = false;
		nright = false;
		nleft2 = false;
		nmiddle2 = false;
		nright2 = false;
		dleft = 0;
		dmiddle = 0;
		dright = 0;
		hasInput = false;
		onContent = false;
	}

	function addEvents(canvas:CanvasElement, target:Element, input:Input, pot:Pot, captureWheel:Bool):Void {
		target.addEventListener("mouseenter", (e:MouseEvent) -> {
			onContent = true;
		});
		target.addEventListener("mouseleave", (e:MouseEvent) -> {
			onContent = false;
		});
		target.addEventListener("mousedown", (e:MouseEvent) -> {
			hasInput = true;
			onContent = true;
			if (e.cancelable)
				e.preventDefault();
			switch (e.button) {
				case 0:
					nleft = true;
					nleft2 = true;
				case 1:
					nmiddle = true;
					nmiddle2 = true;
				case 2:
					nright = true;
					nright2 = true;
			}
			nx = (e.clientX - canvas.clientX()) * canvas.scaleX(input.scalingMode, pot.pixelRatio);
			ny = (e.clientY - canvas.clientY()) * canvas.scaleY(input.scalingMode, pot.pixelRatio);
		});
		target.addEventListener("mouseup", (e:MouseEvent) -> {
			hasInput = true;
			onContent = true;
			if (e.cancelable)
				e.preventDefault();
			switch (e.button) {
				case 0:
					nleft = false;
				case 1:
					nmiddle = false;
				case 2:
					nright = false;
			}
			nx = (e.clientX - canvas.clientX()) * canvas.scaleX(input.scalingMode, pot.pixelRatio);
			ny = (e.clientY - canvas.clientY()) * canvas.scaleY(input.scalingMode, pot.pixelRatio);
		});
		target.addEventListener("mousemove", (e:MouseEvent) -> {
			hasInput = true;
			onContent = true;
			nx = (e.clientX - canvas.clientX()) * canvas.scaleX(input.scalingMode, pot.pixelRatio);
			ny = (e.clientY - canvas.clientY()) * canvas.scaleY(input.scalingMode, pot.pixelRatio);
		});
		if (captureWheel) {
			target.addEventListener("wheel", (e:WheelEvent) -> {
				var pixelsPerLine = 24;
				var linesPerPage = 30;
				var scale = switch e.deltaMode {
					case 0:
						1;
					case 1:
						pixelsPerLine;
					case 2:
						pixelsPerLine * linesPerPage;
					case _:
						throw "invalid wheel delta mode";
				}
				nwheelX += e.deltaX * scale;
				nwheelY += e.deltaY * scale;
				e.preventDefault();
			}, {passive: false});
		}
		target.addEventListener("contextmenu", (e:ContextEvent) -> {
			hasInput = true;
			onContent = true;
			e.preventDefault();
		});
		target.addEventListener("pointerdown", (e:PointerEvent) -> {
			target.setPointerCapture(e.pointerId);
		});
		target.addEventListener("pointerup", (e:PointerEvent) -> {
			target.releasePointerCapture(e.pointerId);
		});
	}

	function update(substepRatio:Float):Void {
		px = x;
		py = y;
		x = px2 + substepRatio * (nx - px2);
		y = py2 + substepRatio * (ny - py2);
		dx = x - px;
		dy = y - py;
		pleft = left;
		pmiddle = middle;
		pright = right;
		left = nleft || nleft2;
		middle = nmiddle || nmiddle2;
		right = nright || nright2;
		nleft2 = false;
		nmiddle2 = false;
		nright2 = false;
		dleft = (left ? 1 : 0) - (pleft ? 1 : 0);
		dmiddle = (middle ? 1 : 0) - (pmiddle ? 1 : 0);
		dright = (right ? 1 : 0) - (pright ? 1 : 0);
		wheelX = nwheelX;
		wheelY = nwheelY;
		nwheelX = 0;
		nwheelY = 0;
		if (substepRatio == 1) {
			px2 = x;
			py2 = y;
		}
	}
}
