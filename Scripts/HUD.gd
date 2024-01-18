extends CanvasLayer

######### initialise variables #########

# init pause screen variable
@onready var pause_screen = $Control/PausedScreen
var is_paused = false

#Ideally remove healthbar from HUD, because it handle pause, go to main screen, 
#and other operations like it. 
#Ideally we would have a proper UI scene that does this for us

# init healthbar variable
@onready var healthbar = $Control/Healthbar

# init reference to player
@onready var player = get_node("../Player")



######### my functions #########

# pause game
func pauseGame():
	# we show the pause screen
	pause_screen.show()
	
	# actually pause the game
	# the root node of scene and all children that inherit will be paused
	# a node can specially be configured under the Process tab to not pause 
	# when the root node is paused, the HUD scene for example will not be paused 
	# because we specially configured it in under the Process tab
	get_tree().paused = true
	
	is_paused = true

# resume game
func resumeGame():
	# if we resume the game, we hide the pause screen
	pause_screen.hide()
	
	# actually resume the game
	get_tree().paused = false
	
	is_paused = false

# get user input
func getInput():
	
	if Manager.player_is_dead:
		get_tree().change_scene_to_file("res://Scenes/death_scene.tscn")
	
	# if user hits escape
	if Input.is_action_just_pressed("escape"):
		# if we are not in the pause screen
		if !is_paused:
			pauseGame()
		# otherwise we are in the pause screen
		else:
			resumeGame()

# update health bar
func updateHealthbar():
	healthbar.value = player.health_component.health
	



######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	resumeGame()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	getInput()
	
	updateHealthbar()


######### Godot signal functions #########

# Called when menu button pressed
func _on_menu_button_pressed():
	#unpause
	resumeGame()
	
	# change scene to main menu scene
	
	get_tree().change_scene_to_file("res://Scenes/main_scene.tscn")

# Called when resume button pressed
func _on_resume_buttom_pressed():
	
	# resume the game
	resumeGame()


