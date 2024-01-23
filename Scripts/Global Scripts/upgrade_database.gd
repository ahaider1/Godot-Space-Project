extends Node

#database of upgrades to be applied to the player

# upgrade textures

# weapon textures
var test_weapon_texture: Texture2D = preload("res://Sprites/Weapons/test weapon.png")
var turret_weapon_texture: Texture2D = preload("res://Sprites/Weapons/Turret Weapon.png")
var thicc_blaster_texture: Texture2D = preload("res://Sprites/Weapons/ThickBlaster.png")

# other textures
var heart_texture: Texture2D = preload("res://Sprites/Heart.png")
var not_drawn_yet: Texture2D = preload("res://Sprites/notDrawnYet.png")

var UPGRADES = {
	"upgrade 1": {
		
		"displayname": "Max Health Up",
		"details" : "Increase Max Health by 100",
		"texture" : heart_texture
	},
	
	"upgrade 2": {
		
		"displayname": " Main Weapon Fire Rate Up",
		"details" : "Doubles the fire rate of your main weapon",
		"texture" : not_drawn_yet
	},
	
	"upgrade 3": {
		
		"displayname": "Equip Turret",
		"details" : "Changes your fast firing weapon 
		for a slower one that deals more damage",
		"texture" : turret_weapon_texture
		
	
	},
	
	"upgrade 4": {
		"displayname": "Hip Fire",
		"details" : "Add a fast firing weapon to
		 the left side of your spaceship",
		"texture" : test_weapon_texture
	},
	
	"upgrade 5": {
		"displayname": "Movement Speed Up",
		"details" : "Increase your movement speed by 1.5",
		"texture" : not_drawn_yet
	},
	
	"upgrade 6": {
		"displayname": "Bulking Season",
		"details": "Reduce movement speed significantly, 
		but greatly increase fire rate of all weapons",
		
		"texture" : not_drawn_yet
	},
	
	"upgrade 7": {
		"displayname": "Thicc Blaster",
		"details": "Adds a thicc blaster to your inventory",
		
		"texture" : thicc_blaster_texture
	}
}
