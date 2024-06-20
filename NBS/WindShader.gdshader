shader_type canvas_item;
uniform float speed = 1.5;
uniform float dist = 10.0;

void vertex()
{
	VERTEX.x += (sin(TIME * speed) - 1.0) * dist * (UV.y - 1.0);
}