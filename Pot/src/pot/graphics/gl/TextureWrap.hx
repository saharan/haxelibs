package pot.graphics.gl;
import js.html.webgl.GL2;

/**
 * ...
 */
enum abstract TextureWrap(Int) to Int {
	var Repeat = GL2.REPEAT;
	var Mirror = GL2.MIRRORED_REPEAT;
	var Clamp = GL2.CLAMP_TO_EDGE;
}
