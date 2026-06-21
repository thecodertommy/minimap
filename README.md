# 🗺️ minimap
Display a static arbitrary-sized texture as a minimap that updates automatically on the Minecraft client.
Works in 26.2 with only a resource pack!

## 🚀 features
- minimal disruption to vanilla and crazy compatibility
  - no forbidden text colors
  - vanilla maps aren't affected
  - works with sodium and iris
  - scales cleanly with the user's GUI
- easy to use
  - two files plus your own texture(s)
  - customizable constants
  - minimal server-side code; can be enabled with one command block
  - this readme is much longer than the actual code

## 💾 use it
1. in your resource pack, add `text.vsh` to `assets/minecraft/shaders/core`
2. add `text.fsh` (optional, it makes regions outside your texture transparent)
3. add your minimap texture anywhere in the textures folder
   - it can be any size EXCEPT 256x256 (conflicts with the game's atlases) or 64x64 (conflicts with normal player skins)
4. edit the constants in `rendertype_text.vsh` to match your minimap's size and settings
5. display the texture quite literally anywhere on the user's GUI
   - with JSON component: `{player:{texture:"minimap/my_minimap"},shadow_color:0}`
   - with kyori: `Component.object(ObjectContents.playerHead().texture(Key.key("minimap/my_minimap")).build())`
   - you can use a boss bar, action bar, scoreboard, or even tab (for a toggleable view)

### To add to an existing pack:
In `text.vsh`, add the `globals` import, copy the `const` definitions, and append the labeled section to the end of the main function.
When copying, include the surrounding `#ifdef IS_GUI` / `#endif` lines (unless you need to use it outside the GUI, I guess).

## 🛠️ customize it
Use shader constants to change some properties:
- set the center of the map
- set the size of the region the map shows
- set how many blocks each pixel represents
- change where the map is anchored and its distance from the corner

## 🤓 exercises for the reader
- add a frame
- change what renders outside the texture's bounds
- pass data in with color
- add markers
- make it a circular cutout
- encode data in the texture
- DO NOT attempt to make it rotate with the player. mojang HATES fun; we DO NOT have clean access to yaw