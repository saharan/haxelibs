package pot.graphics.gl;

import js.html.webgl.Renderbuffer;
import js.html.webgl.Framebuffer;
import js.html.webgl.GL2;

class FrameBuffer extends GLObject {
	public final textures:Array<Texture>;

	public var width(default, null):Int;
	public var height(default, null):Int;

	final depth:Renderbuffer;
	final framebuffer:Framebuffer;

	@:allow(pot.graphics.gl.Graphics, pot.graphics.gl.Texture)
	function new(gl:GL2, textures:Array<Texture>, init:Bool) {
		super(gl);
		this.textures = textures.copy();
		depth = gl.createRenderbuffer();
		framebuffer = gl.createFramebuffer();
		if (init) {
			initBuffers();
		}
	}

	@:allow(pot.graphics.gl.Texture)
	function initBuffers():Void {
		width = textures[0].width;
		height = textures[0].height;
		final type = textures[0].type;
		for (texture in textures) {
			if (texture.type != type) {
				throw "all textures must have the same type";
			}
			if (texture.width != width || texture.height != height) {
				throw "all texture sizes must be the same";
			}
		}
		// init depth buffer
		gl.bindRenderbuffer(GL2.RENDERBUFFER, depth);
		gl.renderbufferStorage(GL2.RENDERBUFFER, GL2.DEPTH_COMPONENT32F, width, height);
		gl.bindRenderbuffer(GL2.RENDERBUFFER, null);

		// init frame buffer
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		// bind depth buffer
		gl.framebufferRenderbuffer(GL2.FRAMEBUFFER, GL2.DEPTH_ATTACHMENT, GL2.RENDERBUFFER, depth);
		// bind textures
		for (i => texture in textures) {
			gl.framebufferTexture2D(GL2.FRAMEBUFFER, GL2.COLOR_ATTACHMENT0 + i, GL2.TEXTURE_2D, texture.getRawTexture(), 0);
		}
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	public function getRawFrameBuffer():Framebuffer {
		return framebuffer;
	}

	public function getRawDepthBuffer():Renderbuffer {
		return depth;
	}

	function disposeImpl():Void {
		gl.deleteRenderbuffer(depth);
		gl.deleteFramebuffer(framebuffer);
	}
}
