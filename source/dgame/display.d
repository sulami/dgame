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
    vec3 camPos, viewPos, camRight, camUp;
    mat4 Perspective, View;
    ubyte *kb;
    GLuint VertexArrayID, ViewMatrixID, TimeID, LightID;
    SDL_Window *window;
    SDL_GLContext context;
    Program program;
    Entity entities[];
    float cur_time, diff_time, last_time;

    this(int w, int h, float f)
    {
        width = w;
        height = h;
        bitsPerPixel = 24;
        fov = f;
        nearPlane = 0.1f;
        farPlane = 100.0f;
        hor = 3.14f;
        ver = 0f;
        speed = 10f;
        mspeed = 0.005f;
        camPos = vec3(0f, 0f, 8f);
        viewPos = vec3(cos(ver) * sin(hor), sin(ver), cos(ver) * cos(hor));
        camRight = vec3(sin(hor - 3.14/2f), 0, cos(hor - 3.14/2f));
        camUp = cross(camRight, viewPos);

        debug {
            writeln("Initializing display");
        }

        DerelictSDL2.load();
        DerelictGL3.load();

        setupSDL();
        DerelictGL3.reload();
        setupGL();
        setupShaders();

        TimeID = program.getUniformLocation("Time");
        ViewMatrixID = program.getUniformLocation("V");
        LightID = program.getUniformLocation("LightPosition_worldspace");

        SDL_ShowCursor(0);

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
        SDL_GL_SetAttribute(SDL_GL_MULTISAMPLEBUFFERS, 1);
        SDL_GL_SetAttribute(SDL_GL_MULTISAMPLESAMPLES, 4);
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
        glEnable(GL_CULL_FACE);

        glGenVertexArrays(1, &VertexArrayID);
        glBindVertexArray(VertexArrayID);
    }

    private void setupShaders()
    {
        debug {
            writeln("Initializing shaders");
        }

        Shader vertexShader = new Shader(GL_VERTEX_SHADER,
                                    "source/shaders/vertex.glsl");
        Shader fragmentShader = new Shader(GL_FRAGMENT_SHADER,
                                    "source/shaders/fragment.glsl");

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
        diff_time = (cur_time - last_time) / 1000f;
        last_time = cur_time;
        debug {
            writef("FPS: %.1f (%.3fms)\r", 1 / diff_time, diff_time);
        }
    }

    void cleanup()
    {
        debug {
            writeln("Cleaning up");
        }

        SDL_ShowCursor(1);

        SDL_Quit();
        DerelictGL3.unload();
        DerelictSDL2.unload();
    }

    void addEntity(Entity e)
    {
        entities ~= e;
    }

    void moveView()
    {
        SDL_GetMouseState(&xpos, &ypos);
        SDL_WarpMouseInWindow(window, width / 2, height / 2);

        hor += mspeed * ((width / 2) - xpos) / 10;
        ver += mspeed * ((height / 2) - ypos) / 10;
        viewPos = vec3(cos(ver) * sin(hor), sin(ver), cos(ver) * cos(hor));
        camRight = vec3(sin(hor - 3.14/2f), 0, cos(hor - 3.14/2f));
        camUp = cross(camRight, viewPos);
    }

    void render()
    {
        measureFPS();
        glUniform1f(TimeID, cur_time);

        Perspective = mat4.perspective(width, height, fov, nearPlane, farPlane);
        View = mat4.look_at(camPos, camPos + viewPos, camUp);
        glUniformMatrix4fv(ViewMatrixID, 1, GL_FALSE, &View[0][0]);

        vec3 lightPos = vec3(4f, 4f, 4f);
        glUniform3f(LightID, lightPos.x, lightPos.y, lightPos.z);

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

                        default:
                            break;
                    }
                    break;

                case SDL_MOUSEMOTION:
                    moveView();
                    break;

                default:
                    break;
            }
        }

        kb = SDL_GetKeyboardState(null);
        if (kb[SDL_SCANCODE_W])
            camPos += viewPos * diff_time * speed;
        if (kb[SDL_SCANCODE_S])
            camPos -= viewPos * diff_time * speed;
        if (kb[SDL_SCANCODE_A])
            camPos -= camRight * diff_time * speed;
        if (kb[SDL_SCANCODE_D])
            camPos += camRight * diff_time * speed;

        return true;
    }
}

