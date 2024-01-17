extends Node2D

class_name PathfindComponent

######### initialise variables #########

# reference to the NavigationAgent2D child node 
@onready var nav_agent = $NavigationAgent2D

# the global vector position of where we want to navigate to
@export var target_pos: Vector2

# the vector direction of where the nav_agent is currently pointing at
@export var current_dir: Vector2


######### my functions #########

# set the target for the nav_agent
func setTarget():
	nav_agent.target_position = target_pos



######### Godot functions #########

func _ready():
	EnemyManager.connect("pathfind_signal", _on_pathfind)


func _physics_process(delta):
	# every physics frame, get the direction that nav_agent points to
	var processed_dir: Vector2
	processed_dir = nav_agent.get_next_path_position() - global_position
	processed_dir = processed_dir.normalized()
	
	current_dir = processed_dir



######### Godot signal functions #########

# whenever pathfind signal is emitted by autoload script
# we will update position of target
func _on_pathfind():
	setTarget()



