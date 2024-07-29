extends interactable_object # extends interactable object allowing use of important functions

@export var item_name : String # the items name

func _ready():
	interaction_prompt = "Pick up " + item_name

func _interact():
	var item = load("res://inventory_system/items/item_data/" + item_name + ".tres") # assigns the world item
	GlobalSignals._on_item_transfer.emit(item, 1, true)
	queue_free()
