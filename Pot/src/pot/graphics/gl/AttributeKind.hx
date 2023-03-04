package pot.graphics.gl;

import js.html.webgl.GL2;

enum abstract AttributeKind(Int) to Int {
	var Separate = GL2.SEPARATE_ATTRIBS;
	var Interleaved = GL2.INTERLEAVED_ATTRIBS;
}
