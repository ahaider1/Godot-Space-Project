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
######### my functions #########

var offered_upgrades = []

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
	#hide upgrades until necessary
	upgrade.hide()
	# actually resume the game
	get_tree().paused = false
	
	is_paused = false

#create upgrade panel
func create_upgrade():
	upgrade.show()
	var option=0;
	var max_option=3
	
	while option < max_option:
		var option_choice=upgradeOptions.instantiate()
		option_choice.item=getRandomItem()
		options.add_child(option_choice)
		option+=1
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
	#if player dies
	if Manager.player_is_dead:
		get_tree().change_scene_to_file("res://Scenes/Levels/death_scene.tscn")
		
		
	#if player levels
	if Manager.next_level:
		get_tree().paused=true
		Manager.next_level=false
		create_upgrade()
		
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
	player.health_component.health=Player_Data.player_health
	

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
	
	# resume the game
	resumeGame()


