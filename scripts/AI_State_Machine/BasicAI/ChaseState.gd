extends State # this is a state and so extends the State class

@export var stop_range : float = 1.0 # range to stop before collision
@export var lose_interest_range : float = 10.0 # range when the player is too far and stops chasing

var path_update_rate : float = 0.1 # AI path updates every tenth of a second
var last_update_time : float # tracks the time for path updates

func enter(): # overides State class enter function
	super.enter() # calls State class enter function
	controller.is_running = true # the ai is running
	controller.looking_at_player = true #ai will always look at player

func exit(): # overides State class exit function
	super.exit() # calls State class exit function
	controller.is_running = false # the ai is no longer running
	controller.looking_at_player = false # AI  is no longer looking at player
	
func update (delta): # the equivalent of the physics function
	var current_time = Time.get_unix_time_from_system() # stores the current time 
	if current_time - last_update_time > path_update_rate: # if enough time has passed since last path update
		last_update_time = current_time 
		controller._move_to_position(controller.player.position, false) # move the AI to the players position
	
	if controller.player_distance < stop_range: # stops the ai from trying to walk inside the player
		controller.is_stopped = true
		
	if controller.player_distance > lose_interest_range: # if the player has lost the ai change state to wander state
		state_machine._change_state("Wander")



