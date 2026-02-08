# 🗺️ minimap
Minecraft minimap using core shaders. Works in 1.21.11 with only a resource pack!

# 🚀 features
- minimal disruption to vanilla and crazy compatibility
  - no forbidden text colors
  - maps work fine
  - works with sodium and iris
  - scales cleanly with the user's GUI
- easy to use
  - two files plus your own texture(s)
  - customizable constants
  - minimal server-side code; can be enabled with one command block
  - this readme is several times longer than the actual code

# 💾 use it
1. in your resource pack, add `rendertype_text.vsh` to `assets/minecraft/shader/core`
   - if you already have this shader, copy all `const` declarations, the `#moj_import <minecraft:globals.glsl>`, and the part that screams at you to copy it
2. add `rendertype_text.fsh`
   - if you already have this shader, add this to the end of the main function: `fragColor.a = (1 - abs(sign(texCoord0.x - clamp(texCoord0.x, 0, 1)))) * (1 - abs(sign(texCoord0.y - clamp(texCoord0.y, 0, 1))));`
   - this just makes regions outside your texture transparent
3. add your minimap texture anywhere in the textures folder
   - it can be any size EXCEPT 256x256 (this conflicts with the game's font atlases)
4. edit the constants in `rendertype_text.vsh` to match your minimap's size and settings
5. display the texture quite literally anywhere on the user's GUI
   - with JSON component: `{player:{texture:"minimaps/my_minimap"},shadow_color:0}`
   - with kyori: `Component.object(ObjectContents.playerHead().texture(Key.key("minimap/my_minimap")).build())`
   - you can use a boss bar, action bar, scoreboard, or even tab (for a toggleable view)

# 🛠️ customize it
Use shader constants to change some properties:
- set the center of the map
- set the size of the region the map shows
- set how many blocks each pixel represents
- change where the map is anchored and its distance from the corner

# 🤓 exercises for the reader
- add a frame
- change what renders outside the texture's bounds
- pass data in with color
- add markers
- make it a circular cutout
- encode data in the texture
- DO NOT attempt to make it rotate with the player. mojang HATES fun; we DO NOT have clean access to yaw