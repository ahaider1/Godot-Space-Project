extends Node

@onready var level_obj = $LevelObjective




# Called when the node enters the scene tree for the first time.
func _ready():
	level_obj.connect("next_level", Manager.nextLevel)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
