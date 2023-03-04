package pot.graphics.gl.low;

import js.html.webgl.GL2;

enum abstract BufferKind(Int) to Int {
	var ArrayBuffer = GL2.ARRAY_BUFFER;
	var ElementArrayBuffer = GL2.ELEMENT_ARRAY_BUFFER;
}
