class_name InventorySlot
extends Node

var item : Item # the item
var quantity : int # the quantity of the item
@onready var  icon : TextureRect = get_node("Icon") # the icon in the inventory window
@onready var  quantity_label : Label = get_node("QuantityText") # displays the quantity in the inventory window
var inventory : Inventory # ref to inventory


func _set_item(new_item : Item):
	item = new_item # sets the item in the slot to be the item received
	quantity = 1 # sets the quantity to 1
	
	if item == null: # if the item dosent exist hide the icon in the inventory
		icon.visible = false
	else: # else display the icon
		icon.visible = true
		icon.texture = item.icon #sets the icon to be that of the items icon
		
	_update_quantity_text() # updates the quantity text


func _add_item():
	quantity += 1
	_update_quantity_text()


func _remove_item():
	quantity -= 1
	_update_quantity_text()
	
	if quantity == 0:
		_set_item(null)


func _update_quantity_text():
	if quantity <= 1:
		quantity_label.text = ""
	else:
		quantity_label.text = str(quantity)


func _on_mouse_entered(): # changes display text to the display name when the mouse hovers over the slot
	if item == null:
		inventory.info_text.text = ""
	else:
		inventory.info_text.text = item.display_name


func _on_mouse_exited(): # changes the display text back to nothing
	inventory.info_text.text = ""


func _on_pressed(): # when the player click on an item to use/equip it
	if item == null: #checks if item is null
		return
	else: # if not use item
		
		if item.item_type == "Useable":
			var remove_after_use = item._on_use(inventory.get_parent())
			
			if remove_after_use: # if the item should be removed after use remove the item
				_remove_item()
		elif item.item_type == "Equippable":
			pass


func _drop_item(): # drops the item
	if item == null: # checks if item is null
		return
		
	var world_item = item.world_item_scene.instantiate() # instantiates the world item
	add_child(world_item) # adds the item as a child
	world_item.position = inventory.get_parent().position + Vector3(0, 1.5, 0)  - inventory.get_parent().basis.z # sets the items position to in front of the player
	_remove_item() # removes the item


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT:
			_drop_item()
