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
    auto renderer = SDL_CreateRenderer(window, -1, 0);
    auto context = SDL_GL_CreateContext(window);

    /* clear the screen, i want it to be black */
    glClearColor(0 ,0 ,0 ,1);
    glClear(GL_COLOR_BUFFER_BIT);

    /* draw some random rect */
    SDL_Rect *r = new SDL_Rect(0, 0, 10, 10);
    SDL_RenderFillRect(renderer, r);

    /* swap buffers */
    SDL_GL_SwapWindow(window);

    /* wait briefly to inspect the results */
    SDL_Delay(1000);

    /* clean up */
    SDL_Quit();

    return 0;
}

