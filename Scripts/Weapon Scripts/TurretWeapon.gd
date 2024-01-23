extends Weapon

######### initialise variables #########

# all weapons should have the following properties
# how fast it shoots, will shoot once every fire_rate seconds
@export var fire_rate: float = 1

# what projectile it shoots
@export var projectile_tscn: PackedScene

# where the projectile will spawn from
@onready var proj_spawnpoint: Marker2D = $ProjSpawnPt

# the weapon sprite animator 
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

# init the nodes that this component belongs to
@onready var weapon_component: WeaponComponent = get_parent()

# entity could be a player or enemy
@onready var entity: MyCharacterBody = weapon_component.get_parent()

# if an entity wants to have a weapon it needs to have a:
# WeaponComponent -> Weapon

# determine if we can fire or not
var can_fire: bool = true




######### my functions ########

# fire a shot
func fire():
	if can_fire:
		# play the animation
		anim.play("fire")
		
		# instantiate the bullet
		var proj_instance = projectile_tscn.instantiate()

		# set its position and direction
		proj_instance.position = proj_spawnpoint.get_global_position()
		proj_instance.setDirection(entity.rotation)
		
		# figure out if it shoots a player or enemy projectile
		if entity.is_in_group("player"):
			proj_instance.belongs_to_player = true
		else:
			proj_instance.belongs_to_player = false

		# add the bullet to the scene
		get_tree().current_scene.add_child(proj_instance)
		can_fire = false

		# asynchronous wait
		await get_tree().create_timer(fire_rate).timeout
		can_fire = true




######### Godot functions #########

func _ready():
	anim.play("idle")



######### Godot signal functions #########

func _on_animated_sprite_2d_animation_finished():
	anim.play("idle")
