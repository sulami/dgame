# DGame

Because I can't come up with a name.

Game-like 3D-rendering using D and OpenGL. It can load .obj-models from Blender
and texturize them. Lights are also included, as well as sample shaders and
keyboard/mouse input to move the camera around. Content-wise a tech-demo, but
could also be expanded to an actual game some day. Currently it is just
floating and rotating cubes to fly around and look at.

To build, just run it through `dub`.

It needs `SDL2` and `SDL2_image`, which you should be able to get through your
distribution's package manager.

What it looks like:

![An image tells more than a thousand words. Well, it's a gif.](http://i.imgur.com/rruhuV2.gif)
