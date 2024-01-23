extends Node

######### initialise variables #########

# get reference to player inv and equipment
var player_inventory: Inventory = preload("res://Inventory Items/PlayerInventory.tres")
var player_equipment: Equipment = preload("res://Inventory Items/PlayerEquipment.tres")

# get reference to default weapon
const BULLET_SHOOTER = preload("res://Inventory Items/Items/BulletShooter.tres")

######### my functions #########

# clear player's inventory and equipment
func resetInvAndEquipment():
	for i in range(player_inventory.items.size()):
		player_inventory.items[i] = null
	
	for i in range(player_equipment.items.size()):
		player_equipment.items[i] = null
	
	# give the player a default weapon to start
	player_inventory.items[0] = BULLET_SHOOTER




######### Godot functions #########

func _ready():
	# respawn player 
	Manager.player_is_dead = false
	Manager.player_node = null
	
	# reset the player's inv
	# resetInvAndEquipment()


######### Godot signal functions #########

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/Level_1.tscn")

