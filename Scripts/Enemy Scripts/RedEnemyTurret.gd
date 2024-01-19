extends MyEnemyBody

######### initialise variables #########

@onready var anim = $AnimatedSprite2D

# reference to player
@onready var player: MyCharacterBody = get_parent().get_node("Player")

# AI stuff
var has_seen_player: bool = false
var is_dead: bool = false

# get reference to components
@onready var move_component: MovementComponent = $MovementComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sight_component: SightComponent = $SightComponent




######### my functions #########

# core AI design
func decideInput():
	if is_dead || Manager.player_is_dead:
		stopMoving(move_component)
		return
	
	# if enemy has been aggroed
	if has_seen_player:
		# if we can rotate such that 
		# we have line of sight on player
		if sight_component.player_in_raycircle:
			# then rotate and shoot at the player
			stopAndShoot(player.global_position, move_component)
		else:
			stopMoving(move_component)



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
	decideInput()


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


func onHurt():
	# animation
	anim.play("Damaged")
	
	# enemy will agro if u shoot them 
	# even if they cant see u
	has_seen_player = true

# all animations upon finishing will transition back to idle
func _on_animated_sprite_2d_animation_finished():
	anim.play("Idle")



