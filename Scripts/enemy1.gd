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
var is_dead: bool = false

# get reference to components
@onready var pathfind_component = $PathfindComponent
@onready var move_component = $MovementComponent
@onready var sight_component = $SightComponent
@onready var health_component = $HealthComponent
@onready var hitbox_component = $HitboxComponent

######### my functions #########

# core AI movement design
func decideMovement():
	if is_dead || Manager.player_is_dead:
		stopMoving()
		return

	# set face dir
	face_dir = Vector2.from_angle(rotation)
	
	# if player exists and we have seen them
	if player != null && has_seen_player:
		# if we can rotate such that 
		# we have line of sight on player
		if sight_component.player_in_raycircle:
			# then rotate and shoot at the player
			stopAndShoot(player.global_position)

		# otherwise, move to the player's position
		else: 
			moveTo(player.global_position)


# set the enemy to pathfind to a position
func moveTo(pos: Vector2):
	forward_backward = 1

	pathfind_component.target_pos = pos
	
	# where is the pathfind alg currently pointing to?
	var pathfind_dir: Vector2 = pathfind_component.current_dir
	rotateToward(pathfind_dir)

# stop and shoot at a position
func stopAndShoot(pos: Vector2):
	# stop
	forward_backward = 0
	
	# aim
	var direction = pos - global_position
	rotateToward(direction)
	
	# angle to target
	var angle: float = rad_to_deg(face_dir.angle_to(pos))
	
	if abs(angle) > 10:
		# shoot 
		is_firing.emit()

# stop moving entirely
func stopMoving():
	forward_backward = 0
	rotation_direction = 0


# rotate towards a direction vector
func rotateToward(direction: Vector2):
	# find which way to rotate 
	var angle: float = rad_to_deg(face_dir.angle_to(direction))
	
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

# die process
func die(delta):
	increaseTransparency(delta)
	if modulate.a <= 0:
		queue_free()

######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	
	# connect signals
	sight_component.connect("can_see_player", on_can_see_player)
	health_component.connect("took_damage", onHurt)
	health_component.connect("died", onDeath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_dead:
		# die
		die(delta)

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

# catch the can see player signal
func on_can_see_player():
	has_seen_player = true

# death
func onDeath():
	is_dead = true
	
	# remove colliders
	$CollisionShape2D.queue_free()
	hitbox_component.queue_free()


# animation
func onHurt():
	anim.play("Damaged")

func _on_animated_sprite_2d_animation_finished():
	anim.play("Idle")
