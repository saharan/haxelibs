package pot.graphics.gl.low;

import js.html.webgl.GL2;
import js.html.webgl.VertexArrayObject;

class VertexArrayObject extends GLObject {
	final obj:js.html.webgl.VertexArrayObject;

	public final attributes:Array<VertexAttribute>;
	public final indexBuffer:IndexBuffer;

	public var mode:ShapeMode = Triangles;

	public function new(gl:GL2, attributes:Array<VertexAttribute>, indexBuffer:IndexBuffer) {
		super(gl);
		this.attributes = attributes.copy();
		this.indexBuffer = indexBuffer;

		obj = gl.createVertexArray();
		gl.bindVertexArray(obj);
		for (attribute in attributes)
			attribute.bind();
		indexBuffer.bind();
		gl.bindVertexArray(null);
	}

	public function getRawObject():js.html.webgl.VertexArrayObject {
		return obj;
	}

	public function rebindAttributes():Void {
		gl.bindVertexArray(obj);
		for (attribute in attributes)
			attribute.bind();
		gl.bindVertexArray(null);
	}

	public function draw():Void {
		gl.bindVertexArray(obj);
		gl.drawElements(mode, indexBuffer.buffer.length, GL2.UNSIGNED_INT, 0);
		gl.bindVertexArray(null);
	}

	public function drawInstanced(instanceCount:Int):Void {
		gl.bindVertexArray(obj);
		gl.drawElementsInstanced(mode, indexBuffer.buffer.length, GL2.UNSIGNED_INT, 0, instanceCount);
		gl.bindVertexArray(null);
	}

	function disposeImpl():Void {
		gl.deleteVertexArray(obj);
		for (attribute in attributes)
			attribute.dispose();
		indexBuffer.dispose();
	}
}
