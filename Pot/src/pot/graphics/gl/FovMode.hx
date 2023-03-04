package pot.graphics.gl;

/**
 * list of the field-of-view modes
 */
enum abstract FovMode(Int) {
	/**
	 * Use field-of-view for X-axis.
	 */
	var FovX = 0;

	/**
	 * Use field-of-view for Y-axis.
	 */
	var FovY = 1;

	/**
	 * Use field-of-view for the narrower axis.
	 */
	var FovMin = 2;

	/**
	 * Use field-of-view for the broader axis.
	 */
	var FovMax = 3;
}
