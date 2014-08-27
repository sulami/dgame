import std.stdio;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

import sdl_render;

int main(string[] args)
{
    /* load whatever we need */
    DerelictGL3.load();
    DerelictSDL2.load();

    /* create a window and a renderer to use */
    RenderScreen scr = new RenderScreen("DGame", -1, -1, 800, 600,
                                        SDL_WINDOW_OPENGL,
                                        SDL_RENDERER_ACCELERATED,
                                        0, 0, 0, 255);

    /* draw some random objects */
    RenderRect rect = new RenderRect(scr.ren, 10, 10, 50, 50, 255, 0, 0, 255);
    RenderPoint point = new RenderPoint(scr.ren, 5, 5, 0, 255, 0, 255);
    RenderLine line = new RenderLine(scr.ren, 10, 10, 50, 50, 0, 0, 255, 255);

    /* do stuff until we kill the window */
    while (true) {
        SDL_Event e;
        if (SDL_PollEvent(&e))
            if (e.type == SDL_QUIT)
                break;

        /* clear the screen, i want it to be black */
        scr.clear();

        /* rerender our objects to keep them on the screen */
        rect.render();
        point.render();
        line.render();

        /* swap buffers */
        scr.swap();

        /* wait a little bit before the next loop, we are bound to fps */
        SDL_Delay(10);
    }

    /* clean up */
    SDL_Quit();

    return 0;
}

