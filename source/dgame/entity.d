module entity;

import derelict.opengl3.gl3;
import gl3n.linalg;

import display;

class Entity
{
    Display display;
    mat4 Model, MVP;
    GLuint MatrixID;
    GLuint vertexbuffer, colorbuffer;
    GLfloat g_vertex_buffer_data[];
    GLfloat g_color_buffer_data[];

    this(Display d, GLfloat vbuf[], GLfloat cbuf[])
    {
        display = d;

        MatrixID = display.program.getUniformLocation("MVP");
        Model = mat4.identity();

        g_vertex_buffer_data = vbuf;
        g_color_buffer_data = cbuf;

        glGenBuffers(1, &vertexbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glBufferData(GL_ARRAY_BUFFER,
                    g_vertex_buffer_data.length * GLfloat.sizeof,
                    g_vertex_buffer_data.ptr, GL_STATIC_DRAW);

        glGenBuffers(1, &colorbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, colorbuffer);

        d.addEntity(this);
    }

    void render()
    {
        glBufferData(GL_ARRAY_BUFFER,
                    g_color_buffer_data.length * GLfloat.sizeof,
                    g_color_buffer_data.ptr, GL_STATIC_DRAW);

        MVP = display.Perspective * display.View * Model;
        glUniformMatrix4fv(MatrixID, 1, GL_TRUE, &MVP[0][0]);

        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, cast(void *)0);

        glEnableVertexAttribArray(1);
        glBindBuffer(GL_ARRAY_BUFFER, colorbuffer);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 0, cast(void *)0);

        glDrawArrays(GL_TRIANGLES, 0, cast(int)g_vertex_buffer_data.length);

        glDisableVertexAttribArray(0);
        glDisableVertexAttribArray(1);
    }

    void rotate(float x, float y, float z)
    {
        Model.rotatex(x);
        Model.rotatey(y);
        Model.rotatez(z);
    }

    void move(float x, float y, float z)
    {
        Model.translate(x, y, z);
    }

    void scale(float x, float y, float z)
    {
        Model.scale(x, y, z);
    }

    ~this()
    {
        glDeleteBuffers(1, &vertexbuffer);
        glDeleteBuffers(1, &colorbuffer);
    }
}

