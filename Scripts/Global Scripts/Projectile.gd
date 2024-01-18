extends Area2D

class_name Projectile

######### initialise variables #########

# init explosion scene
@export var explosion: PackedScene

# proj stats
@export var proj_speed = 250
@export var proj_damage = 30
# after 3 seconds, proj will vanish
@export var proj_lifetime = 1

var proj_direction = Vector2.ZERO

var belongs_to_player: bool = false

var is_vanishing: bool = false


# default collision layer settings

# what collision layer the proj will belong to if it is a:
# player proj
var player_proj_collision_layer: int = Manager.player_proj_layer
# enemy proj
var enemy_proj_collision_layer: int = Manager.enemy_proj_layer

# what collision layer the proj scans collisions for if it is a:
# player proj
var player_proj_collision_mask: int = Manager.walls_layer | Manager.enemy_layer
# enemy proj
var enemy_proj_collision_mask: int = Manager.walls_layer | Manager.player_layer



######### my functions #########

# the angle given is the desired rotation of the proj
func setDirection(angle):
	
	# set the rotation
	rotation = angle
	
	# create the direction vector based on rotation
	proj_direction = Vector2(1,0).rotated(angle)

# explode and instantiate an explosion effect
func explode():
	# instantiate explosion
	var explosion_instance = explosion.instantiate()
	explosion_instance.position = get_global_position()
	get_tree().get_root().add_child(explosion_instance)
	
	# delete current proj
	queue_free()

# make projectile vanish
func increaseTransparency(delta):
	# decrease alpha value 
	modulate.a -= 10 * delta
	if modulate.a <= 0:
		queue_free()

# assign collsion layer and mask
func assignCollision():
	if belongs_to_player:
		collision_layer = player_proj_collision_layer
		collision_mask = player_proj_collision_mask
	else: 
		# it belongs to enemy
		collision_layer = enemy_proj_collision_layer
		collision_mask = enemy_proj_collision_mask

# assign proj lifetime
func assignLifetime():
	# asynchronous wait, after proj_lifetime seconds 
	# projectile will vanish
	await get_tree().create_timer(proj_lifetime).timeout
	is_vanishing = true


