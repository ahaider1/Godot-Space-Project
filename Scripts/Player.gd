extends MyCharacterBody

class_name Player

######### initialise variables #########

# animation
# we cannot initialise anim variable before runtime, 
# (since we cant use get_node() or $Node before runtime)
# we have to do it in the ready function or @onready (they are same)
@onready var anim = $AnimatedSprite2D

# init other
@onready var turret_weapon= preload("res://Scenes/Weapons/TurretWeapon.tscn")
@onready var test_weapon= preload("res://Scenes/Weapons/BulletShooter.tscn")

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

# functionality function for character upgrading
func upgradeCharacter(upgrade):
	Player_Data.collected_upgrades.append(upgrade)

# apply upgrades to player
#func apply_upgrades():
	#if Player_Data.collected_upgrades.size() < 1:
		#return 
	#
	#print(get_tree().current_scene.name)
	#if get_tree().current_scene.name == "Level_1":
		#Player_Data.collected_upgrades.clear()
		#return
	#
	#
	#for i in Player_Data.collected_upgrades:
		#
		#match i:
			#"upgrade 1":
				#health_component.max_health=200
				#health_component.health=200
			#
				#
			#"upgrade 3":
				##weapon_slot1.weapon=null
				##var upgrade_weapon=turret_weapon.instantiate()
				##weapon_slot1.add_child(upgrade_weapon)
				##weapon_slot1.weapon=upgrade_weapon
				#print("upgrade 3 not yet implemented, i will work on inv system")
				#
				#
			#"upgrade 2":
				#weapon_component_1.weapon.fire_rate /= 2
				##print("upgrade 2 not yet implemented")
			#
				#
			#"upgrade 4":
				##var upgrade_weapon=test_weapon.instantiate()
				##weapon_slot2.add_child(upgrade_weapon)
				##weapon_slot2.weapon=upgrade_weapon
				#print("upgrade 4 not yet implemented, i will work on inv system")
				#
			#"upgrade 5":
				#move_component.max_speed=move_component.max_speed*1.5
				#move_component.acceleration=move_component.acceleration*1.5
				#
			#"upgrade 6":
				#move_component.max_speed=move_component.max_speed/5
				#move_component.acceleration=move_component.acceleration/5
				#weapon_component_1.weapon.fire_rate=0.05

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
		var curr_weapon: Weapon = null
		
		if curr_component.get_child_count() > 0:
			curr_weapon = curr_component.get_child(0)

		if curr_weapon:
			curr_weapon.queue_free()

	# otherwise there is a weapon in the equipment slot
	else:
		# connect the new weapon to weapon component
		var new_weapon: Weapon = equipment.items[index].weapon.instantiate()
		curr_component.add_child(new_weapon)
		curr_component.weapon = new_weapon

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


