import core.thread;
import std.stdio;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

int main(string[] args)
{
    /* load whatever we need */
    DerelictGL3.load();
    DerelictSDL2.load();

    /* create a window and a renderer to use */
    auto window = SDL_CreateWindow("DGame", SDL_WINDOWPOS_UNDEFINED,
                                   SDL_WINDOWPOS_UNDEFINED, 800, 600, 0);
    auto renderer = SDL_CreateRenderer(window, -1, 0);

    Thread.sleep(dur!("seconds")(5));

    DerelictGL3.reload();

    return 0;
}

