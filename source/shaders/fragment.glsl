#version 330 core

in vec2 UV;
in vec3 Position_worldspace;
in vec3 Normal_cameraspace;
in vec3 EyeDirection_cameraspace;
in vec3 LightDirection_cameraspace;

out vec3 color;

uniform float Time;
uniform sampler2D TextureSampler;
uniform mat4 MV;
uniform vec3 LightPosition_worldspace;

void main()
{
    vec3 LightColor = vec3(1.0, 1.0, 1.0);
    float LightPower = 50.0;
    vec3 AmbientLight = vec3(0.1, 0.1, 0.1);

    vec3 MaterialDiffuseColor = texture2D(TextureSampler, UV).rgb;
    vec3 MaterialAmbientColor = AmbientLight * MaterialDiffuseColor;

    float ldistance = distance(LightPosition_worldspace, Position_worldspace);

    vec3 n = normalize(Normal_cameraspace);
    vec3 l = normalize(LightDirection_cameraspace);
    float cosTheta = clamp(dot(n, l), 0.0, 1.0);

    color = MaterialAmbientColor

            + MaterialDiffuseColor * LightColor * LightPower * cosTheta
            / (ldistance * ldistance);
}

