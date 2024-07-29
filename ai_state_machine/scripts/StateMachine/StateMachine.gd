class_name StateMachine
extends Node


@export var default_state : State # lets the default state be assigned in the inspector
var current_state : State # stores the current state
var states : Dictionary = {} # all the possible states stored in a dictionary

func _ready(): # sets up the state machine
	await get_tree().create_timer(0.5).timeout # delays state machine starting so navemesh is created
	
	
	for child in get_children(): # stores all the state nodes as states in a dictionary
		if child is State: # loops each child of the state machine ie the states
			states[child.name] = child # stores the states in the dictionary
			child.initialize() # initializes the state
			
	if default_state != null: # loads default state
		_change_state(default_state.name)


func _change_state(new_state_name): #changes the current state
	var new_state : State = states.get(new_state_name) # searches the states dictionary for the new state
	
	if new_state == null: # error handling if state is null
		print("Error: New State is null")
		return
		
	if new_state == current_state: # error handling if new state is current state
		return
		
	if current_state != null: # if there is a current state exit it before state change
		current_state.exit()
		
	current_state = new_state # sets the current state to be the new state
	current_state.enter() # enters the new state
	
	print(current_state) #debugging

func _process(delta): # updates each frame
	if current_state != null: # if the curent state isnt null calls its process functions
		current_state.update(delta) # calls the current states custom process function since it cant call it itself

func _physics_process(delta): # updates each frame
	if current_state != null: # if the curent state isnt null calls its physics process functions
		current_state._physics_update(delta) # calls the current states custom physics process function since it cant call it itself
		
		

func _on_navigation_agent_3d_navigation_finished(): # when the navigation agent reaches its target calls the appropriate function
	if current_state != null:
		current_state.navigation_complete()
	


func _on_navigation_agent_3d_target_reached():
	pass # Replace with function body.
