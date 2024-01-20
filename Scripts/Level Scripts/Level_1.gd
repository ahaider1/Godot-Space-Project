extends Node

######### initialise variables #########

@export var enemy_tscn: PackedScene

#@onready var mob_spawn_location = get_node("enemy1Path/enemy1SpawnLocation")

#Hud had been made an instance of the world(main game logic), 
#allowing us to access pause without needing to be in the Hud Scene
#We simply use HUD

@onready var level_obj = $LevelObjective


######### my functions #########

#func new_game():
#	$startTimer.start()




######### Godot functions #########

func _ready():
	
	level_obj.connect("next_level", Manager.nextLevel)



######### Godot signal functions #########




func _on_player_next_level():
	Manager.nextLevel()
