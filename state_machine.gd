class_name StateMachine
extends Node
## State machine for managing character states. Inspired by:
## - https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/
## - https://godotengine.org/asset-library/asset/2714

signal state_changed(new_state: String)

## Maps state names to their nodes. Used in _change_state when recieving a
## finished signal from the current State.
var state_map: Dictionary

## The current State of the character. Used to pass physics process steps and
## user input to the current state.
var current_state: State

@onready var character: Character = $".."

## Hard links to instantiated State nodes. Specific to a fixed implementation
## of Character States. This state machine can be abstracted by moving
## implementation specific details to a subclass.
## - See https://godotengine.org/asset-library/asset/2714
@onready var idle: State = $Idle
@onready var move: State = $Move
@onready var dodge: State = $Dodge


## Set up the state machine. Adds all child nodes by name to state_map and
## connects their finished signal to _change_state.
func _ready() -> void:
	for child: State in get_children():
		state_map[child.name] = child
	current_state = idle  ## Initial Character state is Idle.
	state_changed.emit(current_state.name)


## Pass inputs not already handled to the current state.
func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


## Call the current State's update function each process step.
func _physics_process(delta: float) -> void:
	current_state.update(delta)


## Cleans up the current state, switches current_state to the next state, then
## sets up the next state. This method is called by the listener for each
## State's finished signal.
func change_state(next_state: String) -> void:
	current_state.exit()
	current_state = state_map[next_state]
	current_state.enter()
	state_changed.emit(next_state)
