extends PanelContainer

@onready var item_display = $MarginContainer/ItemDisplay

signal slot_clicked 

func update(item: InventoryItem):
	if !item:
		item_display.visible = false
	else:
		item_display.visible = true
		item_display.texture = item.texture


# panelcontainers do not have onclicked signal
# so we use this chunky if statement instead
func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
		slot_clicked.emit(get_index())
