extends Area2D

# we will emit signal instead to decouple
signal next_level

#When player hits the door (this node), we simply change the scene using this
#simple function.
# It parses the current scene name and then uses some conversions and + 1 
#to change to the next scene
# This means that all level scenes will need to be changed to:
#Level_(level number)
# This is a quick and easy way to do this

# Called when the node enters the scene tree for the first time.
func _on_Hitbox_area_entered(area:Area2D)-> void:
#	return 
	if area.is_in_group("Player"):
		#get_tree().change_scene_to_file("res://Scenes/Level_" + str(int(get_tree().current_scene.name)+1)+ ".tscn")
		print("next level")



func _on_body_entered(body):
	if body.is_in_group("player"):
		next_level.emit()
		
		#Testing victory screen functionality
		#get_tree().change_scene_to_file("res://Scenes/Level_3.tscn")

