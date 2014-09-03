module shader;

import std.conv;
import std.file;
import std.stdio;
import std.string;

import derelict.opengl3.gl3;

class Shader
{
    GLuint shader;

    this(GLenum type, string path)
    {
        debug {
            writefln("Loading shader %s...", path);
        }

        string code = readText(path);
        const char *ptr = code.ptr;
        int len = to!int(code.length);

        debug {
            writefln("Compiling shader %s...", path);
        }

        shader = glCreateShader(type);
        glShaderSource(shader, 1 ,&ptr, &len);
        glCompileShader(shader);

        int result;
        glGetShaderiv(shader, GL_COMPILE_STATUS, &result);
        if (!result)
            throw new Exception("Failed to compile shader " ~ path);
    }

    ~this()
    {
        glDeleteShader(shader);
    }
}

