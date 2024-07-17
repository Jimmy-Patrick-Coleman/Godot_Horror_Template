class_name player_controller # can be used to access it elsewhere
extends CharacterBody3D # lets the script access character body functionality such as velocity and is_on_floor

@export_group("Movement") # groups movement variables in inspector
@export var max_walk_speed : float = 4.0 # the max speed the player can walk
@export var acceleration : float = 15.0 # time taken to reach max speed
@export var braking : float = 5.0 # time taken to stop to a halt when running
@export var air_acceleration : float = 4.0 # air acceleration is slower than on ground
@export var jump_force : float = 5.0 # force propelling player when jumping
@export var gravity_modifier : float = 1.5 # modifies the projects default gravity 9.8
@export var max_run_speed : float = 6.0 # the max speed the player can run
var is_player_running : bool = false # is the player running default false

@export_group("Camera") # groups camera variables in inspector
@export var look_sensitivity : float = 0.005 # the sensitivity of looking with the camera
var camera_look_input : Vector2 # keeps track of the speed and direction of the mouse movement

@onready var camera : Camera3D = get_node("Camera3D") # assigns the camera node at the start of the game
@onready var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_modifier # default gravity and multiplies it by our gravity modifier

func _ready(): # called on node initialization
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	
func _physics_process(delta):# called every physics frame modifies physics related processes
	#	applies gravity
	if not is_on_floor(): # if not on floor players is moved closer to floor over time
		velocity.y -= gravity * delta
		
	#	jumping
	if is_on_floor() and Input.is_action_pressed("jump"): # if player is on ground and jump is pressed player can jump
		velocity.y = jump_force
	
	
	#	player movement
	# Movement direction
	var move_input = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards") # stores input from movement input keys (wasd) as a vector2
	var move_direction =(transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized() # creates a vector out of the movemnt input this vector is multiplied by the players transform.basis which is the players orientation in the world - note y axis is used for z axis as input vector is 2d y axis movement handled elsewhere - normalised keeps it within a margin of 1
	
	# speed calculation
	is_player_running = Input.is_action_pressed("sprint") # returns true if the player is pressing the sprint key
	
	var target_speed = max_walk_speed # assigns speed to default walk speed
	
	if is_player_running: # if the player is running their speed increases
		
		var run_dot = -move_direction.dot(transform.basis.z) # returns 1 through -1 based oh the difference bewteen moving forward and the current direction olf movement ie 1 = forward its positive 0 = left or right neutral to forward movement -1 = backwards negative to forward movement
		run_dot = clamp(run_dot, 0.0, 1.0) # run dot can only be a posatibe number ie not going backwards
		
		if run_dot > 0: # if the run dot is positve there is a speed increase
			target_speed = max_run_speed
			move_direction *= run_dot
			
	
	var current_smoothing = acceleration # default smoothing is walking acceleration
	if not is_on_floor():
		current_smoothing = air_acceleration # less smooth in air
	elif not move_direction:
		current_smoothing = braking #smoothes brakes
	
	var target_velocity = move_direction * target_speed # The target velocity is the max speed for their current movement style ie (walking or running) times the movement direction
	
	velocity.x = lerp(velocity.x, target_velocity.x, current_smoothing * delta) # the velocity is increased from its current to the target velocity over the current acceleartion time
	velocity.z = lerp(velocity.z, target_velocity.z, current_smoothing * delta)
	
	move_and_slide() # applies velocity to player
	
	#	Camera Movement
	rotate_y(-camera_look_input.x * look_sensitivity) # rotates the playerBody based on mouse input from the x axis / -camera_look_input is because otherwise it would be inverted
	
	camera.rotate_x(-camera_look_input.y * look_sensitivity) # up and down looking
	camera.rotation.x = clamp(camera.rotation.x, -1.5, 1.5) # restricts the rotation between -1.5 and 1.5, which is equivalent to -90 degrees and 90 degrees this prevents the player fliping upsidedown
	
	camera_look_input = Vector2.ZERO # resets the look input to stop constant rotation
	
func _unhandled_input(event): # handles inputs that the system does not automatically process
	if event is InputEventMouseMotion: # checks if said input is mouse movement
		camera_look_input = event.relative # mouse movement assigned to camera look input variable.



