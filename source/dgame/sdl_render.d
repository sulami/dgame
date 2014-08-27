module sdl_render;

import derelict.sdl2.sdl;

class RenderScreen
{
    /*
     * Screen composite class to manage all window/renderer global stuff and
     * enable easy access to properties
     */

    SDL_Window *win;
    SDL_Renderer *ren;
    int w, h;

    this (const char *name, int x, int y, int w, int h, uint wflags,
          uint rflags)
    {
        this.w = w;
        this.h = h;
        this.win = SDL_CreateWindow(name, x >= 0 ? x : SDL_WINDOWPOS_UNDEFINED,
                                    y >= 0 ? y : SDL_WINDOWPOS_UNDEFINED, w, h,
                                    wflags);
        this.ren = SDL_CreateRenderer(this.win, -1, rflags);
    }
}

class RenderObject
{
    /*
     * Base RenderObject class to inherit specific object types from
     * Currently manages object renderer and colour
     */

    ubyte r, g, b, a;
    SDL_Renderer *renderer;

    this(SDL_Renderer *renderer, ubyte r, ubyte g, ubyte b, ubyte a)
    {
        this.renderer = renderer;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
    }

    void render()
    {
        SDL_SetRenderDrawColor(this.renderer, this.r, this.g, this.b, this.a);
    }
}

class RenderRect : RenderObject
{
    int x, y;
    uint w, h;

    this(SDL_Renderer *renderer, int x, int y, uint w, uint h, ubyte r,
         ubyte g, ubyte b, ubyte a)
    {
        super(renderer, r, g, b, a);
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.render();
    }

    override void render()
    {
        super.render();
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

class RenderPoint : RenderObject
{
    int x, y;

    this(SDL_Renderer *renderer, int x, int y, ubyte r, ubyte g, ubyte b,
         ubyte a)
    {
        super(renderer, r, g, b, a);
        this.x = x;
        this.y = y;
        this.render();
    }

    override void render()
    {
        super.render();
        SDL_RenderDrawPoint(this.renderer, this.x, this.y);
    }

    void move(int x, int y)
    {
        this.x = x;
        this.y = y;
        this.render();
    }
}

class RenderLine : RenderObject
{

    int x1, y1, x2, y2;

    this(SDL_Renderer *renderer, int x1, int y1, int x2, int y2, ubyte r,
         ubyte g, ubyte b, ubyte a)
    {
        super(renderer, r, g, b, a);
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
        this.render();
    }

    override void render()
    {
        super.render();
        SDL_RenderDrawLine(this.renderer, this.x1, this.y1, this.x2, this.y2);
    }

    void move(int x1, int y1, int x2, int y2)
    {
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
        this.render();
    }
}

