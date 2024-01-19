extends Node

######### initialise variables #########




######### my functions #########




######### Godot functions #########

func _ready():
	# respawn player 
	Manager.player_is_dead = false


######### Godot signal functions #########

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Level_1.tscn")

