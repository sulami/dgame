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
    ubyte r, g, b, a;
    RenderObject objects[];

    this (const char *name, int x, int y, int w, int h, uint wflags,
          uint rflags, ubyte r, ubyte g, ubyte b, ubyte a)
    {
        this.w = w;
        this.h = h;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;

        this.win = SDL_CreateWindow(name, x >= 0 ? x : SDL_WINDOWPOS_UNDEFINED,
                                    y >= 0 ? y : SDL_WINDOWPOS_UNDEFINED, w, h,
                                    wflags);
        this.ren = SDL_CreateRenderer(this.win, -1, rflags);
    }

    void clear()
    {
        SDL_SetRenderDrawColor(this.ren, this.r, this.g, this.b, this.a);
        SDL_RenderClear(this.ren);
    }

    void clear(ubyte r, ubyte g, ubyte b, ubyte a)
    {
        SDL_SetRenderDrawColor(this.ren, r, g, b, a);
        SDL_RenderClear(this.ren);
    }

    void swap()
    {
        SDL_RenderPresent(this.ren);
    }

    void add(RenderObject obj)
    {
        this.objects ~= obj;
    }

    void render()
    {
        this.clear();
        foreach (obj; this.objects)
            obj.render();
        this.swap();
    }
}

class RenderObject
{
    /*
     * Base RenderObject class to inherit specific object types from
     * Currently manages object renderer and colour
     */

    ubyte r, g, b, a;
    RenderScreen scrn;

    this(RenderScreen scrn, ubyte r, ubyte g, ubyte b, ubyte a)
    {
        this.scrn = scrn;
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.scrn.add(this);
    }

    void render()
    {
        SDL_SetRenderDrawColor(this.scrn.ren, this.r, this.g, this.b, this.a);
    }
}

class RenderRect : RenderObject
{
    int x, y;
    uint w, h;

    this(RenderScreen scrn, int x, int y, uint w, uint h, ubyte r, ubyte g,
         ubyte b, ubyte a)
    {
        super(scrn, r, g, b, a);
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
        SDL_RenderFillRect(this.scrn.ren, rect);
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

    this(RenderScreen scrn, int x, int y, ubyte r, ubyte g, ubyte b, ubyte a)
    {
        super(scrn, r, g, b, a);
        this.x = x;
        this.y = y;
        this.render();
    }

    override void render()
    {
        super.render();
        SDL_RenderDrawPoint(this.scrn.ren, this.x, this.y);
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

    this(RenderScreen scrn, int x1, int y1, int x2, int y2, ubyte r, ubyte g,
         ubyte b, ubyte a)
    {
        super(scrn, r, g, b, a);
        this.x1 = x1;
        this.y1 = y1;
        this.x2 = x2;
        this.y2 = y2;
        this.render();
    }

    override void render()
    {
        super.render();
        SDL_RenderDrawLine(this.scrn.ren, this.x1, this.y1, this.x2, this.y2);
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

class RenderTexture
{
    SDL_Renderer *ren;
    SDL_Texture *tex;
    int w, h;

    this(SDL_Renderer *ren, uint format, int access, int w, int h)
    {
        this.ren = ren;
        this.w = w;
        this.h = h;
        this.tex = SDL_CreateTexture(this.ren, format, access, w, h);
    }
}

