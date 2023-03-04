package pot.graphics.gl;

class Material {
	public var shader:Shader = null;
	public final uniformMap:UniformMap = [];

	public function new(shader:Shader = null) {
		this.shader = shader;
	}
}
