module texture;

import core.memory;
import std.mmfile;
import std.stdio;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

class Texture
{
    GLuint textureID;
    uint width, height;
    ulong size;

    this(string path)
    {
        /* auto f = new MmFile(path); */
        /* size = f.length; */

        /* auto tb = cast(char *)GC.malloc(size, 0); */
        /* if (tb is null) */
        /*     throw new Exception("Error allocating texture buffer"); */

        /* tb = cast(char *)f.opSlice(); */

        glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
        glGenTextures(1, &textureID);
        glBindTexture(GL_TEXTURE_2D, textureID);

        /* auto surface = SDL_LoadBMP(cast(char *)path); */
        auto surface = SDL_LoadBMP("/home/sulami/build/dgame/tex.bmp");
        writeln(surface);
        /* SDL_PixelFormat *format = surface.format; */

        /* glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_BGR, */
        /*              GL_UNSIGNED_BYTE, cast(void *)tb); */
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glGenerateMipmap(GL_TEXTURE_2D);
    }

    ~this()
    {
        /* GC.free(); */
    }
}

