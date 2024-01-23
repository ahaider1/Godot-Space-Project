extends Node

@onready var level_obj = $LevelObjective



# Called when the node enters the scene tree for the first time.
func _ready():

	# add the stored player node to level
	add_child(Manager.player_node)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
