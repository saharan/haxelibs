package pot.input;

import muun.la.Vec2;

class Pointer {
	final input:Input;

	public final pos:Vec2 = Vec2.zero;
	public final ppos:Vec2 = Vec2.zero;
	public final delta:Vec2 = Vec2.zero;

	public var hasInput(default, null):Bool = false;
	public var px(default, null):Float = 0;
	public var py(default, null):Float = 0;
	public var x(default, null):Float = 0;
	public var y(default, null):Float = 0;
	public var dx(default, null):Float = 0;
	public var dy(default, null):Float = 0;
	public var down(default, null):Bool = false;
	public var pdown(default, null):Bool = false;
	public var ddown(default, null):Int = 0;

	var touchId:Int = -1;

	public function new(input:Input) {
		this.input = input;
	}

	@:allow(pot.input.Input)
	function update():Void {
		if (input.mouse.hasInput) {
			touchId = -1;
			final mouse = input.mouse;
			px = mouse.px;
			py = mouse.py;
			x = mouse.x;
			y = mouse.y;
			dx = mouse.dx;
			dy = mouse.dy;
			down = mouse.left;
			pdown = mouse.pleft;
			ddown = mouse.dleft;
			hasInput = true;
		} else {
			touchId = -1;
			down = false;
			pdown = false;
			ddown = 0;
			hasInput = false;
			for (touch in input.touches) {
				if (touchId == -1 || touch.id == touchId) {
					touchId = touch.id;
					px = touch.px;
					py = touch.py;
					x = touch.x;
					y = touch.y;
					dx = touch.dx;
					dy = touch.dy;
					down = touch.touching;
					pdown = touch.ptouching;
					ddown = touch.dtouching;
					hasInput = true;
				}
			}
		}
		ppos.set(px, py);
		pos.set(x, y);
		delta.set(dx, dy);
	}
}
