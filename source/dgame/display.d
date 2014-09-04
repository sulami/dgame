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
    int width, height;
    uint bitsPerPixel;
    float fov, nearPlane, farPlane;
    int xpos, ypos;
    float hor, ver, speed, mspeed;
    vec3 camPos, viewPos, camUp;
    mat4 Perspective, View;
    GLuint VertexArrayID;
    SDL_Window *window;
    SDL_GLContext context;
    Program program;
    Entity entities[];

    debug {
        ulong fps = 0;
    }
    uint cur_time = 0, diff_time = 0, last_time = 0;

    this()
    {
        width = 1024;
        height = 768;
        bitsPerPixel = 24;
        fov = 45f;
        nearPlane = 0.1f;
        farPlane = 100.0f;
        hor = 3.14f;
        ver = 0f;
        speed = 10f;
        mspeed = 0.0005f;
        camPos = vec3(0f, 0f, 8f);
        viewPos = vec3(0f, 0f, 0f);
        camUp = vec3(0f, 1f, 0f);

        debug {
            writeln("Initializing display");
        }

        DerelictSDL2.load();
        DerelictGL3.load();

        setupSDL();
        DerelictGL3.reload();
        setupGL();
        setupShaders();

        debug {
            int major, minor;
            SDL_GL_GetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, &major);
            SDL_GL_GetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, &minor);
            writefln("Using OpenGL %s.%s", major, minor);
        }
    }

    private void setupSDL()
    {
        debug {
            writeln("Initializing SDL");
        }

        SDL_Init(SDL_INIT_VIDEO);

        SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, bitsPerPixel);

        debug {
            writeln("Creating window");
        }

        window = SDL_CreateWindow("DGame", SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED, width, height,
                                  SDL_WINDOW_OPENGL);
        debug {
            writeln("Creating context");
        }

        context = SDL_GL_CreateContext(window);
    }

    private void setupGL()
    {
        debug {
            writeln("Initializing OpenGL");
        }

        glEnable(GL_DEPTH_TEST);
        glDepthFunc(GL_LESS);

        glGenVertexArrays(1, &VertexArrayID);
        glBindVertexArray(VertexArrayID);
    }

    private void setupShaders()
    {
        debug {
            writeln("Initializing shaders");
        }

        Shader vertexShader = new Shader(GL_VERTEX_SHADER,
                                    /* "source/shaders/vertex_solid.glsl"); */
                                    "source/shaders/vertex_textured.glsl");
        Shader fragmentShader = new Shader(GL_FRAGMENT_SHADER,
                                    /* "source/shaders/fragment_solid.glsl"); */
                                    "source/shaders/fragment_textured.glsl");

        debug {
            writeln("Initializing program");
        }

        program = new Program();
        program.attachShader(vertexShader);
        program.attachShader(fragmentShader);
        program.link();
        program.use();
    }

    private void measureFPS()
    {
        cur_time = SDL_GetTicks();
        diff_time += cur_time - last_time;
        last_time = cur_time;
        debug {
            fps++;
            if (diff_time >= 1000) {
                diff_time -= 1000;
                writeln("FPS: ", fps);
                fps = 0;
            }
        }
    }

    void cleanup()
    {
        debug {
            writeln("Cleaning up");
        }

        SDL_Quit();
        DerelictGL3.unload();
        DerelictSDL2.unload();
    }

    void addEntity(Entity e)
    {
        entities ~= e;
    }

    void moveCamera()
    {
        SDL_GetMouseState(&xpos, &ypos);
        SDL_WarpMouseInWindow(window, width / 2, height / 2);

        hor += mspeed * ((width / 2) - xpos);
        ver += mspeed * ((height / 2) - ypos);
        viewPos = vec3(cos(ver) * sin(hor),
                       sin(ver),
                       cos(ver) * cos(hor));
    }

    void render()
    {
        measureFPS();

        Perspective = mat4.perspective(width, height, fov, nearPlane, farPlane);
        View = mat4.look_at(camPos, camPos + viewPos, camUp);

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        foreach (ent; entities)
            ent.render();

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
                    switch (event.key.keysym.sym) {
                        /* quit */
                        case SDLK_ESCAPE:
                        case SDLK_q:
                            return false;

                        /* movement */
                        case SDLK_w:
                            break;
                        case SDLK_a:
                            break;
                        case SDLK_s:
                            break;
                        case SDLK_d:
                            break;

                        default:
                            break;
                    }
                    break;

                case SDL_MOUSEMOTION:
                    moveCamera();
                    break;

                default:
                    break;
            }
        }

        return true;
    }
}

