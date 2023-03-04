package pot.graphics.gl;

import js.html.webgl.GL2;

enum abstract Face(Int) to Int {
	var Front = GL2.FRONT;
	var Back = GL2.BACK;
	var None = GL2.NONE;
}
