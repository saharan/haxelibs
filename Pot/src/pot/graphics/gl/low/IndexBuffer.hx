package pot.graphics.gl.low;

import js.html.webgl.GL2;

class IndexBuffer extends GLObject {
	public final buffer:IntBuffer;

	public function new(gl:GL2) {
		super(gl);
		buffer = new IntBuffer(gl, ElementArrayBuffer);
	}

	extern public inline function bind():Void {
		gl.bindBuffer(GL2.ELEMENT_ARRAY_BUFFER, buffer.getRawBuffer());
	}

	function disposeImpl():Void {
		buffer.dispose();
	}
}
