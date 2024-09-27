class_name Character
extends CharacterBody2D

signal state_changed(new_state: String)


## Re-emit state changes for other entities to react to.
func _on_state_machine_state_changed(new_state: String) -> void:
	state_changed.emit(new_state)
