extends State

enum RelativeDirection {HOLDING_POSITION, ADVANCING, RETREATING, SIDESTEPPING_CW, SIDESTEPPING_CCW}

@export var dodge_speed: int = 250
@export var dodge_time: float = 0.5
var rotation_speed: float = TAU / dodge_time
var timer: Timer
var relative_direction: RelativeDirection


func enter() -> void:
	var input_direction: Vector2 = state_machine.character.controller.input_direction
	relative_direction = get_relative_direction()
	state_machine.character.velocity = input_direction.normalized() * dodge_speed

	timer = Timer.new()
	timer.wait_time = dodge_time
	timer.autostart = true
	add_child(timer)
	var err: int = timer.timeout.connect(_on_timer_timeout)
	if err:
		printerr(err)
		# If timer fails to connect, need to exit state immediately
		state_machine.change_state("Idle")


func exit() -> void:
	remove_child(timer)


func update(delta: float) -> void:
	match relative_direction:
		RelativeDirection.HOLDING_POSITION:
			state_machine.character.transform = (
				state_machine.character.transform.orthonormalized()
				* Transform2D(
					Vector2(cos(2 * TAU * timer.time_left), 0),
					Vector2(0, cos(2 * TAU * timer.time_left)),
					Transform2D.IDENTITY.origin
				)
			)
		RelativeDirection.ADVANCING, RelativeDirection.RETREATING:
			state_machine.character.transform = (
				state_machine.character.transform.orthonormalized()
				* Transform2D(
					Vector2(cos(2 * TAU * timer.time_left), 0),
					Transform2D.IDENTITY.y,
					Transform2D.IDENTITY.origin
				)
			)
		RelativeDirection.SIDESTEPPING_CCW:
			state_machine.character.rotate(rotation_speed * delta * -1)
		RelativeDirection.SIDESTEPPING_CW:
			state_machine.character.rotate(rotation_speed * delta)
	if state_machine.character.move_and_slide():
		# any collision logic will go here
		pass


func _on_timer_timeout() -> void:
	state_machine.character.transform.x = Transform2D.IDENTITY.x
	state_machine.character.transform.y = Transform2D.IDENTITY.y
	state_machine.character.look_at(state_machine.character.controller.target)
	if state_machine.character.controller.input_direction:
		state_machine.change_state("Move")
	else:
		state_machine.change_state("Idle")


func get_relative_direction() -> RelativeDirection:
	if state_machine.character.velocity.is_zero_approx():
		return RelativeDirection.HOLDING_POSITION
	var relative_movement_vector: Vector2 = Vector2.from_angle(
		state_machine.character.rotation - state_machine.character.velocity.angle()
	)
	if abs(relative_movement_vector.x) > abs(relative_movement_vector.y):
		return (
			RelativeDirection.ADVANCING
			if relative_movement_vector.x > 0
			else RelativeDirection.RETREATING
		)
	return (
		RelativeDirection.SIDESTEPPING_CW
		if relative_movement_vector.y > 0
		else RelativeDirection.SIDESTEPPING_CCW
	)
