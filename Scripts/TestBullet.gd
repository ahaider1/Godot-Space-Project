extends Area2D

class_name Projectile

######### initialise variables #########

# init explosion scene
@export var explosion: PackedScene

# bullet stats
@export var bullet_speed = 250
@export var bullet_damage = 30
# after 3 seconds, bullet will vanish
@export var bullet_lifetime = 1

var bullet_direction = Vector2.ZERO

var belongs_to_player: bool

var is_vanishing: bool = false

# init mask settings
var player_layer: int = 1 << 0
var walls_layer: int = 1 << 1
var player_proj_layer: int = 1 << 2
var enemy_layer: int = 1 << 3
var enemy_proj_layer: int = 1 << 4

# what collision layer the bullet will belong to if it is a:
# player bullet
var player_proj_collision_layer: int = player_proj_layer
# enemy bullet
var enemy_proj_collision_layer: int = enemy_proj_layer

# what collision layer the bullet scans collisions for if it is a:
# player bullet
var player_proj_collision_mask: int = walls_layer | enemy_layer
# enemy bullet
var enemy_proj_collision_mask: int = walls_layer | player_layer


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

func increaseTransparency(delta):
	# decrease alpha value 
	modulate.a -= 10 * delta
	if modulate.a <= 0:
		queue_free()


######### Godot functions #########

func _ready():
	if belongs_to_player:
		collision_layer = player_proj_collision_layer
		collision_mask = player_proj_collision_mask
	else: 
		# it belongs to enemy
		collision_layer = enemy_proj_collision_layer
		collision_mask = enemy_proj_collision_mask

	# asynchronous wait

	await get_tree().create_timer(bullet_lifetime).timeout
	is_vanishing = true


func _process(delta):
	if is_vanishing:
		increaseTransparency(delta)


# sometimes this can cause tunnelling 
# if bullet is too fast
func _physics_process(delta):
	translate(bullet_direction * bullet_speed * delta)


######### Godot signal functions #########

# on collision with a physics body
func _on_body_entered(body):
	explode()



func _on_area_entered(area):
	# check if the area we have entered is a HitboxComponent
	if area is HitboxComponent:
		area.takeDamage(bullet_damage)
	
	explode()



