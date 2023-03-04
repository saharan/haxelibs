package pot.graphics.gl;

import js.html.webgl.GL2;

abstract class GLObject {
	var disposed:Bool = false;
	final gl:GL2;

	function new(gl:GL2) {
		this.gl = gl;
	}

	public function dispose():Void {
		if (disposed)
			return;
		disposed = true;
		disposeImpl();
	}

	abstract function disposeImpl():Void;
}
