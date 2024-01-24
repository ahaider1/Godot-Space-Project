extends MyEnemyBody

######### initialise variables #########

@onready var anim = $AnimatedSprite2D

# reference to player
@onready var player: Player = Manager.player_node


# get reference to components
@onready var pathfind_component: PathfindComponent = $PathfindComponent
@onready var move_component: MovementComponent = $MovementComponent
@onready var sight_component: SightComponent = $SightComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent

# teleporting
var can_teleport: bool = true
# can teleport once every teleport freq seconds
@export var teleport_freq: float = 4
@export var teleport_distance: float = 50
@export var teleport_effect: PackedScene


######### my functions #########

# core AI design
func decideInput():
	if is_dead || Manager.player_is_dead:
		stopMoving(move_component)
		return

	# if player exists and we have seen them
	if player != null && has_seen_player:
		
		# if we can rotate such that 
		# we have line of sight on player
		if sight_component.player_within_radius:
			# then rotate and shoot at the player
			stopAndShoot(player.global_position, move_component)

		elif can_teleport:
			teleport()

		# otherwise, move to the player's position
		else: 
			moveTo(player.global_position, pathfind_component, move_component)

# teleports towards player
func teleport():

	can_teleport = false

	# create the teleport effect
	var effect_instance = teleport_effect.instantiate()
	effect_instance.position = get_global_position()
	get_tree().current_scene.add_child(effect_instance)
	

	# determine where to teleport and actually teleport
	var teleport_dir: Vector2 = (player.global_position - global_position).normalized()
	teleport_dir *= teleport_distance
	
	rotation = teleport_dir.angle()
	global_position += teleport_dir
	
	# create another effect at end
	var effect_instance2 = teleport_effect.instantiate()
	effect_instance2.position = get_global_position()
	get_tree().current_scene.add_child(effect_instance2)
	
	await get_tree().create_timer(teleport_freq).timeout
	can_teleport = true
	


######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	if !player:
		player = get_parent().get_node("Player")
	
	
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

func _physics_process(_delta):
	# get AI input
	decideInput()



######### Godot signal functions #########

# catch the can see player signal
func on_can_see_player():
	if !has_seen_player:
		redAlert(sight_component)
	
	has_seen_player = true

# death
func onDeath():
	if !is_dead:
		Manager.player_money += enemy_worth
	
	is_dead = true
	
	# remove colliders
	$CollisionShape2D.queue_free()
	hitbox_component.queue_free()

func onHurt():
	# animation
	anim.play("Damaged")
	
	# enemy will agro if u shoot them 
	# even if they cant see u
	if !has_seen_player:
		redAlert(sight_component)
	
	has_seen_player = true

# all animations upon finishing will transition back to idle
func _on_animated_sprite_2d_animation_finished():
	anim.play("Idle")
