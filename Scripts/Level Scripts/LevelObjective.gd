extends Area2D


#When player hits the door (this node), we simply change the scene using this
#simple function.
# It parses the current scene name and then uses some conversions and + 1 
#to change to the next scene
# This means that all level scenes will need to be changed to:
#Level_(level number)
# This is a quick and easy way to do this
signal show_upgrades


# when player enters objective, go to next level
func _on_body_entered(body):
	if body.is_in_group("player"):
		show_upgrades.emit()


