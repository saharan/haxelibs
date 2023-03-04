package pot.graphics.bitmap;

import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

class BitmapGraphics {
	static inline final PI:Float = 3.141592653589793;
	static inline final TWO_PI:Float = PI * 2;

	final canvas:CanvasElement;
	final c2d:CanvasRenderingContext2D;

	public function new(c2d:CanvasRenderingContext2D) {
		this.canvas = c2d.canvas;
		this.c2d = c2d;
	}

	extern public inline function getRawContext():CanvasRenderingContext2D {
		return c2d;
	}

	public function clear(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1):Void {
		save();
		c2d.clearRect(0, 0, canvas.width, canvas.height);
		alpha();
		blend();
		fillColor(r, g, b, a);
		fillRect(0, 0, canvas.width, canvas.height);
		restore();
	}

	extern public inline function alpha(a:Float = 1):Void {
		c2d.globalAlpha = a;
	}

	extern public inline function blend(mode:BlendMode = Normal):Void {
		c2d.globalCompositeOperation = mode;
	}

	extern public inline function fillColor(r:Float, g:Float, b:Float, a:Float = 1.0):Void {
		c2d.fillStyle = 'rgba(${Std.int(r * 255 + 0.5)}, ${Std.int(g * 255 + 0.5)}, ${Std.int(b * 255 + 0.5)}, $a)';
	}

	extern public inline function strokeColor(r:Float, g:Float, b:Float, a:Float = 1.0):Void {
		c2d.strokeStyle = 'rgba(${Std.int(r * 255 + 0.5)}, ${Std.int(g * 255 + 0.5)}, ${Std.int(b * 255 + 0.5)}, $a)';
	}

	extern public inline function font(name:String, size:Float, weight:FontWeight = Normal, fallback:FontFallback = SansSerif):Void {
		c2d.font = '$weight ${size}px "$name", $fallback';
	}

	extern public inline function textAlign(align:TextAlign):Void {
		c2d.textAlign = align;
	}

	extern public inline function textBaseline(baseline:TextBaseline):Void {
		c2d.textBaseline = baseline;
	}

	extern public inline function strokeWidth(w:Float):Void {
		c2d.lineWidth = w;
	}

	extern public inline function strokeJoin(join:StrokeJoin):Void {
		c2d.lineJoin = join;
	}

	extern public inline function strokeCap(cap:StrokeCap):Void {
		c2d.lineCap = cap;
	}

	extern public inline function fillRect(x:Float, y:Float, w:Float, h:Float):Void {
		c2d.fillRect(x, y, w, h);
	}

	extern public inline function strokeRect(x:Float, y:Float, w:Float, h:Float):Void {
		c2d.strokeRect(x, y, w, h);
	}

	extern public inline function fillEllipse(x:Float, y:Float, rx:Float, ry:Float):Void {
		c2d.beginPath();
		c2d.ellipse(x, y, rx, ry, 0, 0, TWO_PI);
		c2d.fill();
	}

	extern public inline function strokeEllipse(x:Float, y:Float, rx:Float, ry:Float):Void {
		c2d.beginPath();
		c2d.ellipse(x, y, rx, ry, 0, 0, TWO_PI);
		c2d.stroke();
	}

	extern public inline function fillCircle(x:Float, y:Float, r:Float):Void {
		c2d.beginPath();
		c2d.arc(x, y, r, 0, TWO_PI);
		c2d.fill();
	}

	extern public inline function strokeCircle(x:Float, y:Float, r:Float):Void {
		c2d.beginPath();
		c2d.arc(x, y, r, 0, TWO_PI);
		c2d.stroke();
	}

	overload extern public inline function fillText(text:String, x:Float, y:Float):Void {
		c2d.fillText(text, x, y);
	}

	overload extern public inline function fillText(text:String, x:Float, y:Float, maxWidth:Float):Void {
		c2d.fillText(text, x, y, maxWidth);
	}

	overload extern public inline function strokeText(text:String, x:Float, y:Float):Void {
		c2d.strokeText(text, x, y);
	}

	overload extern public inline function strokeText(text:String, x:Float, y:Float, maxWidth:Float):Void {
		c2d.strokeText(text, x, y, maxWidth);
	}

	extern public inline function measureText(text:String):Float {
		return c2d.measureText(text).width;
	}

	extern public inline function drawLine(x1:Float, y1:Float, x2:Float, y2:Float):Void {
		c2d.beginPath();
		c2d.moveTo(x1, y1);
		c2d.lineTo(x2, y2);
		c2d.stroke();
	}

	extern public inline function beginPath():Void {
		c2d.beginPath();
	}

	extern public inline function closePath():Void {
		c2d.closePath();
	}

	extern public inline function moveTo(x:Float, y:Float):Void {
		c2d.moveTo(x, y);
	}

	extern public inline function lineTo(x:Float, y:Float):Void {
		c2d.lineTo(x, y);
	}

	extern public inline function quadraticCurveTo(cx:Float, cy:Float, x:Float, y:Float):Void {
		c2d.quadraticCurveTo(cx, cy, x, y);
	}

	extern public inline function cubicCurveTo(c1x:Float, c1y:Float, c2x:Float, c2y:Float, x:Float, y:Float):Void {
		c2d.bezierCurveTo(c1x, c1y, c2x, c2y, x, y);
	}

	extern public inline function arcTo(c1x:Float, c1y:Float, c2x:Float, c2y:Float, r:Float):Void {
		c2d.arcTo(c1x, c1y, c2x, c2y, r);
	}

	extern public inline function arc(x:Float, y:Float, r:Float, start:Float, end:Float, anticlockwise:Bool = false):Void {
		c2d.arc(x, y, r, start, end, anticlockwise);
	}

	extern public inline function ellipse(x:Float, y:Float, rx:Float, ry:Float, rotation:Float, start:Float, end:Float,
			anticlockwise:Bool = false):Void {
		c2d.ellipse(x, y, rx, ry, rotation, start, end, anticlockwise);
	}

	extern public inline function rect(x:Float, y:Float, w:Float, h:Float):Void {
		c2d.rect(x, y, w, h);
	}

	extern public inline function fill():Void {
		c2d.fill();
	}

	extern public inline function stroke():Void {
		c2d.stroke();
	}

	extern public inline function save():Void {
		c2d.save();
	}

	extern public inline function restore():Void {
		c2d.restore();
	}

	extern public inline function saving(f:() -> Void):Void {
		save();
		f();
		restore();
	}

	extern public inline function translate(x:Float, y:Float):Void {
		c2d.translate(x, y);
	}

	extern public inline function rotate(ang:Float):Void {
		c2d.rotate(ang);
	}

	extern public inline function scale(x:Float, y:Float):Void {
		c2d.scale(x, y);
	}

	extern public inline function resetTransform():Void {
		c2d.resetTransform();
	}

	extern public inline function imageSmoothing(enabled:Bool):Void {
		c2d.imageSmoothingEnabled = enabled;
	}

	extern overload public inline function drawImage(src:BitmapSource, dx:Float, dy:Float):Void {
		c2d.drawImage(src.source, dx, dy);
	}

	extern overload public inline function drawImage(src:BitmapSource, dx:Float, dy:Float, dw:Float, dh:Float):Void {
		c2d.drawImage(src.source, dx, dy, dw, dh);
	}

	extern overload public inline function drawImage(src:BitmapSource, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float,
			dw:Float, dh:Float):Void {
		c2d.drawImage(src.source, sx, sy, sw, sh, dx, dy, dw, dh);
	}
}
