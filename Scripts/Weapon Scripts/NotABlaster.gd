extends Weapon

######### initialise variables #########

# all weapons should have the following properties
# how fast it shoots, will shoot once every fire_rate seconds
@export var fire_rate: float = 1

# init the nodes that thiws component belongs to
@onready var weapon_component: WeaponComponent = get_parent()

# entity could be a player or enemy
@onready var entity: MyCharacterBody = weapon_component.get_parent()

# if an entity wants to have a weapon it needs to have a:
# WeaponComponent -> Weapon


# determine if we can fire or not
var can_fire: bool = true

# UNIQUE: list of hitboxes inside the weapon
var hitbox_list: Array[HitboxComponent]

# UNIQUE: weapon damage
var melee_damage: int = 30

var inside_someone = false # ayo

######### my functions ########

# fire a shot
func fire():
	if can_fire:
		
		
		for hitbox in hitbox_list:
			hitbox.takeDamage(melee_damage)
			
			

		

		# asynchronous wait
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true




######### Godot functions #########

func _ready():
	# figure out if it can hit player or enemy
	if entity.is_in_group("player"):
		collision_layer = Manager.player_proj_layer
		collision_mask = Manager.enemy_hitbox_layer
	else:
		collision_layer = Manager.enemy_proj_layer
		collision_mask = Manager.player_hitbox_layer

func _physics_process(delta):
	if inside_someone:
		fire()

######### Godot signal functions #########


# when hitbox enters melee range
func _on_area_entered(area):
	inside_someone = true
	hitbox_list.append(area)

# when hitbox leaves melee range
func _on_area_exited(area):
	hitbox_list.erase(area)
	if hitbox_list.is_empty():
		inside_someone = false
