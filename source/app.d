import display;
import entity;
import texture;

int main(string[] args)
{
    Display display = new Display();

    Texture t = new Texture("wurfel.png");
    Texture t2 = new Texture("tex2.png");

    Entity cube = new Entity(display, t, "cube.obj");
    Entity cube2 = new Entity(display, t2, "cube.obj");

    cube2.move(0f,-2.1,0f);

    while (display.event()) {
        cube.rotate(0f, .05, 0f);
        cube2.rotate(0f, -.02, 0f);
        display.render();
    }

    display.cleanup();

    return 0;
}

