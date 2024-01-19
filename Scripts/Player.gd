extends MyCharacterBody

######### initialise variables #########

# animation
# we cannot initialise anim variable before runtime, 
# (since we cant use get_node() or $Node before runtime)
# we have to do it in the ready function or @onready (they are same)
@onready var anim = $AnimatedSprite2D

# init other
signal next_level
# init components
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var move_component: MovementComponent = $MovementComponent

######### my functions #########

# input
func getInput():
	
	if Manager.player_is_dead:
		# stop the player
		move_component.forward_backward = 0
		move_component.rotation_direction = 0
		return
	
	# is player going forwards or backwards
	move_component.forward_backward = Input.get_axis("down", "up")

	# set current direction player wants to rotate
	move_component.rotation_direction = Input.get_axis("left", "right")

	# firing mechanics
	if Input.is_action_pressed("fire"):
		is_firing.emit()


######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	
	# signal connection
	health_component.connect("died", onPlayerDie)
	health_component.connect("took_damage", onPlayerHurt)

# normal processing
# use for non physics related things
func _process(delta):
	# get input
	getInput()
	
	# make player disappear
	if Manager.player_is_dead:
		increaseTransparency(delta)

#functionality function for character upgrading
func upgradeCharacter(upgrade):
	print("character_upgraded")

	next_level.emit()



######### Godot signal functions #########

func onPlayerDie():
	Manager.player_is_dead = true

func onPlayerHurt():
	anim.play("Damaged")

func _on_animated_sprite_2d_animation_finished():
	anim.play("Idle")


	
