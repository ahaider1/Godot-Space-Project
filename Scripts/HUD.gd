extends CanvasLayer

######### initialise variables #########

# init pause screen variable
@onready var pause_screen = $GUI/PausedScreen
var is_paused = false

#init upgrade window
@onready var upgradeOptions=preload("res://Scenes/upgrade_options.tscn")

#init window within upgrade that display options
@onready var options=get_node("GUI/Upgrade/upgradeOptions")

# init healthbar variable
@onready var healthbar = $GUI/Healthbar

# init reference to player
@onready var player = get_node("../Player")

#init level window
@onready var upgrade=$GUI/Upgrade

# inite reference to level objective
@onready var level_objective = get_node("../LevelObjective")


######### my functions #########

var offered_upgrades = []

# toggle pause screen
func togglePauseScreen():
	# if pause screen is on
	if pause_screen.visible:
		# we hide the pause screen
		pause_screen.hide()
		resumeGame()

	# otherwise, pause screen is off
	else:
		# we show the pause screen
		pause_screen.show()
		pauseGame()

# pause game
func pauseGame():
	# actually pause the game
	# the root node of scene and all children that inherit will be paused
	# a node can specially be configured under the Process tab to not pause 
	# when the root node is paused, the HUD scene for example will not be paused 
	# because we specially configured it in under the Process tab
	get_tree().paused = true
	is_paused = true

# resume game
func resumeGame():
	# actually resume the game
	get_tree().paused = false
	is_paused = false

# toggle upgrade panel
func toggleUpgradePanel():
	
	# upgrade screen is already visible
	if upgrade.visible:
		upgrade.hide()
		resumeGame()
	
	# otherwise, show upgrade screen and pause
	else:
		upgrade.show()
		pauseGame()

		var option=0;
		var max_option=3
		
		while option < max_option:
			var option_choice=upgradeOptions.instantiate()
			option_choice.item=getRandomItem()
			options.add_child(option_choice)
			option += 1
			print(option)


# get a random item from the database
func getRandomItem():
	var dblist= []
	#check database
	for i in Database.UPGRADES:
		if i in Player_Data.collected_upgrades: #check if already have
			pass
		elif i in offered_upgrades:
			pass
		else:
			dblist.append(i)
	
	if dblist.size() < 1:
		return
	var randomItem=dblist.pick_random()
	offered_upgrades.append(randomItem)
	return randomItem


# get user input
func getInput():
	# if player dies
	# lets bring up a pausedScreen-like overlay 
	# instead of transitioning scenes
	if Manager.player_is_dead:
		get_tree().change_scene_to_file("res://Scenes/Levels/death_scene.tscn")

	# if user hits escape
	if Input.is_action_just_pressed("escape"):
		
		
		# exit the upgrade panel if it is shown
		if upgrade.visible:
			toggleUpgradePanel()
		else:
			togglePauseScreen()


# update health bar
func updateHealthbar():
	healthbar.value = player.health_component.health




######### Godot functions #########

# Called when the node enters the scene tree for the first time.
func _ready():
	resumeGame()
	
	# connect signal
	if level_objective:
		level_objective.connect("show_upgrades", _on_show_upgrades)


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
	
	get_tree().change_scene_to_file("res://Scenes/Levels/main_scene.tscn")

# Called when resume button pressed
func _on_resume_buttom_pressed():
	# toggle off the pause screen
	togglePauseScreen()

# Called when player enters level objective
func _on_show_upgrades():
	# show the upgrade panel
	toggleUpgradePanel()

