extends State # this is a state and so extends the State class

var home_position : Vector3

@export var max_wander_range: float = 12 # how far the ai can wander
@export var min_wait_time : float = 0.2 # min wait time to move after reaching destination
@export var max_wait_time : float = 2.0 # max wait time to move after reaching destination
@export var chase_range : float = 4.0 # if player is in range chase the player


func enter(): # overides the state class enter function
	super.enter() # calls the state class enter function and executes its required code
	home_position = controller.position # sets the home position to be the contollers start position
	_new_wander_pos() # creates a new wander position
	
func _new_wander_pos(): # wander in random position
	var new_pos = home_position + random_offset() * randf_range(0, max_wander_range) # creates a new position near the home position thats within the max wander range
	controller._move_to_position(new_pos) #tells the controller to move to the new position
	

func navigation_complete (): # overides state class
	var wait_time = randf_range(min_wait_time, max_wait_time) # generates wait time
	await get_tree().create_timer(wait_time).timeout # waits after completetion before next movement
	
	if not active: # incase state change while waiting
		return
		
	_new_wander_pos() # wanders in random position

func update(delta): # custom process function 
	if controller.player_distance < chase_range: # if tge player is in chase range change state to chase state
		state_machine._change_state("Chase")

