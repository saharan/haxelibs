package pot.graphics.gl;
import js.html.webgl.GL2;

/**
 * ...
 */
enum abstract TextureFilter(Int) {
	var Nearest = GL2.NEAREST;
	var Linear = GL2.LINEAR;
}
