extends CharacterBody2D

@onready var rotation_speed = TAU / $RollTimer.wait_time

@export var base_speed = 150
@export var roll_speed = 250
@export var roll_direction = Vector2.ZERO

func get_input_direction() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _physics_process(delta) -> void:
	if $RollTimer.is_stopped():
		velocity = get_input_direction() * base_speed
		look_at(get_global_mouse_position())
	else:
		velocity = roll_direction * roll_speed
		rotate(rotation_speed * delta)
	move_and_slide()

func _input(event) -> void:
	if event.is_action_pressed("Roll") and $RollTimer.is_stopped():
		roll_direction = get_input_direction()
		$RollTimer.start()

func _on_roll_timer_timeout() -> void:
	roll_direction = Vector2.ZERO
