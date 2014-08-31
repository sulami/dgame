import core.time;
import std.stdio;

import derelict.opengl3.gl3;

import display;

int main(string[] args)
{
    Display display = new Display();

    /* main loop */
    while (display.event()) {
        display.g_vertex_buffer_data = [ -1.0f, -1.0f,  0.0f,
                                          1.0f, -1.0f,  0.0f,
                                          0.0f,  1.0f,  0.0f ];

        glGenBuffers(1, &display.vertexbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, display.vertexbuffer);
        glBufferData(GL_ARRAY_BUFFER,
                     display.g_vertex_buffer_data.length * GLfloat.sizeof,
                     display.g_vertex_buffer_data.ptr, GL_STATIC_DRAW);

        display.render();
    }

    display.cleanup();

    return 0;
}

