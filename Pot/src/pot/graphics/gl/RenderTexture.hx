package pot.graphics.gl;

class RenderTexture {
	final g:Graphics;
	final numTextures:Int;
	final textures:Array<Array<Texture>> = [[], []];
	final fbs:Array<FrameBuffer> = [];
	var srcIndex:Int = 0;

	public var data(get, never):Array<Texture>;

	function get_data():Array<Texture> {
		return textures[srcIndex];
	}

	public function new(g:Graphics, width:Int, height:Int, format:TextureFormat = RGBA, type:TextureType,
			numTextures:Int = 1, filter:TextureFilter = Nearest) {
		this.g = g;
		this.numTextures = numTextures;
		for (i in 0...numTextures) {
			final t0 = g.createTexture(width, height, format, type);
			final t1 = g.createTexture(width, height, format, type);
			t0.filter(filter);
			t1.filter(filter);
			textures[0].push(t0);
			textures[1].push(t1);
		}
		fbs.push(g.createFrameBuffer(textures[0]));
		fbs.push(g.createFrameBuffer(textures[1]));
	}

	overload extern public inline function render(f:() -> Void, flipBuffer:Bool = true):Void {
		g.renderingTo(fbs[srcIndex ^ 1], () -> {
			g.inScene(f);
		});
		if (flipBuffer)
			srcIndex ^= 1;
	}

	overload extern public inline function render(flipBuffer:Bool = true):Void {
		render(() -> {
			g.clear(0);
			g.fullScreenRect();
		}, flipBuffer);
	}

	public function dispose():Void {
		for (i in 0...numTextures) {
			textures[0][i].dispose();
			textures[1][i].dispose();
		}
		fbs[0].dispose();
		fbs[1].dispose();
	}
}
