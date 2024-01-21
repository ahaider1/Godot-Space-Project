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
		
		"displayname": "Equip Turret",
		"details" : "Changes your fast firing weapon 
		for a slower one that deals more damage",
		#If we want upgrade to follow on from each other, use this
		"prerequisites": []
		
	
	},
	
	"upgrade 4": {
		"displayname": "Hip Fire",
		"details" : "Add a fast firing weapon to the left side of your spaceship"
		
	},
	
	"upgrade 5": {
		"displayname": "Movement Speed Up",
		"details" : "Increase your movement speed by 1.5"
	},
	
	"upgrade 6": {
		"displayname": "Bulking Season",
		"details": "Reduce movement speed significantly, but greatly increase fire rate of all weapons"
		}, 
		
	"upgrade 7": {
		"displayname": "Hip Sniper",
		"details": "equip a slow firing, high damage weapon that shoots through walls"
	}

}
