package pot.graphics.gl;

import js.html.webgl.GL2;

/**
 * list of the texture formats
 */
enum abstract TextureFormat(Int) to Int {
	var R = GL2.RED;
	var RGB = GL2.RGB;
	var RGBA = GL2.RGBA;
}
