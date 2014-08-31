import derelict.opengl3.gl3;
import gl3n.linalg;

import display;

alias Matrix!(float, 4, 4) mat4;

int main(string[] args)
{
    Display display = new Display();

    GLuint MatrixID = display.program.getUniformLocation("TMatrix");

    mat4 Model = mat4.identity();
    mat4 Translation = mat4.identity();
    Translation.scale(.3f, .3f, 1f);
    mat4 TMatrix = Translation * Model;

    display.g_vertex_buffer_data = [ -1.0f, -1.0f,  0.0f,
                                      1.0f, -1.0f,  0.0f,
                                      0.0f,  1.0f,  0.0f ];
    glBufferData(GL_ARRAY_BUFFER,
                    display.g_vertex_buffer_data.length * GLfloat.sizeof,
                    display.g_vertex_buffer_data.ptr, GL_STATIC_DRAW);


    /* main loop */
    while (display.event()) {
        TMatrix = TMatrix.rotatez(.02f);
        glUniformMatrix4fv(MatrixID, 1, GL_FALSE, &TMatrix[0][0]);
        display.render();
    }

    display.cleanup();

    return 0;
}

