package pot.graphics.gl;

enum Attribute {
	Position(?location:Int);
	Color(?location:Int);
	Normal(?location:Int);
	TexCoord(?location:Int);
	Custom(buffer:VertexBuffer, location:Int, ?divisor:Int);
}
