package pot.graphics.gl.shader;

import hgsl.ShaderStruct;
import hgsl.Types;

class PhongMaterial extends ShaderStruct {
	var ambient:Float;
	var diffuse:Float;
	var specular:Float;
	var shininess:Float;
	var emission:Float;
	var texture:Sampler2D;
}
