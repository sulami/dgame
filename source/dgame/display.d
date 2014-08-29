module display;

import derelict.sdl2.sdl;
import derelict.opengl3.gl3;
import derelict.opengl3.gl;

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
        setupShaders();
    }

    private void setupSDL()
    {
        SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, bitsPerPixel);

        SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER);

        window = SDL_CreateWindow("DGame", SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED, width, height,
                                  SDL_WINDOW_OPENGL);
        context = SDL_GL_CreateContext(window);
    }

    private void setupGL()
    {
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

        /* crash time... */
        /* glBegin(GL_TRIANGLES); */
        /* glColor3f (1, 0, 0); */
        /* glVertex3f(-1, -1, -2); */
        /* glColor3f (0, 1, 0); */
        /* glVertex3f(1, -1, -2); */
        /* glColor3f (0, 0, 1); */
        /* glVertex3f(0, 1, -2); */
        /* glEnd(); */

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

