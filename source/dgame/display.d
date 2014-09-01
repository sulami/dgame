module display;

import std.stdio;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;
import gl3n.linalg;

import entity;
import program;
import shader;

class Display
{
    uint height;
    uint width;
    uint bitsPerPixel;
    float fov, nearPlane, farPlane;
    vec3 camPos, viewPos, camUp;
    mat4 Perspective, View;
    GLuint VertexArrayID;
    SDL_Window *window;
    SDL_GLContext context;
    Program program;
    Entity entities[];

    /* fps stuff */
    ulong fps = 0;
    uint cur_time = 0, diff_time = 0, last_time = 0;

    this()
    {
        width = 800;
        height = 600;
        bitsPerPixel = 24;
        fov = 45;
        nearPlane = 0.1f;
        farPlane = 100.0f;
        camPos = vec3(4f, 2f, -8f);
        viewPos = vec3(0f, 0f, 0f);
        camUp = vec3(0f, 1f, 0f);

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
        SDL_Init(SDL_INIT_VIDEO);

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
        glEnable(GL_DEPTH_TEST);
        glDepthFunc(GL_LESS);

        glGenVertexArrays(1, &VertexArrayID);
        glBindVertexArray(VertexArrayID);
    }

    private void setupShaders()
    {
        Shader vertexShader = new Shader(GL_VERTEX_SHADER,
                                         "source/shader.vert");
        Shader fragmentShader = new Shader(GL_FRAGMENT_SHADER,
                                           "source/shader.frag");

        program = new Program();
        program.attachShader(vertexShader);
        program.attachShader(fragmentShader);
        program.link();
        program.use();
    }

    private void measureFPS()
    {
        fps++;
        cur_time = SDL_GetTicks();
        diff_time += cur_time - last_time;
        last_time = cur_time;
        if (diff_time >= 1000) {
            diff_time -= 1000;
            writeln("fps: ", fps);
            fps = 0;
        }
    }

    void cleanup()
    {
        SDL_Quit();
        DerelictGL3.unload();
        DerelictSDL2.unload();
    }

    void addEntity(Entity e)
    {
        entities ~= e;
    }

    void moveCamera(float x, float y, float z)
    {
        camPos += vec3(x, y, z);
    }

    void render()
    {
        Perspective = mat4.perspective(width, height, fov, nearPlane, farPlane);
        View = mat4.look_at(camPos, viewPos, camUp);

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        foreach (ent; entities)
            ent.render();

        SDL_GL_SwapWindow(window);

        measureFPS();
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

