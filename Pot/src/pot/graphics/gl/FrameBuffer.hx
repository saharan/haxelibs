package pot.graphics.gl;

import js.Browser;
import js.html.webgl.Renderbuffer;
import js.html.webgl.Framebuffer;
import js.html.webgl.GL2;

class FrameBuffer extends GLObject {
	public final textures:Array<Texture>;

	public var width(default, null):Int;
	public var height(default, null):Int;

	final depthStencil:Renderbuffer;
	final framebuffer:Framebuffer;

	@:allow(pot.graphics.gl.Graphics, pot.graphics.gl.Texture)
	function new(gl:GL2, textures:Array<Texture>, init:Bool) {
		super(gl);
		this.textures = textures.copy();
		depthStencil = gl.createRenderbuffer();
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
		// init depth-stencil buffer
		gl.bindRenderbuffer(GL2.RENDERBUFFER, depthStencil);
		gl.renderbufferStorage(GL2.RENDERBUFFER, GL2.DEPTH32F_STENCIL8, width, height);
		gl.bindRenderbuffer(GL2.RENDERBUFFER, null);

		// init frame buffer
		gl.bindFramebuffer(GL2.FRAMEBUFFER, framebuffer);
		// bind depth-stencil buffer
		gl.framebufferRenderbuffer(GL2.FRAMEBUFFER, GL2.DEPTH_STENCIL_ATTACHMENT, GL2.RENDERBUFFER, depthStencil);
		// bind textures
		for (i => texture in textures) {
			gl.framebufferTexture2D(GL2.FRAMEBUFFER, GL2.COLOR_ATTACHMENT0 + i, GL2.TEXTURE_2D,
				texture.getRawTexture(), 0);
		}
		final status = gl.checkFramebufferStatus(GL2.FRAMEBUFFER);
		switch status {
			case GL2.FRAMEBUFFER_COMPLETE: // ok
			case GL2.FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
				Browser.alert("error: framebuffer incomplete attachment");
			case GL2.FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
				Browser.alert("error: framebuffer incomplete missing attachment");
			case GL2.FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
				Browser.alert("error: framebuffer incomplete dimensions");
			case GL2.FRAMEBUFFER_UNSUPPORTED:
				Browser.alert("error: framebuffer unsupported");
			case GL2.FRAMEBUFFER_INCOMPLETE_MULTISAMPLE:
				Browser.alert("error: framebuffer incomplete multisample");
			case other:
				Browser.alert("error: framebuffer status=" + other);
		}
		gl.bindFramebuffer(GL2.FRAMEBUFFER, null);
	}

	public function getRawFrameBuffer():Framebuffer {
		return framebuffer;
	}

	public function getRawDepthStencilBuffer():Renderbuffer {
		return depthStencil;
	}

	function disposeImpl():Void {
		gl.deleteRenderbuffer(depthStencil);
		gl.deleteFramebuffer(framebuffer);
	}
}
