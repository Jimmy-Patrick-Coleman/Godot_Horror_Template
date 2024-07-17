class_name interactable_object
extends Node3D

@export var interaction_prompt : String # the prompt that will pop up for the interaction
@export var can_interact : bool = true # is the object interactable ?

func _interact():
	print("overide me")
