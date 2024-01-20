extends Node

#database of upgrades to be applied to the player


const UPGRADES = {
	"upgrade 1": {
		
		"displayname": "Max Health Up",
		"details" : "Increase Max Health by 100",
		#If we want upgrade to follow on from each other, use this
	},
	
	"upgrade 2": {
		
		"displayname": " Main Weapon Fire Rate Up",
		"details" : "Doubles the fire rate of your main weapon",
		#If we want upgrade to follow on from each other, use this
		"prerequisites": []
	},
	
	"upgrade 3": {
		
		"displayname": "Equip Turret Weapon",
		"details" : "Changes your fast firing weapon 
		for a slower one that deals more damage",
		#If we want upgrade to follow on from each other, use this
		"prerequisites": []
		
	
	},
	
	"upgrade 4": {
		"displayname": "Hip Gun",
		"details" : "Add a fast firing weapon to the left side of your spaceship"
		
	},
	
	"upgrade 5": {
		"displayname": "Movement Speed Up",
		"details" : "Increase your movement speed by 1.5"
	}
	
	
	
	
}
