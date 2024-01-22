extends Button

class_name UpgradeOption

@onready var upgrade_name = $VBoxContainer/UpgradeName
@onready var upgrade_description = $VBoxContainer/UpgradeDesc
@onready var upgrade_icon = $UpgradeIcon

######### initialise variables #########




######### my functions #########

# based on the key that we received, we will assign 
# information 

func assignItem(item):
	upgrade_name.text = Database.UPGRADES[item]["displayname"]
	upgrade_description.text = Database.UPGRADES[item]["details"]
	upgrade_icon.texture = Database.UPGRADES[item]["texture"]





######### Godot functions #########




######### Godot signal functions #########


