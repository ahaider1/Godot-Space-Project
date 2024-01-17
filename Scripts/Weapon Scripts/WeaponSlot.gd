extends Marker2D

class_name WeaponSlot

######### initialise variables #########

# reference to the weapon
@export var weapon: Weapon





######### Godot functions #########

func _ready():
	# whenever parent node emits a is_firing signal, 
	# we fire the weapon in this slot
	get_parent().connect("is_firing", _on_fire)




######### Godot signal functions #########

func _on_fire():
	# check if there exists a weapon in this slot
	if weapon:
		weapon.fire()
