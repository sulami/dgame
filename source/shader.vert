#version 330 core

layout(location = 0) in vec3 vertexPosition_modelspace;

uniform mat4 TMatrix;

void main()
{
    gl_Position = TMatrix * vec4(vertexPosition_modelspace,1.0);
}

