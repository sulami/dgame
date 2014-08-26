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
                                   SDL_WINDOWPOS_UNDEFINED, 800, 600,
                                   SDL_WINDOW_OPENGL);
    auto renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

    /* clear the screen, i want it to be black */
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    /* draw some random rect */
    SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
    SDL_Rect *r = new SDL_Rect(10, 10, 100, 100);
    SDL_RenderFillRect(renderer, r);

    /* swap buffers */
    SDL_RenderPresent(renderer);

    /* wait briefly to inspect the results */
    SDL_Delay(1000);

    /* clean up */
    SDL_Quit();

    return 0;
}

