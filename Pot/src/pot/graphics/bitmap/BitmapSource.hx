package pot.graphics.bitmap;

import js.html.VideoElement;
import js.html.CanvasElement;
import js.html.ImageData;
import js.html.ImageElement;

@:forward(source, width, height)
abstract BitmapSource(BitmapSourceData) {
	inline function new(source:Any, width:Int, height:Int) {
		this = new BitmapSourceData(source, width, height);
	}

	@:from
	static function fromBitmap(source:Bitmap):BitmapSource {
		return new BitmapSource(source.getRawCanvas(), source.width, source.height);
	}

	@:from
	static function fromImageData(source:ImageData):BitmapSource {
		return new BitmapSource(source, source.width, source.height);
	}

	@:from
	static function fromImageElement(source:ImageElement):BitmapSource {
		return new BitmapSource(source, source.naturalWidth, source.naturalHeight);
	}

	@:from
	static function fromCanvasElement(source:CanvasElement):BitmapSource {
		return new BitmapSource(source, source.width, source.height);
	}

	@:from
	static function fromVideoElement(source:VideoElement):BitmapSource {
		return new BitmapSource(source, source.videoWidth, source.videoHeight);
	}
}

private class BitmapSourceData {
	public final source:Any;
	public final width:Int;
	public final height:Int;

	public function new(source:Any, width:Int, height:Int) {
		this.source = source;
		this.width = width;
		this.height = height;
	}
}
