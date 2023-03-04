package pot.graphics.gl.low;

import js.html.webgl.UniformLocation;
import js.html.webgl.GL2;
import js.html.webgl.Shader;

class Program extends GLObject {
	final program:js.html.webgl.Program;
	final vertexShader:Shader;
	final fragmentShader:Shader;

	public var compiled(default, null):Bool = false;

	public function new(gl:GL2) {
		super(gl);
		program = gl.createProgram();
		vertexShader = gl.createShader(GL2.VERTEX_SHADER);
		fragmentShader = gl.createShader(GL2.FRAGMENT_SHADER);
	}

	public function getRawProgram():js.html.webgl.Program {
		return program;
	}

	public function compile(vertexSource:String, fragmentSource:String, ?transformFeedbackOutput:TransformFeedbackOutput,
			onCompileErrorVertex:(message:String) -> Void, onCompileErrorFragment:(message:String) -> Void,
			onLinkError:(message:String) -> Void):Void {
		gl.shaderSource(vertexShader, vertexSource);
		gl.compileShader(vertexShader);
		if (!gl.getShaderParameter(vertexShader, GL2.COMPILE_STATUS)) {
			onCompileErrorVertex(gl.getShaderInfoLog(vertexShader));
		}

		gl.shaderSource(fragmentShader, fragmentSource);
		gl.compileShader(fragmentShader);
		if (!gl.getShaderParameter(fragmentShader, GL2.COMPILE_STATUS)) {
			onCompileErrorFragment(gl.getShaderInfoLog(fragmentShader));
		}

		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		if (transformFeedbackOutput != null) {
			gl.transformFeedbackVaryings(program, transformFeedbackOutput.varyings, transformFeedbackOutput.kind);
		}
		gl.linkProgram(program);
		if (gl.getProgramParameter(program, GL2.LINK_STATUS)) {
			compiled = true;
		} else {
			onLinkError(gl.getProgramInfoLog(program));
		}
	}

	public function use():Void {
		gl.useProgram(program);
	}

	public function getUniformLocation(name:String):UniformLocation {
		return gl.getUniformLocation(program, name);
	}

	function disposeImpl():Void {
		gl.deleteProgram(program);
		gl.deleteShader(vertexShader);
		gl.deleteShader(fragmentShader);
	}
}
