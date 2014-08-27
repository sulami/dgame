module sdl_render;

import derelict.sdl2.sdl;

class RenderRect
{
    /*
     * A simple rectangle class to manage rectangles drawn
     */

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
        this.render();
    }

    void render()
    {
        SDL_SetRenderDrawColor(this.renderer, this.r, this.g, this.b, this.a);
        SDL_Rect *rect = new SDL_Rect(this.x, this.y, this.w, this.h);
        SDL_RenderFillRect(this.renderer, rect);
    }

    void move(int x, int y)
    {
        this.x = x;
        this.y = y;
        this.render();
    }

    void resize(int w, int h)
    {
        this.w = w;
        this.h = h;
        this.render();
    }
}


