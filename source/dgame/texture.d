module texture;

import core.memory;
import std.mmfile;
import std.stdio;
import std.string;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

class Texture
{
    GLuint textureID;
    GLsizei width, height;
    GLint internal_format;
    GLenum format, type;
    void *data;

    this(string path)
    {
        debug {
            writeln("Loading texture ", path);
        }

        DerelictSDL2Image.load();

        SDL_Surface *flip(SDL_Surface *surface) {
            SDL_Surface *result = SDL_CreateRGBSurface(surface.flags,
                    surface.w, surface.h, surface.format.BytesPerPixel * 8,
                    surface.format.Rmask, surface.format.Gmask,
                    surface.format.Bmask, surface.format.Amask);

            ubyte *pixels = cast(ubyte *)surface.pixels;
            ubyte *rpixels = cast(ubyte *)result.pixels;
            uint pitch = surface.pitch;
            uint pxlength = pitch * surface.h;

            assert(result != null);

            for(uint line = 0; line < surface.h; ++line) {
                uint pos = line * pitch;
                rpixels[pos..pos + pitch] = pixels[(pxlength-pos) - pitch
                                                    ..pxlength - pos];
            }

            return result;
        }

        glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
        glGenTextures(1, &textureID);
        glBindTexture(GL_TEXTURE_2D, textureID);

        auto surface = IMG_Load(path.toStringz());

        if (surface.format.BytesPerPixel == 3)
            internal_format = format = GL_RGB;
        else if (surface.format.BytesPerPixel == 4)
            internal_format = format = GL_RGBA;
        else
            throw new Exception("Pixel format not supported: ", path);


        auto flipped = flip(surface);

        data = flipped.pixels;
        width = surface.w;
        height= surface.h;

        glTexImage2D(GL_TEXTURE_2D, 0, internal_format, width, height, 0,
                     format, GL_UNSIGNED_BYTE, data);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glGenerateMipmap(GL_TEXTURE_2D);

        SDL_FreeSurface(flipped);
    }
}

