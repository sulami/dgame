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
    RenderPoint point = new RenderPoint(scrn, scrn.w / 2, scrn.h / 2, 0, 255,
                                        0, 255);

    ulong fps = 0;
    uint cur_time = 0, diff_time = 0, last_time = 0;

    /* start reacting to keyboard events */
    SDL_StartTextInput();

    /* do stuff until we kill the window */
    while (true) {
        SDL_Event e;
        if (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT)
                goto exit;
            if (e.type == SDL_KEYDOWN) {
                switch (e.key.keysym.sym) {

                    /* move the rect */
                    case SDLK_RIGHT:
                        rect.move(rect.x + 10, rect.y);
                        break;
                    case SDLK_LEFT:
                        rect.move(rect.x - 10, rect.y);
                        break;
                    case SDLK_UP:
                        rect.move(rect.x, rect.y - 10);
                        break;
                    case SDLK_DOWN:
                        rect.move(rect.x, rect.y + 10);
                        break;

                    /* quit */
                    case SDLK_ESCAPE:
                    case SDLK_q:
                        goto exit;
                    default:
                        break;
                }
            }
        }

        /* measure fps */
        fps++;
        cur_time = SDL_GetTicks();
        diff_time += cur_time - last_time;
        last_time = cur_time;
        if (diff_time >= 1000) {
            diff_time -= 1000;
            writeln("fps: ", fps);
            fps = 0;
        }

        /* clear the screen, re-render our objects and swap buffers */
        scrn.render();
    }

exit:
    /* clean up */
    SDL_Quit();

    return 0;
}

