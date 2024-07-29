class_name State 
extends Node

var active : bool # is this the active state
var state_machine : StateMachine # THE STATE MACHINE
var controller : AIController 
@export_node_path("AIController") var contoller_path : NodePath # used to assign the  contoller in the inspector

func initialize ():
	state_machine = get_parent() # the state is the child of the state machine
	controller = get_node(contoller_path) # assigns the controller
	
func enter (): # whet the ai enters this state
	active = true

func exit (): # ai exits this state
	active = false
	
func update(delta): # updates every frame
	pass
	
func _physics_update(delta):
	pass
	
func navigation_complete():
	pass
	
func random_offset() -> Vector3: # hardcoded to return a random vector 3
	var offset = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	return offset.normalized()
