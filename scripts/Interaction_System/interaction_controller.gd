extends RayCast3D
@onready var interact_prompt_label : Label = get_node("interaction_prompt") # the ui label that contains the interaction text

func _process(delta):
	var object = get_collider() # the collider of the object that the ray hits
	interact_prompt_label.text = "" # sets the prompt to default empty so nothing is on screen
	
	if object and object is interactable_object: # if the object that the ray collides with is not null and is interactable
		if object.can_interact == false: # if the object cant interact cancel interaction
			return
		
		interact_prompt_label.text = "[E] " + object.interaction_prompt
		if Input.is_action_just_pressed("interact"):
			object._interact()
