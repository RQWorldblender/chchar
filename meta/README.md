For each model in "/models" folder a metadata file can be applied with "txt" suffix in "/meta". See character.txt for model character.b3d for reference. A '*' means an optional item.

The file contains:

- Model name

- Author*

- License*

- Animation Speed* - How many frames per second the animations play. Default: 30

- Textures - A list of all textures that the model uses. It is possible to leave this field blank, but the model will then not have an optimal appearance.

- Animations* - A list of animations that the model will use on certain actions. Each X and Y point are the starting and ending frames as set in the Blender timeline, respectively. Format for each item is {animation_name:start_frame,end_frame}; (without braces)

Standard animations:
stand     = {x = 0,   y = 79}
lay       = {x = 162, y = 166}
walk      = {x = 168, y = 187}
mine      = {x = 189, y = 198}
walk_mine = {x = 200, y = 219}
sit       = {x = 81,  y = 160}
Formatted version would be: stand:0,79;lay:162,166;walk:168,187;mine:189,198;walk_mine:200,219;sit:81,160

- Visual Size* - A list of 3 points in XYZ order. The Z axis is optional. It allows scaling of models to different sizes other than their original. If this is not specified, models will be displayed at their original size.

- Collision Box* - A list of 2 XYZ coordinates (6 points) in meters relative from the origin of the model. It creates a cube or prism depending on the location of the coordinates. Format is {X1,Y1,Z1,X2,Y2,Z2} Default: {-0.3,0.0,-0.3,0.3,1.7,0.3} (without braces)

- Stepheight* - How fast this model moves on the ground. Default: 0.6

- Eye height* - How far up the Y-axis in meters the camera will be, in 1st-person view. Default: 1.47
