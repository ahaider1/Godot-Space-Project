extends AnimatedSprite2D



######### Godot signal functions #########

# when animation is finished, delete this instance of the explosion
func _on_animation_finished():
	queue_free()
