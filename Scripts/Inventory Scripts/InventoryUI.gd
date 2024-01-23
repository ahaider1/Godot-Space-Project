extends Control


######### initialise variables #########

# is the inventory UI open?
var is_open = false

# reference to data representation of player's inv
@onready var player_inventory: Inventory = preload("res://Inventory Items/PlayerInventory.tres")

# reference to equipment slots
@onready var player_equipment: Equipment = preload("res://Inventory Items/PlayerEquipment.tres")


# an array of all inventory slots
@onready var slots: Array = $HBoxContainer/PanelContainer/MarginContainer/GridContainer.get_children()

# an array of all equipment slots
@onready var equipment_slots: Array = $HBoxContainer/EquipmentContainer/MarginContainer/Container/Equipment.get_children()


# what item has the user currently grabbed?
var curr_grabbed_item: InventoryItem = null

# reference to currently grabbed slot
@onready var grabbed_slot = $GrabbedSlot


######### my functions #########

# update all inv slots
func updateSlots():
	# we take min in case of inventory overflow somehow
	for i in range(min(player_inventory.items.size(), slots.size())):
		slots[i].update(player_inventory.items[i])
		slots[i].connect("slot_clicked", on_slot_clicked)

# update all equipment slots
func updateEquipmentSlots():
	for i in range(min(player_equipment.items.size(), equipment_slots.size())):
		equipment_slots[i].update(player_equipment.items[i])
		equipment_slots[i].connect("slot_clicked", on_equipment_slot_clicked)


# update the curr grabbed slot
func updateGrabbedSlot():
	if curr_grabbed_item:
		grabbed_slot.update(curr_grabbed_item)
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)
		grabbed_slot.show()
	else:
		grabbed_slot.hide()


######### Godot functions #########

func _ready():
	updateSlots()
	updateEquipmentSlots()

func _physics_process(delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)


######### Godot signal functions #########

# only for inventory slots
func on_slot_clicked(index: int):
	
	if curr_grabbed_item == null:
		curr_grabbed_item = player_inventory.items[index]
		
		# update data structure
		player_inventory.items[index] = null
		# update UI display
		slots[index].update(null)
	
	# otherwise something has been grabbed, so we will drop it
	else:
		# swap 
		var temp = curr_grabbed_item
		curr_grabbed_item = player_inventory.items[index]
		
		# update data structure
		player_inventory.items[index] = temp
		# update UI display
		slots[index].update(temp)
		
		
	
	updateGrabbedSlot()

# only for equipment slots
func on_equipment_slot_clicked(index: int):
	
	if curr_grabbed_item == null:
		curr_grabbed_item = player_equipment.items[index]
		
		# update data structure
		player_equipment.items[index] = null
		# update UI display
		equipment_slots[index].update(null)
	
	# otherwise something has been grabbed, so we will drop it
	else:
		# update data structure
		player_equipment.items[index] = curr_grabbed_item
		# update UI display
		equipment_slots[index].update(curr_grabbed_item)
		
		curr_grabbed_item = null
	
	player_equipment.equipment_changed.emit(index)
	
	updateGrabbedSlot()

