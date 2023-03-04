package pot.graphics.gl;

import js.lib.Int32Array;
import haxe.ds.Vector;
import haxe.io.UInt8Array;
import js.html.webgl.Framebuffer;
import js.html.webgl.GL2;
import js.lib.ArrayBuffer;
import js.lib.Float32Array;
import js.lib.Uint16Array;
import js.lib.Uint32Array;
import js.lib.Uint8Array;
import pot.graphics.bitmap.BitmapSource;

/**
 * Texture class
 */
class Texture extends GLObject {
	public var width(default, null):Int;
	public var height(default, null):Int;

	final texture:js.html.webgl.Texture;
	final framebuffer:Framebuffer; // just for downloading pixels

	var texWrapU:TextureWrap;
	var texWrapV:TextureWrap;
	var texFilter:TextureFilter;

	public var type(default, null):TextureType;

	@:allow(pot.graphics.gl.Graphics)
	function new(gl:GL2) {
		super(gl);
		texWrapU = Clamp;
		texWrapV = Clamp;
		texFilter = Linear;

		texture = gl.createTexture();
		framebuffer = gl.createFramebuffer();
	}

	public function getRawTexture():js.html.webgl.Texture {
		return texture;
	}

	function internalFormatWrap():Int {
		return switch type {
			case Int8:
				GL2.RGBA8;
			case Int32:
				GL2.RGBA32I;
			case UInt32:
				GL2.RGBA32UI;
			case Float16:
				GL2.RGBA16F;
			case Float32:
				GL2.RGBA32F;
		}
	}

	function formatWrap():Int {
		return switch type {
			case Int32 | UInt32:
				GL2.RGBA_INTEGER;
			case Int8 | Float16 | Float32:
				GL2.RGBA;
		}
	}

	@:allow(pot.graphics.gl.Graphics)
	function init(width:Int, height:Int, type:TextureType):Void {
		this.width = width;
		this.height = height;
		this.type = type;

		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texImage2D(GL2.TEXTURE_2D, 0, internalFormatWrap(), width, height, 0, formatWrap(), type, null);
		gl.bindTexture(GL2.TEXTURE_2D, null);

		switch type {
			case Int32 | UInt32:
				texFilter = Nearest;
			case _:
		}
		filter(texFilter);
		wrap(texWrapU, texWrapV);

		initFBO();
	}

	@:allow(pot.graphics.gl.Graphics)
	function load(source:BitmapSource, type:TextureType):Void {
		this.width = source.width;
		this.height = source.height;
		this.type = type;

		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texImage2D(GL2.TEXTURE_2D, 0, internalFormatWrap(), formatWrap(), type, cast source.source);
		gl.bindTexture(GL2.TEXTURE_2D, null);

		switch type {
			case Int32 | UInt32:
				texFilter = Nearest;
			case _:
		}
		filter(texFilter);
		wrap(texWrapU, texWrapV);

		initFBO();
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Uint8Array,
			flipY:Bool = true):Void {
		if (type != Int8)
			throw "not an 8-bit integer texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_BYTE, pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Int32Array,
			flipY:Bool = true):Void {
		if (type != Int32)
			throw "not a 32-bit integer texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.INT, pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Uint32Array,
			flipY:Bool = true):Void {
		if (type != UInt32)
			throw "not an unsigned 32-bit integer texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_INT, pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function upload(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Float32Array,
			flipY:Bool = true):Void {
		if (type != Float32)
			throw "not a 32-bit floating point texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast flipY);
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texSubImage2D(GL2.TEXTURE_2D, 0, xOffset, yOffset, width, height, formatWrap(), GL2.FLOAT, pixelsRGBA);
		gl.bindTexture(GL2.TEXTURE_2D, null);
		gl.pixelStorei(GL2.UNPACK_FLIP_Y_WEBGL, cast true);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Uint8Array):Void {
		if (type != Int8)
			throw "not an 8-bit integer texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_BYTE, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Int32Array):Void {
		if (type != Int32)
			throw "not a 32-bit integer texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.INT, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Uint32Array):Void {
		if (type != UInt32)
			throw "not an unsigned 32-bit integer texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.UNSIGNED_INT, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	overload extern public inline function download(xOffset:Int, yOffset:Int, width:Int, height:Int, pixelsRGBA:Float32Array):Void {
		if (type != Float32)
			throw "not a 32-bit floating point texture";
		if (pixelsRGBA.length != width * height * 4)
			throw "dimensions mismatch";
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		gl.readPixels(xOffset, yOffset, width, height, formatWrap(), GL2.FLOAT, pixelsRGBA);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	public function sync():Void {
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		gl.readPixels(0, 0, 1, 1, formatWrap(), type, switch type {
			case Int8:
				new Uint8Array(4);
			case Int32:
				new Int32Array(4);
			case UInt32:
				new Uint32Array(4);
			case Float16:
				new Uint16Array(4);
			case Float32:
				new Float32Array(4);
		});
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	function initFBO():Void {
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		gl.framebufferTexture2D(GL2.FRAMEBUFFER, GL2.COLOR_ATTACHMENT0, GL2.TEXTURE_2D, texture, 0);
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	public inline function filter(filter:TextureFilter, enableMipmapping:Bool = false):Void {
		texFilter = filter;
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		switch (filter) {
			case Nearest:
				gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MAG_FILTER, GL2.NEAREST);
				if (enableMipmapping) {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.NEAREST_MIPMAP_NEAREST);
				} else {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.NEAREST);
				}
			case Linear:
				gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MAG_FILTER, GL2.LINEAR);
				if (enableMipmapping) {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.LINEAR_MIPMAP_LINEAR);
				} else {
					gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_MIN_FILTER, GL2.LINEAR);
				}
		}
		if (enableMipmapping) {
			gl.generateMipmap(GL2.TEXTURE_2D);
		}
		gl.bindTexture(GL2.TEXTURE_2D, null);
	}

	public inline function wrap(wrapU:TextureWrap, wrapV:TextureWrap):Void {
		texWrapU = wrapU;
		texWrapV = wrapV;
		gl.bindTexture(GL2.TEXTURE_2D, texture);
		gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_WRAP_S, wrapU);
		gl.texParameteri(GL2.TEXTURE_2D, GL2.TEXTURE_WRAP_T, wrapV);
		gl.bindTexture(GL2.TEXTURE_2D, null);
	}

	function disposeImpl():Void {
		gl.deleteTexture(texture);
		gl.deleteFramebuffer(framebuffer);
	}
}
