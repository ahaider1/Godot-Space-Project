extends Projectile

######### initialise variables #########

@export var max_pierce_count: int = 2
var pierce_count: int = 0


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
	
	# check if the projectile has exceeded its range
	# if it has it should disappear
	checkExceedsRange(delta)
	
	# move proj
	translate(proj_direction * proj_speed * delta)


######### Godot signal functions #########

# on collision with a physics body
func _on_body_entered(body):
	
	explode()


func _on_area_entered(area):
	# check if the area we have entered is a HitboxComponent
	if area is HitboxComponent:
		area.takeDamage(proj_damage)
		
		pierce_count += 1
		
		if pierce_count == max_pierce_count:
			explode()
		
	
	



