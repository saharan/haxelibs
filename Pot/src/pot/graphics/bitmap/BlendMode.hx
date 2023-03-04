package pot.graphics.bitmap;

enum abstract BlendMode(String) to String {
	var Normal = "source-over";
	var Add = "lighter";
	var Multiply = "multiply";
	var Darkest = "darken";
	var Lightest = "lighten";
	var Difference = "difference";
	var Exclusion = "exclusion";
	var Screen = "screen";
}
