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
# whether we want to go forwards, backwards, or neither
var forward_backward: int = 0

# AI stuff
var has_seen_player: bool = false


# get reference to components
@onready var pathfind_component = $PathfindComponent
@onready var move_component = $MovementComponent
@onready var sight_component = $SightComponent

######### my functions #########

# core AI movement design
func decideMovement():
	# set face dir
	face_dir = Vector2.from_angle(rotation)
	
	# for now, only target the player
	# if they exist
	if player != null && has_seen_player:
		moveTo(player.global_position)


# set the enemy to pathfind to a position
func moveTo(pos: Vector2):
	forward_backward = 1

	pathfind_component.target_pos = pos
	
	# where is the pathfind alg currently pointing to?
	var pathfind_dir: Vector2 = pathfind_component.current_dir

	# find which way to rotate 
	var angle: float = rad_to_deg(face_dir.angle_to(pathfind_dir))
	
	# decide whether we need to rotate or not
	# if angle between desired vector and current dir vector is > 10 degrees
	# then we need to rotate
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
	velocity += face_dir * forward_backward * move_component.acceleration * delta


######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	
	# connect signals
	sight_component.connect("can_see_player", on_can_see_player)

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

func on_can_see_player():
	has_seen_player = true
	
