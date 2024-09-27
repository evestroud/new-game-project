extends State


func enter() -> void:
	state_machine.character.velocity = Vector2.ZERO


func update(_delta: float) -> void:
	if Input.get_vector("Left", "Right", "Up", "Down"):
		state_machine.change_state("Move")
	state_machine.character.look_at(state_machine.character.get_global_mouse_position())


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll"):
		state_machine.change_state("Dodge")
