# AI state machine Godot
## Overview
This is a AI state machine template built in godot 4.2.2
The repo contains both a standard interaction system and a player controller to go along with it.The AI comes with an AI contoller that handles the AIs movemnt around the map using Godot’s navigation system. The state machine consits of the machine itself as well a state clases which can be extended to create your own custom states with their own functionallity.

## Player Controller
The player controller is just a standard player contoller. It can walk, jump, sprint al of which have smoothe movement.

## Interaction system
Basic interaction system - a raycast is shot from the player controller and checks if it collides with and interactable object. If it does a prompt will appear asking the player to press the interaction key [E]. The sysetm is broke down into three scripts.
### The interaction_controller
This is the script attached to the raycast node in the player controller. It handles the player side of the interaction. A raycast is shot and checks for collsion with an object with the interactable_object class. It then checks if the object is currently interactable and if it is will display an interaaction prompt asking th player to press the interaction key. If the player presses they key the interaction_controller will call the interactable objects _interact function.
### The interactable_object 
This is a class that the interaction_contoller checks for on collision. It contains both the prompt text that will appear on the screen as well as an interac function which should be overidden by whatever custom interactable you desire.
### The template interaction
All you have to do is create a script that extends the interactable_object class and then ovveride the _interact function and you have a fully functional interactable object.

## State machine
The state machine is a custom class that holds the logic for changing states as well as a dictionary containing all the states belonging to the AI.

## States
The state class comes with a few basic functions that should be overidden when making your own custom states. Note you must remember to call the original functions in your overides. 

## How to use
First drag and drop the assets into your godot project. If you have your own player contoller remove the interaction controller from the player scene and put it in yours. Then set up the input maps required.
- move_forwards
- move_backwards
- move_left
- move_right
- jump
- interact
- sprint

Copy the template AI and remove its state nodes create your own state nodes and their accompanying. Remember to extend them from the State class.

