extends State


func enter() -> void:
	state_machine.character.velocity = Vector2.ZERO


func update(_delta: float) -> void:
	if state_machine.character.controller.input_direction:
		state_machine.change_state("Move")
	state_machine.character.look_at(state_machine.character.controller.target)


func handle_input(event: String) -> void:
	if event == "Roll":
		state_machine.change_state("Dodge")
