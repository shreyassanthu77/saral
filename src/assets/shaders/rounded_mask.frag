#version 330

in vec2 fragTexCoord;      // Incoming texture coordinates
out vec4 fragColor;         // Output color of the pixel

uniform sampler2D texture0; // RenderTexture (content to be masked)
uniform vec2 resolution;    // Size of the rectangle (width, height)
uniform float radius;       // Border radius

void main() {
    // Map the fragment coordinate (0.0 - resolution) to the texture space (0.0 - 1.0)
    vec2 pos = fragTexCoord * resolution;

    // Compute distances from the current pixel to the closest rectangle edges
    float distX = min(pos.x, resolution.x - pos.x);
    float distY = min(pos.y, resolution.y - pos.y);

    // Check if the pixel is inside the rounded area
    float minDist = min(distX, distY);
    float cornerDist = length(vec2(max(0.0, radius - distX), max(0.0, radius - distY)));

    // Discard the fragment if it's outside the rounded area
    if (cornerDist > radius) {
        discard;
    }

    // Otherwise, draw the pixel from the original texture
    fragColor = texture(texture0, fragTexCoord);
}

