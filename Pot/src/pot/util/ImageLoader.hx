package pot.util;

import pot.graphics.bitmap.Bitmap;
import js.html.Image;

/**
 * ...
 */
class ImageLoader {
	public static function loadImages(sources:Array<String>, onFinished:(bitmaps:Array<Bitmap>) -> Void,
			onError:(source:String) -> Void = null):Void {
		final num = sources.length;
		var left = sources.length;
		var error = false;
		final bitmaps = [for (i in 0...num) null];
		for (i in 0...num) {
			final bitmap = new Bitmap(0, 0);
			final g = bitmap.getGraphics();
			final image = new Image();
			image.src = sources[i];
			image.onload = function() {
				final w = image.width;
				final h = image.height;
				bitmap.setSize(w, h);
				g.drawImage(image, 0, 0, w, h, 0, 0, w, h);
				bitmaps[i] = bitmap;
				if (--left == 0) {
					onFinished(bitmaps);
				}
			}
			image.onerror = function() {
				if (onError != null) {
					onError(sources[i]);
				}
				if (--left == 0) {
					onFinished(bitmaps);
				}
			}
		}
	}
}
