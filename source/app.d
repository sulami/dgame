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
    RenderScreen scrn = new RenderScreen("DGame", -1, -1, 800, 600,
                                        SDL_WINDOW_OPENGL,
                                        SDL_RENDERER_ACCELERATED,
                                        0, 0, 0, 255);

    /* draw some random objects */
    RenderRect rect = new RenderRect(scrn, 10, 10, 50, 50, 255, 0, 0, 255);
    RenderPoint point = new RenderPoint(scrn, 5, 5, 0, 255, 0, 255);
    RenderLine line = new RenderLine(scrn, 10, 10, 50, 50, 0, 0, 255, 255);

    /* do stuff until we kill the window */
    while (true) {
        SDL_Event e;
        if (SDL_PollEvent(&e))
            if (e.type == SDL_QUIT)
                break;

        /* move the rect */
        rect.move(rect.x + 1, rect.y + 1);

        /* clear the screen, re-render our objects and swap buffers */
        scrn.render();

        /* wait a little bit before the next loop, we are bound to fps */
        SDL_Delay(10);
    }

    /* clean up */
    SDL_Quit();

    return 0;
}

