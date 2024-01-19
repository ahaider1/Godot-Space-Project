extends Node
# Properties to store player data
var player_health
var player_damage
var collected_upgrades= []



# Function to set player data
func setPlayerData(health: int, damage: int, upgrade: String):
	player_health = health
	player_damage = damage
	collected_upgrades.append(upgrade)

# Function to get player data
func getPlayerData() -> Dictionary:
	return {
		"health": player_health,
		"damage": player_damage,
		"upgrades": collected_upgrades
	}


# This is just a script that you can add variables to store data across scenes
# Simply use set in a particular scene to initialize player at the beginning of
# a level, and use get to retrieve player data at the end of the level
# Code to do so:
# In any other script in your scenes

# Import the singleton
#var PlayerData = preload("res://path/to/PlayerData.gd").instance

# Set player data
#PlayerData.set_player_data(20, 100)

# Get player data
#var data = PlayerData.get_player_data()
#print(data["damage"])
#print(data["health"])
