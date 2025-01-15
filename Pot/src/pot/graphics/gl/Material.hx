package pot.graphics.gl;

class Material {
	public var shader:Shader = null;
	public final uniformMap:UniformMap = [];

	public function new(shader:Shader = null) {
		this.shader = shader;
	}

	public function copy():Material {
		final res = new Material(shader);
		for (key => value in uniformMap) {
			res.uniformMap[key] = value;
		}
		return res;
	}
}
