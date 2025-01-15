package pot.graphics.gl;

import js.html.webgl.GL2;

/**
 * list of the texture types
 */
enum abstract TextureType(Int) to Int {
	/**
	 * Represents 8-bit integer type.
	 */
	var UInt8 = GL2.UNSIGNED_BYTE;

	/**
	 * Represents 32-bit signed integer type.
	 */
	var Int32 = GL2.INT;

	/**
	 * Represents 32-bit unsigned integer type.
	 */
	var UInt32 = GL2.UNSIGNED_INT;

	/**
	 * Represents 16-bit floating point number type.
	 */
	var Float16 = GL2.HALF_FLOAT;

	/**
	 * Represents 32-bit floating point number type.
	 */
	var Float32 = GL2.FLOAT;
}
