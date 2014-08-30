module display;

import std.math;
import std.stdio;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;

import program;
import shader;

class Display
{
    uint height;
    uint width;
    uint bitsPerPixel;
    float fov;
    float nearPlane;
    float farPlane;
    SDL_Window *window;
    SDL_GLContext context;
    Program program;
    GLint timeLoc;
    double time;
    GLuint VertexArrayID;
    GLuint vertexbuffer;
    GLfloat g_vertex_buffer_data[];

    this()
    {
        width = 800;
        height = 600;
        bitsPerPixel = 24;
        fov = 90;
        nearPlane = 0.1f;
        farPlane = 100.0f;
        time = 0;

        DerelictSDL2.load();
        DerelictGL3.load();

        setupSDL();
        DerelictGL3.reload();
        setupGL();
        setupShaders();

        /* DEBUG */
        int major, minor;
        SDL_GL_GetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, &major);
        SDL_GL_GetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, &minor);
        writefln("Using OpenGL %s.%s", major, minor);
    }

    private void setupSDL()
    {

        SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER);

        SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, bitsPerPixel);

        window = SDL_CreateWindow("DGame", SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED, width, height,
                                  SDL_WINDOW_OPENGL);
        context = SDL_GL_CreateContext(window);
    }

    private void setupGL()
    {
        glGenVertexArrays(1, &VertexArrayID);
        glBindVertexArray(VertexArrayID);

        g_vertex_buffer_data = [ -1.0f, -1.0f,  0.0f,
                                  1.0f, -1.0f,  0.0f,
                                  0.0f,  1.0f,  0.0f ];

        glGenBuffers(1, &vertexbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glBufferData(GL_ARRAY_BUFFER,
                     g_vertex_buffer_data.length * float.sizeof,
                     g_vertex_buffer_data.ptr, GL_STATIC_DRAW);
    }

    private void setupShaders()
    {
        Shader vertexShader = new Shader();
        vertexShader.loadShader(GL_VERTEX_SHADER, "source/shader.vert");

        Shader fragmentShader = new Shader();
        fragmentShader.loadShader(GL_FRAGMENT_SHADER, "source/shader.frag");

        program = new Program();
        program.attachShader(vertexShader);
        program.attachShader(fragmentShader);
        program.link();
        program.use();

        timeLoc = program.getUniformLocation("time");
    }

    static void cleanup()
    {
        SDL_Quit();
        DerelictGL3.unload();
        DerelictSDL2.unload();
    }

    void update(double dt)
    {
        time += dt;
        glUniform1f(timeLoc, time);
    }

    void render()
    {
        glClear(GL_COLOR_BUFFER_BIT);

        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, cast(void *)0);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        glDisableVertexAttribArray(0);

        SDL_GL_SwapWindow(window);
    }

    bool event()
    {
        SDL_Event event;
        while (SDL_PollEvent(&event)){
            switch (event.type)
            {
                case SDL_QUIT:
                    return false;

                case SDL_KEYDOWN:
                    if (event.key.keysym.sym == SDLK_q)
                        return false;
                    break;

                default:
                    break;
            }
        }

        return true;
    }
}

