extends State # this is a state and so extends the State class


func enter(): # overides the state class enter function
	super.enter() # calls the state class enter function and executes its required code

func exit(): # overides the state class exit function
	super.exit() # calls the state class exit function and executes its required code

func navigation_complete (): # overides state class
	pass

func update(delta): # custom process function 
	pass

func _physics_update(delta): # custom physics process function 
	pass

