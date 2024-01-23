extends Projectile

######### initialise variables #########



######### my functions #########



######### Godot functions #########

func _ready():
	# assign collision layer and mask
	assignCollision()


func _process(delta):
	if is_vanishing:
		increaseTransparency(delta)


# sometimes this can cause tunnelling 
# if bullet is too fast
func _physics_process(delta):
	checkExceedsRange(delta)
	
	translate(proj_direction * proj_speed * delta)


######### Godot signal functions #########

# on collision with a physics body
func _on_body_entered(body):
	explode()


func _on_area_entered(area):
	# check if the area we have entered is a HitboxComponent
	if area is HitboxComponent:
		area.takeDamage(proj_damage)
		explode()
	
	



