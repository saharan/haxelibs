package pot.graphics.bitmap;

import js.html.ImageData;
import js.html.CanvasRenderingContext2D;
import haxe.ds.Vector;
import js.Browser;
import js.html.CanvasElement;

class Bitmap {
	final canvas:CanvasElement;
	final c2d:CanvasRenderingContext2D;
	final g:BitmapGraphics;

	public var width(default, null):Int = -1;
	public var height(default, null):Int = -1;
	public var numPixels(default, null):Int = -1;
	public var pixels(default, null):Vector<Int> = null;

	var imageData:ImageData = null;

	public function new(width:Int, height:Int) {
		canvas = Browser.document.createCanvasElement();
		c2d = canvas.getContext2d();
		g = new BitmapGraphics(c2d);
		setSize(width, height);
	}

	public inline function getRawCanvas():CanvasElement {
		return canvas;
	}

	public inline function getGraphics():BitmapGraphics {
		return g;
	}

	public function setSize(width:Int, height:Int):Void {
		this.width = width;
		this.height = height;
		numPixels = width * height;
		canvas.width = width;
		canvas.height = height;
		pixels = null;
	}

	public function loadPixels():Void {
		if (pixels == null || pixels.length != numPixels) {
			pixels = new Vector<Int>(numPixels);
		}
		imageData = c2d.getImageData(0, 0, width, height);
		final data = imageData.data;
		var idx = 0;
		for (i in 0...numPixels) {
			final r = data[idx++];
			final g = data[idx++];
			final b = data[idx++];
			final a = data[idx++];
			pixels[i] = a << 24 | r << 16 | g << 8 | b;
		}
	}

	public function updatePixels():Void {
		if (pixels == null || pixels.length != numPixels) {
			throw "incompatible pixel data";
		}
		final data = imageData.data;
		var idx = 0;
		for (i in 0...numPixels) {
			final pix = pixels[i];
			final a = pix >>> 24;
			final r = pix >> 16 & 0xff;
			final g = pix >> 8 & 0xff;
			final b = pix & 0xff;
			data[idx++] = r;
			data[idx++] = g;
			data[idx++] = b;
			data[idx++] = a;
		}
		c2d.putImageData(imageData, 0, 0);
	}
}
