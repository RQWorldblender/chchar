# Change Player Model (chchar), a mod for Minetest
Allows players to change the default character model for another one, optionally with different animations. While using this mod, skins for the default player model cannot be used unless it is switched back to. Basically a frontend to the built-in player_api mod shipping with Minetest Game.
Minetest 5.0.0 or later is required in order to use this mod. No backwards compatibility with older Minetest versions 0.4.16 and 0.4.17 is currently planned.
As a side bonus, it is possible to create models with collision boxes that are small enough to fit in one node wide tunnels or crevices, which the default player model cannot do.

## Installing models

### Manual addition

1) Copy your 3D model files to `models`. Only four formats will be accepted by Minetest:
    * Blitz3D (.b3d)
    * Quake2 models (.md2)
    * Maya/Wavefront (.obj)
    * Microsoft DirectX (.x)
2) Copy all the textures that each 3D model uses to `textures`.
3) Create `meta/<name>.txt` with the minimum following fields (separated by new lines):
    * Model Name
    * Textures
4) It is recommended to fill out the rest of these fields for optimal performance:
    * Animations
    * Collision Box
    * Eye Height

## License
Change Player Model code is licensed under the GNU GPL, version 3 (it is not yet known whether only under this version or including later ones, so assume only version 3 for now).

### Credits

* Most of this mod's source code is based from [skinsdb](https://github.com/minetest-mods/skinsdb), commit [8054293](https://github.com/minetest-mods/skinsdb/commit/8054293c2c7617c503fc1c15005f74f063e0e71f). As this code is licensed under the GNU GPLv3, the code here is also under that license.

* Some icons used originate from GTK 3.13.2, latest tagged versions at https://gitlab.gnome.org/GNOME/gtk/tree/3.13.2/gtk/stock-icons. As with the rest of that software, the icons used are licensed under the GNU LGPLv2+. They are:
  * 16/gtk-convert.*
  * 24/gtk-convert.svg
  * 24/image-missing.svg
