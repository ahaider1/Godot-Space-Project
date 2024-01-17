extends MyCharacterBody

######### initialise variables #########

# animation
# we cannot initialise anim variable before runtime, 
# (since we cant use get_node() or $Node before runtime)
# we have to do it in the ready function or @onready (they are same)
@onready var anim = $AnimatedSprite2D

# init other
signal is_firing

# init components
@onready var health_component = $HealthComponent
@onready var hitbox_component = $HitboxComponent

# movement
# all movement stats are declared in movement component
@onready var move_component = $MovementComponent

# IMPORTANT: current direction that entity wants to rotate towards
var rotation_direction = 0

# IMPORTANT: current direction that entity is facing
var face_dir = Vector2.ZERO



######### my functions #########

# input
func getInput():
	# set current direction player is facing
	face_dir = Vector2.from_angle(rotation) * Input.get_axis("down", "up")

	# set current direction player wants to rotate 
	# (clockwise or counterclockwise)
	# left is -1, right is +1
	# left means counterclockwise
	# right means clockwise
	rotation_direction = Input.get_axis("left", "right")

	# firing mechanics
	if Input.is_action_pressed("fire"):
		is_firing.emit()

# calculate rotation
func calcRotation(delta):
	# set rotation speed
	rotation_speed += rotation_direction * move_component.rotation_accel * delta

# calculate velocity vector
func calcVelocity(delta): 
	# set velocity
	velocity += face_dir * move_component.acceleration * delta


######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")

# normal processing
# use for non physics related things
func _process(delta):
	# get input
	getInput()

# physics processing
func _physics_process(delta):
	# calc and set rotation
	calcRotation(delta)
	
	# calc and set velocity vector 
	# (vector describes direction that player is facing and 
	# how fast the player is moving in that direction)
	calcVelocity(delta)
	
	# apply friction to player
	move_component.applyFrict(delta)
	
	# apply rotational friction to player
	move_component.applyRotationFrict(delta)
	
	# limit speed
	move_component.limitSpeed()
	
	# limit rotational speed
	move_component.limitRotationSpeed()
	
	# actually rotate the player
	rotation += rotation_speed * delta
	
	# actually move the player
	move_and_slide()

