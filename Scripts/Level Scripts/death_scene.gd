extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




##############Signal Functions
func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/main_scene.tscn")


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")
