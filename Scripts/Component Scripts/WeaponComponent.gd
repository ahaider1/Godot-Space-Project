extends Node2D

class_name WeaponComponent

# all weapons should have the following properties
# how fast it shoots, will shoot once every fire_rate seconds
@export var fire_rate: float

# what projectile it shoots
@export var projectile_tscn: PackedScene

# where the projectile will spawn from
@export var proj_spawnpoint: Marker2D

# init the nodes that this component belongs to
@onready var weapon: Weapon = get_parent()
@onready var weapon_slot: WeaponSlot = weapon.get_parent()
# entity could be a player or enemy
@onready var entity: Node2D = weapon_slot.get_parent()

# if an entity wants to have a weapon it needs to have a:
# WeaponSlot -> Weapon -> WeaponComponent

# parent of the entity should be the level
@onready var curr_level = entity.get_parent()

# determine if we can fire or not
var can_fire: bool = true


# fire a shot
func fire():
	if can_fire:
		# instantiate the bullet
		var proj_instance = projectile_tscn.instantiate()

		# set its position and direction
		proj_instance.position = proj_spawnpoint.get_global_position()
		
		proj_instance.setDirection(entity.rotation)

		# add the bullet to the scene
		curr_level.add_child(proj_instance)
		can_fire = false

		# asynchronous wait
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true

