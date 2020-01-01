# Change Player Model (chchar) Application Programming Interface (API)

## chchar.get_player_model(player)
Return the model object assigned to the player. Returns default if nothing assigned.

## chchar.assign_player_model(player, model)
Check if allowed and assign the model for the player without visual updates. The "model" parameter could be the model key or the model object.
Returns false if model is not valid or applicable to player.

## chchar.update_player_model(player)
Update selected model visuals on player.

## chchar.set_player_model(player, model)
Function for external usage on model selection. This function assigns the model, calls the model:set_model(player) hook to update dynamic models, then update the visuals.

## chchar.get_modellist_for_player(playername)
Get all allowed models for player. All public and all player's private models. If playername not given only public models returned.

## chchar.get_modellist_with_meta(key, value)
Get all models with metadata key is set to value. Example:
chchar.get_modellist_with_meta("playername", playername) - Get all private models (w.o. public) for playername.


## chchar.new(key, object)
Create and register a new model object for given key.
  - key: Unique models key, like "character_1"
  - object: Optional. Could be a prepared object with redefinitions

## chchar.get(key)
Get existing model object.

HINT: During build-up phase maybe the next statement is useful.
```
local model = chchar.get(name) or chchar.new(name)
```


# Model object

## model:get_key()
Get the unique model key.

## model:set_texture(texture)
Set the list of textures used by the 3D model - usually at the init time only.

## model:get_texture()
Get the list of textures used by the 3D model for any reason. Note to apply them the model:set_model() should be used.

## model:set_icon(texture)
Set the model icon - usually at the init time only.

## model:get_icon()
Get the model icon.

It is currently not possible to draw arbitrary 3D models in formspecs, except for when drawing nodes in inventory slots. An icon is the best alternative to this.

## model:set_model(player)
Hook for dynamic models updates on select. Is called in chchar.set_player_model()
In chchar the default implementation for this function is empty.

model:apply_model_to_player(player)
Apply the model to the player. Called in chchar.update_player_model() to update visuals.

## model:set_meta(key, value)
Add a meta information to the model object.

Note: the information is not stored, therefore should be filled each time during models registration.

## model:get_meta(key)
The next metadata keys are filled or/and used interally in chchar framework, some of which are optional. These optional items are denoted with '*'.
  - name - A name for the 3D model
  - author* - The model author
  - license* - The model license
  - animation_speed* - How many frames per second the animations play. Default: 30
  - textures - A list of all textures that the model uses. It is possible to leave this field blank, but the model will then not have an optimal appearance.
  - animations* - A list of animations that the model will use on certain actions.
  - collisionbox* - A list of 2 XYZ coordinates (6 points) in meters relative from the origin of the model.
  - stepheight* - How fast this model moves on the ground. Default: 0.6
  - eye_height* - How far up the Y-axis in meters the camera will be, in 1st-person view. Default: 1.47
  - playername* - Player assignment for private model. Set false for models not usable by all players (like NPC-models), true or nothing for all player models
  - in_inventory_list* - If set to false the model is not visible in inventory models selection but can be still applied to the player
  - _sort_id - The model lists are sorted by this field for output (internal key)

## model:get_meta_string(key)
Same as get_meta() but does return "" instead of nil if the meta key does not exists

## model:is_applicable_for_player(playername)
Returns whether this model is applicable for player "playername" or not, like private models
