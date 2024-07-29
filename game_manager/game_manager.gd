extends Node

@export var keycard : Item
@export var keycards_needed : int = 5
@onready var card_counter : Label = get_node("CardCount")
@onready var win = get_node("Ending Panels/Win")
@onready var lose = get_node("Ending Panels/Lose")
@onready var inventory : Inventory = get_node("player/Inventory")
var game_over : bool = false


func _ready ():
	Engine.time_scale = 1
	GlobalSignals._on_item_transfer.connect(_on_item_transfer)
	update_card_counter()


func update_card_counter ():
	var current = inventory._get_item_quantity(keycard)
	card_counter.text = "Find " + str(current) + "/" + str(keycards_needed) + " keycrads"

func _on_item_transfer (item : Item, amount : int, player_receiving : bool):
	update_card_counter()
	
	if inventory._get_item_quantity(keycard) == keycards_needed:
		win_game()

func win_game ():
	game_over = true
	win.visible = true
	Engine.time_scale = 0


func lose_game ():
	game_over = true
	lose.visible = true
	Engine.time_scale = 0


func _process(delta):
	if game_over and Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
