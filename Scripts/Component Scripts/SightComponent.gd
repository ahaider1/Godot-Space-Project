extends Node2D

class_name SightComponent

######### initialise variables #########

signal can_see_player

@export var vision_cone_angle: float = 30
@export var angle_between_rays: float = 10
@export var view_distance: float = 300

######### my functions #########

# create the rays
func createRaycasts():
	vision_cone_angle = deg_to_rad(vision_cone_angle)
	angle_between_rays = deg_to_rad(angle_between_rays)
	
	var num_rays = vision_cone_angle / angle_between_rays
	
	for index in num_rays:
		var ray = RayCast2D.new()
		var angle = angle_between_rays * (index - num_rays / 2.0)
		ray.target_position = Vector2(0,1).rotated(angle) * view_distance
		add_child(ray)
		ray.enabled = true

# check if player is in enemy's line of sight
# we are gonna use raycasting to check if it can see 
func checkForPlayer():
	for ray: RayCast2D in get_children():
		if ray.is_colliding() and ray.get_collider().is_in_group("player"):
			can_see_player.emit()
			break




######### Godot functions #########

func _ready():
	# make all the rays
	createRaycasts()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkForPlayer()


######### Godot signal functions #########





