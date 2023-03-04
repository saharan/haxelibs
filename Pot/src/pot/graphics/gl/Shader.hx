package pot.graphics.gl;

import js.Browser;
import js.html.webgl.GL2;
import js.html.webgl.UniformLocation;
import js.lib.Error;
import js.lib.Float32Array;
import js.lib.Int32Array;
import js.lib.Uint32Array;
import pot.graphics.gl.low.Program;

/**
 * Shader class
 */
class Shader extends GLObject {
	public final program:Program;

	var localTextureCount:Int = 0;
	final uniformLocationMap:Map<String, UniformLocation> = [];
	final uniformValueMap:Map<String, InternalUniformValue> = [];

	@:allow(pot.graphics.gl.Graphics)
	function new(gl:GL2) {
		super(gl);
		program = new Program(gl);
	}

	public function hasUniform(name:String):Bool {
		return getUniformLocation(name) != null;
	}

	static var id = 0;

	@:allow(pot.graphics.gl.Graphics)
	public function compile(vertexSource:String, fragmentSource:String, ?transformFeedbackOutput:TransformFeedbackOutput) {
		uniformLocationMap.clear();
		uniformValueMap.clear();

		var alerted = false;
		program.compile(vertexSource, fragmentSource, transformFeedbackOutput, message -> {
			final msg = message + "\nvertex shader source:\n" + vertexSource;
			Browser.alert(msg);
			Browser.console.log(msg);
			alerted = true;
		}, message -> {
			final msg = message + "\nfragment shader source:\n" + fragmentSource;
			Browser.alert(msg);
			Browser.console.log(msg);
			alerted = true;
		}, message -> {
			if (!alerted)
				Browser.alert(message);
			Browser.console.log(message);
		});
	}

	@:allow(pot.graphics.gl)
	function bind(maps:Array<UniformMap>):Void {
		if (!program.compiled)
			throw new Error("shader is not compiled");
		program.use();
		bindUniforms(maps);
	}

	function bindUniforms(maps:Array<UniformMap>):Void {
		localTextureCount = 0;
		for (map in maps) {
			for (name => value in map) {
				if (!hasUniform(name)) {
					continue;
				}
				bindUniform(name, getUniformLocation(name), value);
			}
		}
		gl.activeTexture(GL2.TEXTURE0);
	}

	function bindUniform(name:String, location:UniformLocation, value:UniformValue):Void {
		var ivalue = uniformValueMap.get(name);
		var type = -1; // 0: float, 1: int, 2: uint
		var dim = -1;
		var count = -1;
		switch value {
			case Float(_):
				type = 0;
				dim = 1;
				count = 1;
			case Vec2(_):
				type = 0;
				dim = 2;
				count = 1;
			case Vec3(_):
				type = 0;
				dim = 3;
				count = 1;
			case Vec4(_):
				type = 0;
				dim = 4;
				count = 1;
			case Int(_):
				type = 1;
				dim = 1;
				count = 1;
			case IVec2(_):
				type = 1;
				dim = 2;
				count = 1;
			case IVec3(_):
				type = 1;
				dim = 3;
				count = 1;
			case IVec4(_):
				type = 1;
				dim = 4;
				count = 1;
			case UInt(_):
				type = 2;
				dim = 1;
				count = 1;
			case UVec2(_):
				type = 2;
				dim = 2;
				count = 1;
			case UVec3(_):
				type = 2;
				dim = 3;
				count = 1;
			case UVec4(_):
				type = 2;
				dim = 4;
				count = 1;
			case Bool(_):
				type = 1;
				dim = 1;
				count = 1;
			case BVec2(_):
				type = 1;
				dim = 2;
				count = 1;
			case BVec3(_):
				type = 1;
				dim = 3;
				count = 1;
			case BVec4(_):
				type = 1;
				dim = 4;
				count = 1;
			case Mat(cols, rows, _):
				type = 0;
				dim = rows;
				count = cols;
			case Sampler(_):
				type = 1;
				dim = 1;
				count = 1;
			case Floats(vs):
				type = 0;
				dim = 1;
				count = vs.length;
			case Vecs(vs):
				type = 0;
				dim = vs[0].length;
				count = vs.length;
			case Ints(vs):
				type = 1;
				dim = 1;
				count = vs.length;
			case IVecs(vs):
				type = 1;
				dim = vs[0].length;
				count = vs.length;
			case UInts(vs):
				type = 2;
				dim = 1;
				count = vs.length;
			case UVecs(vs):
				type = 2;
				dim = vs[0].length;
				count = vs.length;
			case Bools(vs):
				type = 1;
				dim = 1;
				count = vs.length;
			case BVecs(vs):
				type = 1;
				dim = vs[0].length;
				count = vs.length;
			case Mats(cols, rows, vs):
				type = 0;
				dim = rows;
				count = cols * vs.length;
				if (cols < 2 || rows < 2 || cols > 4 || rows > 4)
					throw "invalid matrix size: " + cols + ", " + rows;
			case Samplers(ts):
				type = 1;
				dim = 1;
				count = ts.length;
		}
		var fa = null;
		var ia = null;
		var ua = null;
		final sameType = switch ivalue {
			case null:
				false;
			case Floats(vdim, vs):
				fa = vs;
				type == 0 && dim == vdim && dim * count == vs.length;
			case Ints(vdim, vs):
				ia = vs;
				type == 1 && dim == vdim && dim * count == vs.length;
			case UInts(vdim, vs):
				ua = vs;
				type == 2 && dim == vdim && dim * count == vs.length;
		}
		if (!sameType) {
			ivalue = switch type {
				case 0:
					Floats(dim, fa = new Float32Array(dim * count));
				case 1:
					Ints(dim, ia = new Int32Array(dim * count));
				case _:
					UInts(dim, ua = new Uint32Array(dim * count));
			}
		}
		var sameValue = sameType;
		switch value {
			case Float(x):
				sameValue = sameValue && fa[0] == x;
				fa[0] = x;
			case Vec2(x, y):
				sameValue = sameValue && fa[0] == x && fa[1] == y;
				fa[0] = x;
				fa[1] = y;
			case Vec3(x, y, z):
				sameValue = sameValue && fa[0] == x && fa[1] == y && fa[2] == z;
				fa[0] = x;
				fa[1] = y;
				fa[2] = z;
			case Vec4(x, y, z, w):
				sameValue = sameValue && fa[0] == x && fa[1] == y && fa[2] == z && fa[3] == w;
				fa[0] = x;
				fa[1] = y;
				fa[2] = z;
				fa[3] = w;
			case Int(x):
				sameValue = sameValue && ia[0] == x;
				ia[0] = x;
			case IVec2(x, y):
				sameValue = sameValue && ia[0] == x && ia[1] == y;
				ia[0] = x;
				ia[1] = y;
			case IVec3(x, y, z):
				sameValue = sameValue && ia[0] == x && ia[1] == y && ia[2] == z;
				ia[0] = x;
				ia[1] = y;
				ia[2] = z;
			case IVec4(x, y, z, w):
				sameValue = sameValue && ia[0] == x && ia[1] == y && ia[2] == z && ia[3] == w;
				ia[0] = x;
				ia[1] = y;
				ia[2] = z;
				ia[3] = w;
			case UInt(x):
				sameValue = sameValue && ua[0] == x;
				ua[0] = x;
			case UVec2(x, y):
				sameValue = sameValue && ua[0] == x && ua[1] == y;
				ua[0] = x;
				ua[1] = y;
			case UVec3(x, y, z):
				sameValue = sameValue && ua[0] == x && ua[1] == y && ua[2] == z;
				ua[0] = x;
				ua[1] = y;
				ua[2] = z;
			case UVec4(x, y, z, w):
				sameValue = sameValue && ua[0] == x && ua[1] == y && ua[2] == z && ua[3] == w;
				ua[0] = x;
				ua[1] = y;
				ua[2] = z;
				ua[3] = w;
			case Bool(x):
				sameValue = sameValue && ia[0] == (x ? 1 : 0);
				ia[0] = x ? 1 : 0;
			case BVec2(x, y):
				sameValue = sameValue && ia[0] == (x ? 1 : 0) && ia[1] == (y ? 1 : 0);
				ia[0] = x ? 1 : 0;
				ia[1] = y ? 1 : 0;
			case BVec3(x, y, z):
				sameValue = sameValue && ia[0] == (x ? 1 : 0) && ia[1] == (y ? 1 : 0) && ia[2] == (z ? 1 : 0);
				ia[0] = x ? 1 : 0;
				ia[1] = y ? 1 : 0;
				ia[2] = z ? 1 : 0;
			case BVec4(x, y, z, w):
				sameValue = sameValue && ia[0] == (x ? 1 : 0) && ia[1] == (y ? 1 : 0) && ia[2] == (z ? 1 : 0) && ia[3] == (w ? 1 : 0);
				ia[0] = x ? 1 : 0;
				ia[1] = y ? 1 : 0;
				ia[2] = z ? 1 : 0;
				ia[3] = w ? 1 : 0;
			case Mat(_, _, vs):
				for (i => v in vs) {
					sameValue = sameValue && fa[i] == v;
					fa[i] = v;
				}
			case Sampler(t):
				sameValue = sameValue && ia[0] == localTextureCount;
				ia[0] = localTextureCount;
				gl.activeTexture(GL2.TEXTURE0 + localTextureCount);
				gl.bindTexture(GL2.TEXTURE_2D, t == null ? null : t.getRawTexture());
				localTextureCount++;
			case Floats(vs):
				for (i => v in vs) {
					sameValue = sameValue && fa[i] == v;
					fa[i] = v;
				}
			case Vecs(vs):
				var i = 0;
				for (vec in vs) {
					for (v in vec) {
						sameValue = sameValue && fa[i] == v;
						fa[i] = v;
						i++;
					}
				}
			case Ints(vs):
				for (i => v in vs) {
					sameValue = sameValue && ia[i] == v;
					ia[i] = v;
				}
			case IVecs(vs):
				var i = 0;
				for (vec in vs) {
					for (v in vec) {
						sameValue = sameValue && ia[i] == v;
						ia[i] = v;
						i++;
					}
				}
			case UInts(vs):
				for (i => v in vs) {
					sameValue = sameValue && ua[i] == v;
					ua[i] = v;
				}
			case UVecs(vs):
				var i = 0;
				for (vec in vs) {
					for (v in vec) {
						sameValue = sameValue && ua[i] == v;
						ua[i] = v;
						i++;
					}
				}
			case Bools(vs):
				for (i => v in vs) {
					sameValue = sameValue && ia[i] == (v ? 1 : 0);
					ia[i] = v ? 1 : 0;
				}
			case BVecs(vs):
				var i = 0;
				for (vec in vs) {
					for (v in vec) {
						sameValue = sameValue && ia[i] == (v ? 1 : 0);
						ia[i] = v ? 1 : 0;
						i++;
					}
				}
			case Mats(_, _, vs):
				var i = 0;
				for (vec in vs) {
					for (v in vec) {
						sameValue = sameValue && fa[i] == v;
						fa[i] = v;
						i++;
					}
				}
			case Samplers(ts):
				for (i => t in ts) {
					sameValue = sameValue && ia[i] == localTextureCount;
					ia[i] = localTextureCount;
					gl.activeTexture(GL2.TEXTURE0 + localTextureCount);
					gl.bindTexture(GL2.TEXTURE_2D, t.getRawTexture());
					localTextureCount++;
				}
		}
		if (sameValue)
			return;
		uniformValueMap[name] = ivalue;
		switch value {
			case Mat(cols, rows, _) | Mats(cols, rows, _):
				switch [cols, rows] {
					case [2, 2]:
						gl.uniformMatrix2fv(location, false, fa);
					case [2, 3]:
						gl.uniformMatrix2x3fv(location, false, fa);
					case [2, 4]:
						gl.uniformMatrix2x4fv(location, false, fa);
					case [3, 2]:
						gl.uniformMatrix3x2fv(location, false, fa);
					case [3, 3]:
						gl.uniformMatrix3fv(location, false, fa);
					case [3, 4]:
						gl.uniformMatrix3x4fv(location, false, fa);
					case [4, 2]:
						gl.uniformMatrix4x2fv(location, false, fa);
					case [4, 3]:
						gl.uniformMatrix4x3fv(location, false, fa);
					case _:
						gl.uniformMatrix4fv(location, false, fa);
				}
			case _:
				switch [type, dim] {
					case [0, 1]:
						gl.uniform1fv(location, fa);
					case [0, 2]:
						gl.uniform2fv(location, fa);
					case [0, 3]:
						gl.uniform3fv(location, fa);
					case [0, 4]:
						gl.uniform4fv(location, fa);
					case [1, 1]:
						gl.uniform1iv(location, ia);
					case [1, 2]:
						gl.uniform2iv(location, ia);
					case [1, 3]:
						gl.uniform3iv(location, ia);
					case [1, 4]:
						gl.uniform4iv(location, ia);
					case [2, 1]:
						gl.uniform1uiv(location, ua);
					case [2, 2]:
						gl.uniform2uiv(location, ua);
					case [2, 3]:
						gl.uniform3uiv(location, ua);
					case _:
						gl.uniform4uiv(location, ua);
				}
		}
	}

	function getUniformLocation(name:String):UniformLocation {
		if (uniformLocationMap.exists(name)) {
			return uniformLocationMap.get(name);
		}
		final loc = program.getUniformLocation(name);
		uniformLocationMap.set(name, loc);
		return loc;
	}

	function disposeImpl():Void {
		program.dispose();
	}
}

private enum InternalUniformValue {
	Floats(dim:Int, vs:Float32Array);
	Ints(dim:Int, vs:Int32Array);
	UInts(dim:Int, vs:Uint32Array);
}
