#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl> // Used to get the player's position.

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
#endif

uniform sampler2D Sampler0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif

out vec4 vertexColor;
out vec2 texCoord0;

#ifdef IS_GUI
// Do not modify this line.
const vec2 TOP = vec2(0.); const vec2 RIGHT = vec2(-1., 0.); const vec2 LEFT = vec2(0.); const vec2 BOTTOM = vec2(0., -1.); const vec2 MINIMAP_UV_OFFSETS[4] = vec2[](vec2(-0.5), vec2(-0.5, 0.5), vec2(0.5), vec2(0.5, -0.5)); const vec2 MINIMAP_POSITIONS[4] = vec2[](vec2(0.), vec2(0., 1.), vec2(1.), vec2(1., 0.));

// The size of your minimap texture file, in pixels.
const ivec2 MINIMAP_TEX_SIZE = ivec2(2048, 2048);

// The x and y padding and size of your minimap, measured in GUI pixels.
// 1 GUI pixel = [GUI scale] screen pixels.
// Align controls where the map appears.
const float MINIMAP_SIZE = 100.;
const vec2 MINIMAP_PADDING = vec2(20., 20.);
const vec2 MINIMAP_ALIGN = TOP + LEFT;

// The center block coordinates of your minimap.
const ivec2 MINIMAP_CENTER = ivec2(0, 0);
// The region, in blocks, that the minimap should show.
const float MINIMAP_SIZE_IN_BLOCKS = 64.;
// How many blocks each pixel on the texture represents.
// A value less than one zooms the map in.
const float MINIMAP_BLOCKS_PER_PIXEL = 1.;
#endif

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
#endif
    texCoord0 = UV0;

    // IF YOU ARE ADDING THIS TO AN EXISTING TEXT SHADER, START COPYING BELOW
    // PUT IT AT THE END OF YOUR MAIN FUNCTION

#ifdef IS_GUI
    if (textureSize(Sampler0, 0).rg == MINIMAP_TEX_SIZE) {
        // GUI pixel-space calculations
        vec2 position = MINIMAP_SIZE * (MINIMAP_ALIGN + MINIMAP_POSITIONS[gl_VertexID & 3]) + (MINIMAP_PADDING * sign(MINIMAP_ALIGN + 0.5));
        // to screen-space and align
        gl_Position = ProjMat * ModelViewMat * vec4(position, 0., 1.) + vec4(vec2(-2., 2.) * MINIMAP_ALIGN, 0., 0.);
        texCoord0 = (
                0.5 * MINIMAP_TEX_SIZE // center it
                + MINIMAP_BLOCKS_PER_PIXEL * (
                    CameraBlockPos.xz - CameraOffset.xz -MINIMAP_CENTER + // adjust camera pos
                    (MINIMAP_UV_OFFSETS[gl_VertexID & 3]) * MINIMAP_SIZE_IN_BLOCKS // per vertex
                )
        ) / MINIMAP_TEX_SIZE;
    }
#endif
}