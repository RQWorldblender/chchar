# Change Player Model, a mod for Minetest
Allows players to change the default character model for another one, optionally with different animations. While using this mod, skins for the default player model cannot be used unless it is switched back to. Basically a frontend to the built-in player_api mod shipping with Minetest Game.
Right now, this mod is in the planning and drafting stage. No code has been implemented yet.

## Directory structure of this mod
Note that the media formats represented here can be replaced by any format supported by the Irrlicht engine.

chchar
```
|-- init.lua (required) - Runs when the game loads.
|-- mod.conf (recommended) - Contains description and dependencies.
|-- models
|    |-- <model name> - code name of a model.
|        |-- model.ini - Information about this model, including name, costumes available, where to play animations, etc.
|        `-- costumes - Different versions of a model. Can contain alternate versions with different models, textures, and/or sounds.
|            |-- default - The default costume to load if no alternate versions of a model are available. 
|                |-- textures (optional)
|                |   `-- ... any textures or images for the default model.
|                |-- sounds (optional)
|                |   `-- ... any sounds for the default model.
|                |-- model.b3d/model.obj - Model file that will be rendered in-game by default.
|                `-- icon.png - Image representing this model overall.
|            |-- <costume name> - Name of an optional costume. It can also be represented by a number, where the ordering is based alphabetically \(a - 0 to z - 25\).
|                |-- textures (optional)
|                |   `-- ... any textures or images for the alternate version of this model.
|                |-- sounds (optional)
|                |   `-- ... any sounds for the alternate version of this model.
|                |-- model.b3d/model.obj - Model file that will be rendered in-game for this particular version.
|                `-- icon.png - Image representing the alternate version of this model.
|    |-- ... any other models can be added here
|-- textures - other images used in places such as formspecs. Not part of any model.
`-- ... any other files or directories
```
## Command Help
* /chchar \[model name\] \[costume name\] - If "default" is specified in place of <model name>, or /chchar is used by itself, it will load the default player model. If nothing is specified for <costume name>, the default costume for the specified model will load.
What happens during errors:
    * If no models are found in the models/ directory: Prints a message in its GUI and chat commands about this.
    * If an invalid model name or costume name is specified (chat command only): Prints an error telling the user about this.

* /chchargui - This command brings up the GUI. Useful in case if an inventory mod is not supported.

* /help chchar - Pulls up usage information on how to use /chchar.

## License
Change Player Model code is licensed under the GNU LGPL, version 3 or later.
