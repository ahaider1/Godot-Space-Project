extends Weapon

@onready var weapon_component: WeaponComponent = $WeaponComponent



######### my functions ########

func fire():
	weapon_component.fire()
