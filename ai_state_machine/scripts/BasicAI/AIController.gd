class_name AIController # can be extended to other scripts
extends CharacterBody3D # provides useful functions


@export var max_walk_speed : float = 1.0 # max walking speed
@export var max_run_speed : float = 2.5 # max running speed
var is_running : bool = false # tracks if the ai is running
var is_stopped : bool = false # used to overide functions to stop ai from moving and such
var looking_at_player : bool = false # tells the AI whether it should look in the direction it is moving or at the player
@export var acceleration : float = 15.0 # time taken to reach max speed
@export var braking : float = 5.0 # time taken to stop to a halt when running
@export var air_acceleration : float = 4.0 # air acceleration is slower than on ground

var move_direction : Vector3 # keeps track of the direction that the AI should be moving
var target_y_rot : float 

@onready var agent = get_node("NavigationAgent3D") # the navigation agent node
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") # the deafult godot gravity value
@onready var player = get_tree().get_nodes_in_group("player")[0] # gets the players node

var player_distance : float # distance betwwen ai and player

func _process(delta):
	if player != null: # if the player isnt null 
		player_distance = position.distance_to(player.position) # assigns the player distance variable
		
func _physics_process(delta):
	
	#	applies gravity
	if not is_on_floor(): # if not on floor ai is moved closer to floor over time
		velocity.y -= gravity * delta
		
		
	
	# 	calculates movement
	var target_pos = agent.get_next_path_position() # the next available path on navmesh 
	var move_dir = position.direction_to(target_pos) # the distance between the current position and that path
	move_dir.y = 0
	move_dir = move_dir.normalized()
	
	#  stops movement
	if agent.is_navigation_finished() or is_stopped: # if NavigationAgent3D node’s path is complete or is stopped stops movement
		move_dir = Vector3.ZERO # stops movement
		
	# calculates speed
	var target_speed = max_walk_speed # default speed is walking speed
	
	if is_running:
		target_speed = max_run_speed # if running increase max speed to running speed
		
	# adds smoothing to movement
	var current_smoothing = acceleration # default smoothing is walking acceleration
	if not is_on_floor():
		current_smoothing = air_acceleration # less smooth in air
	elif not move_direction:
		current_smoothing = braking #smoothes brakes
	
	# calculates and applies velocity
	var target_velocity = move_direction * target_speed # The target velocity is the max speed for their current movement style ie (walking or running) times the movement direction
	
	#velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta) # the velocity is increased from its current to the target velocity over the current acceleartion time
	#velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)
	
	
	velocity.x = move_dir.x * target_speed # 
	velocity.z = move_dir.z * target_speed
	
	move_and_slide() # applies velocity
	
	if looking_at_player: # if the ai is looking at the player face the player
		var player_dir = player.position - position # the players direction in relation to the ai
		target_y_rot = atan2(player_dir.x, player_dir.z) # sets the ai's rotation to be that of the angle of the player
	elif velocity.length() > 0:  # face the direction the ai is moving
		target_y_rot = atan2(velocity.x, velocity.z)
	
	rotation.y = lerp_angle(rotation.y, target_y_rot, 0.1) # rotates the ai to their target rotation over 1 second
	
	
	
func _move_to_position(to_pos : Vector3, adjust_pos : bool = true):
	if not agent: # just incase something went wrong
		agent = get_node("NavigationAgent3D")
		
	is_stopped = false # we dont want the ai to be stopped when its moving
	
	if adjust_pos: # if the movement position needs to be adjusted for example if its not on the navmesh
		var map = get_world_3d().navigation_map # our current navmesh
		var adjusted_pos = NavigationServer3D.map_get_closest_point(map, to_pos) # gets a new destination which is on the navmesh that is nearest to the current destination
		agent.target_position = adjusted_pos
		
	else: # the path is already on the navmesh
		agent.target_position = to_pos
		
