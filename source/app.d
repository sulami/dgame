import std.stdio;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

class RenderRect
{
    int x, y;
    uint w, h;
    ubyte r, g, b, a;
    SDL_Renderer *renderer;

    this(SDL_Renderer *renderer, int x, int y, uint w, uint h, ubyte r,
         ubyte g, ubyte b, ubyte a)
    {
        this.renderer = renderer;
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;

        SDL_SetRenderDrawColor(this.renderer, this.r, this.g, this.b, this.a);
        SDL_Rect *rect = new SDL_Rect(this.x, this.y, this.w, this.h);
        SDL_RenderFillRect(this.renderer, rect);
    }

    void move(int x, int y)
    {
        this.x = x;
        this.y = y;

        SDL_SetRenderDrawColor(this.renderer, this.r, this.g, this.b, this.a);
        SDL_Rect *rect = new SDL_Rect(this.x, this.y, this.w, this.h);
        SDL_RenderFillRect(this.renderer, rect);
    }
}

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

    RenderRect rect = new RenderRect(renderer, 10, 10, 50, 50, 255, 0, 0,
                                        255);

    /* do stuff until we kill the window */
    while (true) {
        SDL_Event e;
        if (SDL_PollEvent(&e))
            if (e.type == SDL_QUIT)
                break;

        /* clear the screen, i want it to be black */
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_RenderClear(renderer);

        /* draw some random rect */
        rect.move(rect.x + 1, rect.y + 1);

        /* swap buffers */
        SDL_RenderPresent(renderer);

        /* wait a little bit before the next loop, we are bound to fps */
        SDL_Delay(10);
    }

    /* clean up */
    SDL_Quit();

    return 0;
}

