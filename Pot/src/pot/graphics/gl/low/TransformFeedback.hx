package pot.graphics.gl.low;

import js.html.webgl.GL2;

class TransformFeedback extends GLObject {
	final tf:js.html.webgl.TransformFeedback;
	final bindingIndices:Array<Int> = [];

	public function new(gl:GL2) {
		super(gl);
		tf = gl.createTransformFeedback();
	}

	public function getRawTransformFeedback():js.html.webgl.TransformFeedback {
		return tf;
	}

	public function bind():Void {
		gl.bindTransformFeedback(GL2.TRANSFORM_FEEDBACK, tf);
	}

	public function bindBuffers(buffers:Array<FloatBuffer>):Void {
		for (i => buffer in buffers) {
			bindBuffer(i, buffer);
		}
	}

	public function bindBuffer(index:Int, buffer:FloatBuffer):Void {
		if (buffer == null) {
			bindingIndices.remove(index);
			gl.bindBufferBase(GL2.TRANSFORM_FEEDBACK_BUFFER, index, null);
		} else {
			if (!bindingIndices.contains(index))
				bindingIndices.push(index);
			gl.bindBufferBase(GL2.TRANSFORM_FEEDBACK_BUFFER, index, buffer.getRawBuffer());
		}
	}

	public function begin():Void {
		gl.enable(GL2.RASTERIZER_DISCARD);
		gl.beginTransformFeedback(GL2.POINTS);
	}

	public function end():Void {
		gl.disable(GL2.RASTERIZER_DISCARD);
		gl.endTransformFeedback();
	}

	public function unbind():Void {
		for (i in bindingIndices) {
			gl.bindBufferBase(GL2.TRANSFORM_FEEDBACK_BUFFER, i, null);
		}
		bindingIndices.resize(0);
		gl.bindTransformFeedback(GL2.TRANSFORM_FEEDBACK, null);
	}

	function disposeImpl():Void {
		gl.deleteTransformFeedback(tf);
	}
}
