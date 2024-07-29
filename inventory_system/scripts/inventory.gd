class_name Inventory
extends Node

var slots : Array[InventorySlot] # an array containing all the inventory slots
@onready var window : Panel = get_node("InventoryWindow") # the inventory window
@onready var info_text : Label = get_node("InventoryWindow/InfoText") # the info text
@export var starter_items : Array[Item] # an array of starter items

func _ready():
	_toggle_window(false) # on start the inventory is closed

	for slot in get_node("InventoryWindow/SlotContainer").get_children(): # loops the slot container 
		slots.append(slot) # appends each slot to the slot array
		slot._set_item(null) # sets each slot to null
		slot.inventory = self # sets the slots inventory ref to this inventory instance
		
	for item in starter_items : # for each starter item
		_add_item(item) # add the item to the inventory
		
	GlobalSignals._on_item_transfer.connect(_on_item_transfer)

func _process(delta):
	if Input.is_action_just_pressed("inventory"): # if the inventory key is pressed
		_toggle_window(!window.visible) # toggles the inventory -- !window.visible returns the opposite of the windows visibility so if its open it returns false which will close the window
	
func _toggle_window(open: bool):
	window.visible = open # toggles the window visibility
	
	if open: # if the inventory is open allow player to use mouse
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else: # else capture it again
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_item_transfer (item : Item, quantity : int, addition : bool): # adds or removes items
	if addition == true: # if u are adding add the the quantity of items
		for i in range(quantity):
			_add_item(item)
	else: # remove the quantity of items
		for i in range(quantity): 
			_remove_item(item)
	

func _add_item (item : Item):
	var slot = _search_for_slot(item, true) # gets the slot for this item
	
	if slot == null : # if there are no available slots return
		return
	
	if slot.item == null: #if the slot currentlly is empty set it to hold this item type
		slot._set_item(item)
		
	else: # else increase the amount of this item held
		slot._add_item()

func _remove_item (item : Item):
	var slot = _search_for_slot(item, false) # gets the slot for this item
	
	
	if slot == null or slot.item != item: # if the slot dosent exist or isnt the item we are looking for
		return
	slot._remove_item()
	
func _search_for_slot (item: Item, addition: bool) -> InventorySlot:
	if addition == true: # looks for slots to add the item to
		
		for slot in slots: # checks each slot for the correct slot
			if slot.item == item and slot.quantity < item.max_stack_size: # if the slot exists and isnt full
				return slot #returns the slot
				
		
		for slot in slots: # if the slot dosent exist or is full look for an empty slot
			if slot.item == null: # checks for an empty slot
				return slot # returns the empty slot
				
				
		return null # There is no room to add this item
		
	else: # looks for a slot to take the item from
		
		for slot in slots: # checks all the slots for the correct slot
			if slot.item == item:
				return slot # if it exists return the slot
				
		return null # the slot dosent exist
	
	
  

func _get_item_quantity (item: Item) ->  int: # returns the items quantity
	var total = 0 # default zero
	
	for slot in slots: # checks each slot for the item
		if slot.item == item:
			total += slot.quantity # if it exists increament the total
	
	return total # returns the total quantity of the item found
