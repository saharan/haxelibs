package pot.input;

import muun.la.Vec2;

/**
 * ...
 */
@:allow(pot.input.Input)
@:allow(pot.input.Touches)
class Touch {
	public final ppos:Vec2 = Vec2.zero;
	public final pos:Vec2 = Vec2.zero;
	public final delta:Vec2 = Vec2.zero;

	public var px(default, null):Float = 0;
	public var py(default, null):Float = 0;
	public var x(default, null):Float = 0;
	public var y(default, null):Float = 0;
	public var dx(default, null):Float = 0;
	public var dy(default, null):Float = 0;
	public var touching(default, null):Bool = false;
	public var ptouching(default, null):Bool = false;
	public var dtouching(default, null):Int = 0;

	public final id:Int;

	final rawId:Int;

	var px2:Float = 0;
	var py2:Float = 0;
	var nx:Float = 0;
	var ny:Float = 0;
	var ntouching:Bool = false;
	var ntouching2:Bool = false;

	public function new(id:Int, rawId:Int) {
		this.id = id;
		this.rawId = rawId;
	}

	inline function begin(x:Float, y:Float):Void {
		nx = x;
		ny = y;
		ntouching = true;
		ntouching2 = true;
	}

	inline function move(x:Float, y:Float):Void {
		nx = x;
		ny = y;
	}

	inline function end(x:Float, y:Float):Void {
		nx = x;
		ny = y;
		ntouching = false;
	}

	function update(substepRatio:Float):Void {
		if (ntouching2) {
			px = nx;
			py = ny;
			px2 = nx;
			py2 = ny;
		} else {
			px = x;
			py = y;
		}
		x = px2 + substepRatio * (nx - px2);
		y = py2 + substepRatio * (ny - py2);
		dx = x - px;
		dy = y - py;
		ppos.set(px, py);
		pos.set(x, y);
		delta.set(dx, dy);
		ptouching = touching;
		touching = ntouching || ntouching2;
		ntouching2 = false;
		dtouching = (touching ? 1 : 0) - (ptouching ? 1 : 0);
		if (substepRatio == 1) {
			px2 = x;
			py2 = y;
		}
	}
}
