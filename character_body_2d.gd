extends CharacterBody2D

@onready var roll_timer: Timer = $RollTimer
@onready var rotation_speed: float = TAU / roll_timer.wait_time

@export var base_speed: int = 150
@export var roll_speed: int = 250
@export var running_speed_modifier: float = 1.5

var roll_direction: Vector2
var roll_type: RelativeDirection
var is_jump_roll: bool

enum RelativeDirection {HOLDING_POSITION, ADVANCING, RETREATING, SIDESTEPPING_CW, SIDESTEPPING_CCW}


func get_relative_direction(movement_angle: float) -> RelativeDirection:
	if velocity.is_zero_approx():
		return RelativeDirection.HOLDING_POSITION
	# TODO experiment with match statement here?
	var relative_movement_vector: Vector2 = Vector2.from_angle(rotation - movement_angle)
	if abs(relative_movement_vector.x) > abs(relative_movement_vector.y):
		return (
			RelativeDirection.ADVANCING
			if relative_movement_vector.x > 0
			else RelativeDirection.RETREATING
		)
	else:
		return (
			RelativeDirection.SIDESTEPPING_CW
			if relative_movement_vector.y > 0
			else RelativeDirection.SIDESTEPPING_CCW
		)


func get_input_direction() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")


func is_running() -> bool:
	return Input.is_action_pressed("Run")


func _physics_process(delta: float) -> void:
	if roll_timer.is_stopped():
		velocity = get_input_direction() * base_speed
		if is_running():
			velocity *= running_speed_modifier
		look_at(get_global_mouse_position())
		var _relative_movement: RelativeDirection = get_relative_direction(velocity.angle())
		# TODO set movement direction based on relative direction to target
		# 	- Advance and Retreat are linear directed at target
		# 	- Try initiation side rolls in a straight line tangent to the target
	else:
		velocity = roll_direction * roll_speed
		if is_jump_roll:
			velocity *= running_speed_modifier
		match roll_type:
			RelativeDirection.HOLDING_POSITION:
				transform = (
					transform.orthonormalized()
					* Transform2D(
						Vector2(cos(2 * TAU * roll_timer.time_left), 0),
						Vector2(0, cos(2 * TAU * roll_timer.time_left)),
						Transform2D.IDENTITY.origin
					)
				)
			RelativeDirection.ADVANCING, RelativeDirection.RETREATING:
				transform = (
					transform.orthonormalized()
					* Transform2D(
						Vector2(cos(2 * TAU * roll_timer.time_left), 0),
						Transform2D.IDENTITY.y,
						Transform2D.IDENTITY.origin
					)
				)
			RelativeDirection.SIDESTEPPING_CCW:
				rotate(rotation_speed * delta * -1)
			RelativeDirection.SIDESTEPPING_CW:
				rotate(rotation_speed * delta)
	var _collided: bool = move_and_slide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll") and roll_timer.is_stopped():
		roll_direction = get_input_direction()
		roll_type = get_relative_direction(roll_direction.angle())
		is_jump_roll = is_running()
		roll_timer.start()


func _on_roll_timer_timeout() -> void:
	transform.x = Transform2D.IDENTITY.x
	transform.y = Transform2D.IDENTITY.y
	look_at(get_global_mouse_position())
