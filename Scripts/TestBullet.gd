extends Area2D

class_name Projectile

######### initialise variables #########

# init explosion scene
@export var explosion: PackedScene

# bullet stats
@export var bullet_speed = 250
@export var bullet_damage = 30

var bullet_direction = Vector2.ZERO




######### my functions #########

# the angle given is the desired rotation of the bullet
func setDirection(angle):
	
	# set the rotation
	rotation = angle
	
	# create the direction vector based on rotation
	bullet_direction = Vector2(1,0).rotated(angle)

func explode():
	# instantiate explosion
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = get_global_position()
	get_tree().get_root().add_child(explosion_instance)
	
	# delete current bullet
	queue_free()


######### Godot functions #########

func _ready():
	pass

# sometimes this can cause tunnelling 
# if bullet is too fast
func _physics_process(delta):
	translate(bullet_direction * bullet_speed * delta)


######### Godot signal functions #########

## on collision with a physics body
func _on_body_entered(body):
#
	explode()



func _on_area_entered(area):
	
	# check if the area we have entered is a HitboxComponent
	if area is HitboxComponent:
		area.takeDamage(bullet_damage)
	
	explode()



