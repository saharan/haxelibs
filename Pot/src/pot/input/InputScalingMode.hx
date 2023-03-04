package pot.input;

enum abstract InputScalingMode(Int) {
	/**
	 * use screen pixel
	 */
	var Screen;
	/**
	 * use actual canvas pixel (scaled by device pixel ratio)
	 */
	var Canvas;
}
