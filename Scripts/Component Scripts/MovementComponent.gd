extends Node2D

class_name MovementComponent



######### initialise variables #########

# movement stats
@export var friction = 150
@export var max_speed = 100
@export var acceleration = 1200

@export var max_rotation_speed = 3
@export var rotation_accel = 15
@export var rotation_frict = 5

# get reference to parent node
# it should be a rigidbody2d or characterbody2d
@onready var entity_node = get_parent()



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

func limitSpeed():
	entity_node.velocity = entity_node.velocity.limit_length(max_speed)


######### Godot functions #########




######### Godot signal functions #########
