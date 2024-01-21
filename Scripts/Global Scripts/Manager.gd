extends Node

######### initialise variables #########

var player_is_dead: bool = false
# init mask settings
var player_layer: int = 1 << 0
var walls_layer: int = 1 << 1
var player_proj_layer: int = 1 << 2
var enemy_layer: int = 1 << 3
var enemy_proj_layer: int = 1 << 4


######### my functions #########

# call deferred, because otherwise godot 4.2 complains
func nextLevel():
	call_deferred("nextLevelDeferred")

# function to actually change the scene
# parses current level name
func nextLevelDeferred():
	# change the scene
	get_tree().change_scene_to_file(
		"res://Scenes/Levels/Level_" + 
		str((get_tree().current_scene.name.to_int())+1)+ ".tscn"
	)


######### Godot functions #########




######### Godot signal functions #########


