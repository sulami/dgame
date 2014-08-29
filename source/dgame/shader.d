module shader;

import std.conv;
import std.file;
import std.stdio;

import derelict.opengl3.gl3;

class Shader
{
    GLuint shader = 0;

    ~this()
    {
        glDeleteShader(shader);
    }

    bool loadShader(GLenum type, string path)
    {
        try
        {
            string code = readText(path);
            const char *ptr = code.ptr;
            int len = to!int(code.length);

            shader = glCreateShader(type);
            glShaderSource(shader, 1 ,&ptr, &len);
            glCompileShader(shader);

            return true;
        }
        catch (Exception e)
        {
            writeln("Failed to load shader: \n", e);
            return false;
        }
    }
}

