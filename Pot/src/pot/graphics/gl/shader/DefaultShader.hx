package pot.graphics.gl.shader;

import hgsl.ShaderMain;
import hgsl.Global.*;
import hgsl.Types;

class DefaultShader extends ShaderMain {
	@attribute(0) var aPosition:Vec4;
	@attribute(1) var aColor:Vec4;
	@attribute(2) var aNormal:Vec3;
	@attribute(3) var aTexCoord:Vec2;

	@uniform var matrix:Matrix;
	@uniform var material:PhongMaterial;

	@uniform var numLights:Int;
	@uniform var lights:Array<Light, Consts.MAX_LIGHTS>;

	@varying var vColor:Vec4;
	@varying var vPosition:Vec3;
	@varying var vNormal:Vec3;
	@varying var vTexCoord:Vec2;

	@color var oColor:Vec4;

	function vertex():Void {
		gl_Position = matrix.transform * aPosition;
		gl_PointSize = 1;

		vColor = aColor;
		vPosition = (matrix.modelView * aPosition).xyz;
		vNormal = matrix.normal * aNormal;
		vTexCoord = aTexCoord;
	}

	function safeNormalize(v:Vec3):Vec3 {
		return dot(v, v) > 0 ? normalize(v) : vec3(0);
	}

	function computeBaseColor():Vec4 {
		return vColor;
	}

	function fragment():Void {
		final baseColor = computeBaseColor();
		if (baseColor.w == 0) {
			discard();
		}
		if (numLights == 0) {
			oColor = baseColor;
			return;
		}
		final eye = safeNormalize(vPosition);
		var n = safeNormalize(vNormal);
		if (!gl_FrontFacing) {
			n = -n;
		}
		var color = baseColor.xyz;
		var ambientTotal = vec3(0);
		var diffuseTotal = vec3(0);
		var specularTotal = vec3(0);
		var emissionTotal = color * material.emission;
		for (i in 0...numLights) {
			final light = lights[i];
			final lp = light.position;
			final lc = light.color;
			var ln = light.normal;
			final amb = lp.w == 0 && dot(ln, ln) == 0;
			if (amb) {
				ambientTotal += lc * color * material.ambient;
			} else {
				final dir = lp.w == 0;
				if (!dir) {
					ln = safeNormalize(vPosition - lp.xyz); // point light
				}
				final ldot = max(-dot(ln, n), 0);
				diffuseTotal += lc * color * ldot * material.diffuse;
				if (ldot > 0) {
					final reflEye = eye - 2 * n * dot(eye, n);
					final rdot = max(-dot(reflEye, ln), 0);
					specularTotal += lc * pow(rdot, material.shininess) * material.specular;
				}
			}
		}
		oColor = vec4(ambientTotal + diffuseTotal + specularTotal + emissionTotal, baseColor.w);
	}
}
