extends Node

#database of upgrades to be applied to the player


const UPGRADES = {
	"upgrade 1": {
		
		"displayname": "Max Health Up",
		"details" : "Increase Max Health by 100",
		#If we want upgrade to follow on from each other, use this
	},
	
	"upgrade2": {
		
		"displayname": "upgrade2",
		"details" : "super cool",
		#If we want upgrade to follow on from each other, use this
		"prerequisites": []
	},
	
	"upgrade3": {
		
		"displayname": "upgrade3",
		"details" : "does yz to character",
		#If we want upgrade to follow on from each other, use this
		"prerequisites": []
	}
	
	
	
	
}
