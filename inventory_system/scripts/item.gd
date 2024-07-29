class_name Item # identifies this script as item
extends Resource # extends the resources allows the item to be used as a resource

@export var display_name : String # the items display name
@export var icon : Texture2D # the icon in the inventory
@export var max_stack_size : int  = 12 # the max amount of the item that can be held in inventory
@export var world_item_scene : PackedScene # the 3d item in the world that is dropped
@export var item_type : String = "" # Useable or Equippable -- used for item features

func _on_use(player) -> bool : # the on use function that can be overidden later
	return false
