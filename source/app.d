import core.time;
import std.stdio;

import derelict.opengl3.gl3;
import derelict.sdl2.sdl;

import display;

int main(string[] args)
{

    /* fps stuff */
    ulong fps = 0;
    uint cur_time = 0, diff_time = 0, last_time = 0;

    /* start reacting to keyboard events */
    /* SDL_StartTextInput(); */

    Display display = new Display();

    TickDuration lastTime = TickDuration.currSystemTick();
    TickDuration newTime, dt;

    /* do stuff until we kill the window */
    while (display.event()) {
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

        newTime = TickDuration.currSystemTick();
        dt = newTime - lastTime;
        lastTime = newTime;
        display.update(dt.length / cast(double)TickDuration.ticksPerSec);
        display.render();
    }

    display.cleanup();

    return 0;
}

