module entity;

import std.stdio;
import std.string;

import derelict.opengl3.gl3;
import gl3n.linalg;

import display;
import texture;

class Entity
{
    Display display;
    mat4 Model, MVP;
    GLuint MatrixID;
    GLuint vertexbuffer, uvbuffer;
    Texture texture;
    vec3 vertexBuffer[];
    vec2 uvBuffer[];
    vec3 normalBuffer[];

    this(Display d, Texture t, string path)
    {
        loadObj(path);

        display = d;

        MatrixID = display.program.getUniformLocation("MVP");
        Model = mat4.identity();

        texture = t;

        glGenBuffers(1, &vertexbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glBufferData(GL_ARRAY_BUFFER,
                     vertexBuffer.length * vec3.sizeof,
                     vertexBuffer.ptr, GL_STATIC_DRAW);

        glGenBuffers(1, &uvbuffer);
        glBindBuffer(GL_ARRAY_BUFFER, uvbuffer);

        d.addEntity(this);
    }

    private void loadObj(string path)
    {
        debug {
            writeln("Loading obj file " ~ path);
        }

        string text[];
        uint vertexIndices[];
        uint uvIndices[];
        uint normalIndices[];
        vec3 tmp_vertices[];
        vec2 tmp_uvs[];
        vec3 tmp_normals[];

        File obj = File(path, "r");
        while (!obj.eof())
            text ~= chomp(obj.readln());
        obj.close();

        for (int i = 0; i < text.length; i++) {
            string l[] = text[i].split(" ");

            if (l.length == 0)
                continue;

            switch (l[0]) {
                case "v":
                    tmp_vertices ~= vec3(to!float(l[1]), to!float(l[2]),
                                         to!float(l[3]));
                    break;
                case "vt":
                    tmp_uvs ~= vec2(to!float(l[1]), to!float(l[2]));
                    break;
                case "vn":
                    tmp_normals ~= vec3(to!float(l[1]), to!float(l[2]),
                                        to!float(l[3]));
                    break;
                case "f":
                    foreach (set; l[1..4]) {
                        string tup[3] = set.split("/");
                        vertexIndices ~= to!uint(tup[0]);
                        uvIndices ~= to!uint(tup[1]);
                        normalIndices ~= to!uint(tup[2]);
                    }
                    break;
                default:
                    break;
            }
        }

        for (int i = 0; i < vertexIndices.length; i++) {
            uint vertexIndex = vertexIndices[i];
            uint uvIndex = uvIndices[i];
            uint normalIndex = normalIndices[i];

            vertexBuffer ~= tmp_vertices[vertexIndex - 1];
            uvBuffer ~= tmp_uvs[uvIndex - 1];
            normalBuffer ~= tmp_normals[normalIndex - 1];
        }
    }

    void render()
    {
        glBufferData(GL_ARRAY_BUFFER,
                     uvBuffer.length * vec2.sizeof,
                     uvBuffer.ptr, GL_STATIC_DRAW);

        MVP = display.Perspective * display.View * Model;
        glUniformMatrix4fv(MatrixID, 1, GL_TRUE, &MVP[0][0]);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texture.textureID);
        glUniform1i(texture.textureID, 0);

        glEnableVertexAttribArray(0);
        glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, cast(void *)0);

        glEnableVertexAttribArray(1);
        glBindBuffer(GL_ARRAY_BUFFER, uvbuffer);
        glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, cast(void *)0);

        glDrawArrays(GL_TRIANGLES, 0, cast(int)vertexBuffer.length);

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
        glDeleteBuffers(1, &uvbuffer);
    }
}

