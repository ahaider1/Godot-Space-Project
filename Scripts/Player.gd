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
@onready var test_weapon= preload("res://Scenes/Weapons/TestWeapon.tscn")

@onready var weapon_slot1=$WeaponSlot
@onready var weapon_slot2=$WeaponSlot2
@onready var weapon_slot3=$WeaponSlot3
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

# functionality function for character upgrading
func upgradeCharacter(upgrade):
	Player_Data.collected_upgrades.append(upgrade)

# apply upgrades to player
func apply_upgrades():
	if Player_Data.collected_upgrades.size() < 1:
		return 
	
	print(get_tree().current_scene.name)
	if get_tree().current_scene.name == "Level_1":
		Player_Data.collected_upgrades.clear()
		return
	
	
	for i in Player_Data.collected_upgrades:
		
		match i:
			"upgrade 1":
				health_component.max_health=200
				health_component.health=200
			
				
			"upgrade 3":
				weapon_slot1.weapon=null
				var upgrade_weapon=turret_weapon.instantiate()
				weapon_slot1.add_child(upgrade_weapon)
				weapon_slot1.weapon=upgrade_weapon
				
				
			"upgrade 2":
				weapon_slot1.weapon.weapon_component.fire_rate=weapon_slot1.weapon.weapon_component.fire_rate/2
			
				
			"upgrade 4":
				var upgrade_weapon=test_weapon.instantiate()
				weapon_slot2.add_child(upgrade_weapon)
				weapon_slot2.weapon=upgrade_weapon
				
			"upgrade 5":
				move_component.max_speed=move_component.max_speed*1.5
				move_component.acceleration=move_component.acceleration*1.5
				
			"upgrade 6":
				move_component.max_speed=move_component.max_speed/5
				move_component.acceleration=move_component.acceleration/5
				weapon_slot1.weapon.weapon_component.fire_rate=0.05
				
				if weapon_slot2.weapon != null:
					weapon_slot2.weapon.weapon_component.fire_rate=0.05

######### Godot functions #########






# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Idle")
	
	# signal connection
	health_component.connect("died", onPlayerDie)
	health_component.connect("took_damage", onPlayerHurt)

	apply_upgrades()


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

