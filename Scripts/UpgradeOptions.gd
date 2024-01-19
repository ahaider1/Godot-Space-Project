extends ColorRect

@onready var upgradeName = $ColorRect/Upgr_Desc
@onready var upgradeDescription = $ColorRect/Upgr_Desc
@onready var player=get_tree().get_first_node_in_group("player")



var mouse_over=false

signal selected_upgrade(upgrade)
#upgrade we choose
var item=null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	connect("selected_upgrade", Callable(player, "upgradeCharacter"))
	
	if item == null:
		item="upgrade1"
		
	upgradeName.text=Database.UPGRADES[item]["displayname"]
	upgradeDescription.text=Database.UPGRADES[item]["details"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event.is_action("click"):
		
		if mouse_over:
			#print("upgraded")
			emit_signal("selected_upgrade", item)
			
	
	
			

######signal functions

func _on_mouse_entered():
	mouse_over=true


func _on_mouse_exited():
	mouse_over=false # Replace with function body.


func _on_selected_upgrade(upgrade):
	pass # Replace with function body.
