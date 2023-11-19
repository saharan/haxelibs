package pot.graphics.gl;

import js.html.webgl.GL2;

/**
 * list of the stencil functions
 */
enum abstract StencilFunc(Int) to Int {
	var Never = GL2.NEVER;
	var Always = GL2.ALWAYS;
	var Less = GL2.LESS;
	var LessEqual = GL2.LEQUAL;
	var Greater = GL2.GREATER;
	var GreaterEqual = GL2.GEQUAL;
	var Equal = GL2.EQUAL;
	var NotEqual = GL2.NOTEQUAL;
}
