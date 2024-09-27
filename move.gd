extends State

@export var base_speed: int = 150
@export var run_modifier: float = 1.5


func update(_delta: float) -> void:
	var input_direction: Vector2 = state_machine.character.controller.input_direction
	if input_direction.is_zero_approx():
		state_machine.change_state("Idle")

	var is_running: bool = Input.is_action_pressed("Run")
	state_machine.character.velocity = input_direction.normalized() * base_speed
	if is_running:
		state_machine.character.velocity *= run_modifier
	if state_machine.character.move_and_slide():
		# any collision logic will go here
		pass
	state_machine.character.look_at(state_machine.character.controller.target)


func handle_input(input: String) -> void:
	print(input)
	if input == "Roll":
		state_machine.change_state("Dodge")
