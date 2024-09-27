extends CharacterBody2D

signal state_changed(new_state: String)


func _on_state_machine_state_changed(new_state: String) -> void:
	state_changed.emit(new_state)
