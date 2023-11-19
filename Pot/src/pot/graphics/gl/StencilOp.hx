package pot.graphics.gl;

import js.html.webgl.GL2;

/**
 * list of the stencil operations
 */
enum abstract StencilOp(Int) to Int {
	var Keep = GL2.KEEP;
	var Zero = GL2.ZERO;
	var Replace = GL2.REPLACE;
	var IncrementSaturate = GL2.INCR;
	var IncrementWrap = GL2.INCR_WRAP;
	var DecrementSaturate = GL2.DECR;
	var DecrementWrap = GL2.DECR_WRAP;
	var Invert = GL2.INVERT;
}
