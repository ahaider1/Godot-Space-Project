extends Node2D

class_name MovementComponent



######### initialise variables #########

# IMPORTANT: current direction that entity wants to rotate towards
# -1 means counterclockwise, 1 means clockwise, 0 means dont rotate
var rotation_direction: int = 0
# whether we want to go forwards, backwards, or neither
var forward_backward: int = 0

# IMPORTANT: current direction that entity is facing
var face_dir: Vector2

# movement stats
@export var friction = 150
@export var max_speed = 100
@export var acceleration = 1200

@export var max_rotation_speed: float = 3
@export var rotation_accel: float = 15
@export var rotation_frict: float = 5

# get reference to parent node
# it should be a MyCharacterBody
@onready var entity_node: MyCharacterBody = get_parent()

# by default, enemies will shoot at player 
# if they are within 10 degrees cone
# you can override this if u want different behaviour
@export var aim_accuracy_angle = 10


######### my functions #########

# apply rotational friction
func applyRotationFrict(delta):
	# apply friction
	if abs(entity_node.rotation_speed) > (rotation_frict * delta):
		entity_node.rotation_speed -= ((entity_node.rotation_speed / abs(entity_node.rotation_speed))
		* (rotation_frict * delta))
	else:
		entity_node.rotation_speed = 0

# make sure we dont exceed max rotation speed
func limitRotationSpeed():
	if entity_node.rotation_speed > max_rotation_speed:
		entity_node.rotation_speed = max_rotation_speed
	elif entity_node.rotation_speed < -max_rotation_speed:
		entity_node.rotation_speed = -max_rotation_speed

# apply friction to velocity vector
func applyFrict(delta):
	# apply friction to velocity
	if entity_node.velocity.length() > (friction * delta):
		entity_node.velocity -= entity_node.velocity.normalized() * (friction * delta)
	else:
		entity_node.velocity = Vector2.ZERO

# make sure we dont exceed max speed
func limitSpeed():
	entity_node.velocity = entity_node.velocity.limit_length(max_speed)

# calculate rotation
func calcRotation(delta):
	# set rotation speed
	entity_node.rotation_speed += rotation_direction * rotation_accel * delta

# calculate velocity vector
func calcVelocity(delta): 
	# set velocity
	entity_node.velocity += face_dir * forward_backward * acceleration * delta



######### Godot functions #########

func _process(_delta):
	face_dir = Vector2.from_angle(entity_node.rotation)

func _physics_process(delta):
	# calc and set rotation
	calcRotation(delta)
	
	# calc and set velocity vector 
	# (vector describes direction that entity is facing and 
	# how fast the entity is moving in that direction)
	calcVelocity(delta)
	
	# apply friction
	applyFrict(delta)
	
	# apply rotational friction
	applyRotationFrict(delta)
	
	# limit speed
	limitSpeed()
	
	# limit rotational speed
	limitRotationSpeed()
	
	# actually rotate
	entity_node.rotation += entity_node.rotation_speed * delta
	
	# actually move
	entity_node.move_and_slide()



######### Godot signal functions #########
