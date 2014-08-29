module program;

import std.string;

import derelict.opengl3.gl3;

import shader;

class Program
{
    GLuint program;

    this()
    {
        program = glCreateProgram();
    }

    ~this()
    {
        glDeleteProgram(program);
    }

    void attachShader(Shader shader)
    {
        glAttachShader(program, shader.shader);
    }

    void link()
    {
        glLinkProgram(program);
    }

    void use()
    {
        glUseProgram(program);
    }

    void useFixed()
    {
        glUseProgram(0);
    }

    GLint getUniformLocation(string name)
    {
        return glGetUniformLocation(program, toStringz(name));
    }
}

