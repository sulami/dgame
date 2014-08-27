import std.stdio;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

import sdl_render;

int main(string[] args)
{
    /* load whatever we need */
    DerelictGL3.load();
    DerelictSDL2.load();

    const int ww = 800, wh = 600;

    /* create a window and a renderer to use */
    auto window = SDL_CreateWindow("DGame", SDL_WINDOWPOS_UNDEFINED,
                                   SDL_WINDOWPOS_UNDEFINED, ww, wh,
                                   SDL_WINDOW_OPENGL);
    auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

    /* draw some random objects */
    RenderRect rect = new RenderRect(renderer, 10, 10, 50, 50, 255, 0, 0, 255);
    RenderPoint point = new RenderPoint(renderer, 5, 5, 0, 255, 0, 255);
    RenderLine line = new RenderLine(renderer, 10, 10, 50, 50, 0, 0, 255, 255);

    /* do stuff until we kill the window */
    while (true) {
        SDL_Event e;
        if (SDL_PollEvent(&e))
            if (e.type == SDL_QUIT)
                break;

        /* clear the screen, i want it to be black */
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);

        /* rerender out object to keep them on the screen */
        rect.render();
        point.render();
        line.render();

        /* swap buffers */
        SDL_RenderPresent(renderer);

        /* wait a little bit before the next loop, we are bound to fps */
        SDL_Delay(10);
    }

    /* clean up */
    SDL_Quit();

    return 0;
}

