import display;
import entity;

int main(string[] args)
{
    Display display = new Display(1024, 768, 45);

    Entity cube = new Entity(display, "cube.obj", "wurfel.png");
    Entity cube2 = new Entity(display, "cube.obj", "tex2.png");

    cube2.move(0f,-2.1,0f);

    while (display.event()) {
        cube.rotate(0f, .05, 0f);
        cube2.rotate(0f, -.02, 0f);
        display.render();
    }

    display.cleanup();

    return 0;
}

