extends MyCharacterBody

class_name Player

######### initialise variables #########

# animation
# we cannot initialise anim variable before runtime, 
# (since we cant use get_node() or $Node before runtime)
# we have to do it in the ready function or @onready (they are same)
@onready var anim = $AnimatedSprite2D

# init other
var turret_mode = false
var turret_mode_unlocked = false

# init components
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var move_component: MovementComponent = $MovementComponent

@onready var weapon_component_1: WeaponComponent = $WeaponComponent
@onready var weapon_component_2: WeaponComponent = $WeaponComponent2
@onready var weapon_component_3: WeaponComponent = $WeaponComponent3



# init inventory

@export var inventory: Inventory
@export var equipment: Equipment

# teleporting
var teleport_unlocked: bool = false

var can_teleport: bool = true
# can teleport once every teleport freq seconds
@export var teleport_freq: float = 4
@export var teleport_distance: float = 50
@export var teleport_effect: PackedScene


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

	# do all turret mode stuff
	checkForTurretMode()

	# check for teleport input
	if Input.is_action_just_pressed("teleport") && can_teleport && teleport_unlocked:
		teleport()

	# firing mechanics
	if Input.is_action_pressed("fire"):
		is_firing.emit()

# assign weapon components to their weapons
# depending on what is in the player's equipment slots
func updateWeaponComponent(index: int):
	# dont worry about scalability here we will only ever have 3 weapon slots
	var curr_component: WeaponComponent
	match index:
		0:
			curr_component = weapon_component_1
		1:
			curr_component = weapon_component_2
		2:
			curr_component = weapon_component_3
	
	# if there is no item in the equipment slot
	if equipment.items[index] == null:
		# disconnect and delete the weapon instance
		curr_component.weapon = null
		
		for i in range(curr_component.get_child_count()):
			curr_component.get_child(i).queue_free()
		

	# otherwise there is a weapon in the equipment slot
	else:
		# clear the slot first
		for i in range(curr_component.get_child_count()):
			curr_component.get_child(i).queue_free()
		
		# connect the new weapon to weapon component
		var new_weapon: Weapon = equipment.items[index].weapon.instantiate()
		curr_component.add_child(new_weapon)
		curr_component.weapon = new_weapon

func checkForTurretMode():
	# user holds shift for turret mode
	if turret_mode_unlocked:
		if Input.is_action_just_pressed("turret_mode"):
			turret_mode = true
		elif Input.is_action_just_released("turret_mode"):
			turret_mode = false
	
	if turret_mode:
		# if player is in turret mode, he cant move
		move_component.rotation_direction = 0
		move_component.forward_backward = 0
		
		# override move component, set rotation directly
		rotation = (get_global_mouse_position() - global_position).angle()

# teleport
func teleport():

	can_teleport = false

	# create the teleport effect
	var effect_instance = teleport_effect.instantiate()
	effect_instance.position = get_global_position()
	get_tree().current_scene.add_child(effect_instance)
	

	# determine where to teleport and actually teleport
	var teleport_dir: Vector2 = (get_global_mouse_position() - global_position).normalized()
	teleport_dir *= teleport_distance
	
	rotation = teleport_dir.angle()
	global_position += teleport_dir
	# stop moving
	velocity = Vector2.ZERO
	rotation_speed = 0
	
	# create another effect at end
	var effect_instance2 = teleport_effect.instantiate()
	effect_instance2.position = get_global_position()
	get_tree().current_scene.add_child(effect_instance2)
	
	await get_tree().create_timer(teleport_freq).timeout
	can_teleport = true

######### Godot functions #########






# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	
	# signal connection
	health_component.connect("died", onPlayerDie)
	health_component.connect("took_damage", onPlayerHurt)

	# connect to equipment inventory
	equipment.connect("equipment_changed", onEquipmentChanged)

	# update all weapon components at the start
	updateWeaponComponent(0)
	updateWeaponComponent(1)
	updateWeaponComponent(2)


# normal processing
# use for non physics related things
func _process(delta):
	# get input
	getInput()
	
	# make player disappear
	if Manager.player_is_dead:
		increaseTransparency(delta)


######### Godot signal functions #########

func onPlayerDie():
	Manager.player_is_dead = true

func onPlayerHurt():
	anim.play("Damaged")

func _on_animated_sprite_2d_animation_finished():
	anim.play("Idle")

func onEquipmentChanged(index: int):
	updateWeaponComponent(index)


