package pot.graphics.gl.low;

import js.html.webgl.GL2;

/**
 * list of the shape drawing modes
 */
enum abstract ShapeMode(Int) to Int {
	var Points = GL2.POINTS;
	var Lines = GL2.LINES;
	var LineStrip = GL2.LINE_STRIP;
	var LineLoop = GL2.LINE_LOOP;
	var Triangles = GL2.TRIANGLES;
	var TriangleStrip = GL2.TRIANGLE_STRIP;
	var TriangleFan = GL2.TRIANGLE_FAN;
}
