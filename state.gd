class_name State
extends Node
## Interface for states used by state_machine

## Reference to the Character this State is a part of.
@onready var state_machine: StateMachine = $".."


## Sets up any local variables used by the State (timers, counters, etc.).
## Called by state_machine when changing to this State.
func enter() -> void:
	pass


## Performs any teardown needed when the state is finished.
## Called by state_machine when changing from this State.
func exit() -> void:
	pass


## Processes behavior of the state. finished should be emitted here if the
## State ends due to a game condition.
## Called by _physics_process in state_machine.
func update(_delta: float) -> void:
	pass


## Handles player input relevant to the state. finished should be emitted here
## if the State ends due to player input.
## Called by _unhandled_input in state_machine.
func handle_input(_event: InputEvent) -> void:
	pass
