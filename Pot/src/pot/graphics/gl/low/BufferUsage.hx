package pot.graphics.gl.low;

import js.html.webgl.GL2;

enum abstract BufferUsage(Int) to Int {
	var StaticDraw = GL2.STATIC_DRAW;
	var StaticCopy = GL2.STATIC_COPY;
	var DynamicDraw = GL2.DYNAMIC_DRAW;
	var DynamicCopy = GL2.DYNAMIC_COPY;
}
