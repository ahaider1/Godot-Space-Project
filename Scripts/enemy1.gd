extends MyCharacterBody

######### initialise variables #########

@onready var anim = $AnimatedSprite2D

# reference to player
@onready var player: MyCharacterBody = get_parent().get_node("Player")

# movement stuff

# IMPORTANT: current direction that entity wants to rotate towards
var rotation_direction = 0

# IMPORTANT: current direction that entity is facing
var face_dir: Vector2

# unit vector of face_dir, since face_dir could have length 0
var face_dir_unit: Vector2 

# get reference to pathfind component
@export var pathfind_component: PathfindComponent
@export var move_component: MovementComponent


######### my functions #########

# core AI movement design
func decideMovement():
	# set face dir
	face_dir_unit = Vector2.from_angle(rotation)
	face_dir = face_dir_unit

	# for now, only target the player
	# if they exist
	if player != null:
		pathfind_component.target_pos = player.global_position

	# where is the pathfind alg currently pointing to?
	var pathfind_dir: Vector2 = pathfind_component.current_dir

	# find which way to rotate 
	var angle: float = rad_to_deg(face_dir_unit.angle_to(pathfind_dir))
	
	# decide whether we need to rotate or not
	# if angle between desired vector and current dir vector is > 10 degrees
	if abs(angle) > 10:

		if angle < 0:
			# Counterclockwise rotation is faster
			rotation_direction = -1
		else:
			# Clockwise rotation is faster
			rotation_direction = 1
	else: 
		# dont rotate
		rotation_direction = 0
	




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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	# get AI input
	decideMovement()
	
	# calc and set rotation
	calcRotation(delta)
	
	# calc and set velocity vector 
	# (vector describes direction that player is facing and 
	# how fast the player is moving in that direction)
	calcVelocity(delta)
	
	# apply friction
	move_component.applyFrict(delta)
	
	# apply rotational friction
	move_component.applyRotationFrict(delta)
	
	# limit speed
	move_component.limitSpeed()
	
	# limit rotational speed
	move_component.limitRotationSpeed()
	
	# actually rotate
	rotation += rotation_speed * delta
	
	# actually move
	move_and_slide()




######### Godot signal functions #########

