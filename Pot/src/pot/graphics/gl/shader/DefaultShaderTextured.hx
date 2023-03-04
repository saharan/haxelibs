package pot.graphics.gl.shader;

import hgsl.Global.*;
import hgsl.Types;

class DefaultShaderTextured extends DefaultShader {
	function computeBaseColor():Vec4 {
		return texture(material.texture, vTexCoord) * vColor;
	}
}
