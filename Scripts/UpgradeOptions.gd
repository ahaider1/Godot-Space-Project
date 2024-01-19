extends ColorRect

@onready var upgradeName = $ColorRect/Upgr_Desc
@onready var upgradeDescription = $ColorRect/Upgr_Desc

#upgrade we choose
var item=null

# Called when the node enters the scene tree for the first time.
func _ready():
	if item == null:
		item="upgrade1"
		
	upgradeName.text=Database.UPGRADES[item]["displayname"]
	upgradeDescription.text=Database.UPGRADES[item]["details"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
