package pot.graphics.gl;

import js.html.webgl.GL2;

/**
 * list of the stencil faces
 */
enum abstract StencilFace(Int) to Int {
	var Front = GL2.FRONT;
	var Back = GL2.BACK;
	var Both = GL2.FRONT_AND_BACK;
}
