extends State

@export var base_speed: int = 150
@export var run_modifier: float = 1.5


func update(_delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	if input_direction.is_zero_approx():
		finished.emit("Idle")

	var is_running: bool = Input.is_action_pressed("Run")
	character.velocity = input_direction.normalized() * base_speed
	if is_running:
		character.velocity *= run_modifier
	if character.move_and_slide():
		# any collision logic will go here
		pass
	character.look_at(character.get_global_mouse_position())


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll"):
		finished.emit("Dodge")
