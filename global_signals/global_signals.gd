extends Node 
signal _on_item_transfer (item : Item, amount : int, player_receiving : bool) # creates a global signal that can be called anywhere that gives the player amount items 
