extends Node

# call deferred, because otherwise godot 4.2 complains
func nextLevel():
	call_deferred("nextLevelDeferred")

func nextLevelDeferred():
	get_tree().change_scene_to_file("res://Scenes/Level_" + str((get_tree().current_scene.name.to_int())+1)+ ".tscn")
