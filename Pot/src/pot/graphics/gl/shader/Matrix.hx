package pot.graphics.gl.shader;

import hgsl.ShaderStruct;
import hgsl.Types;

class Matrix extends ShaderStruct {
	var transform:Mat4;
	var model:Mat4;
	var view:Mat4;
	var projection:Mat4;
	var invProjection:Mat4;
	var modelView:Mat4;
	var invModelView:Mat4;
	var normal:Mat3;
}
