uniform float time;

void main()
{
    gl_Position = glModelViewProjectionMatrix * gl_Vertex;
    gl_FrontColor = gl_Color * (0.5 + 0.5 * sin(time));
}

