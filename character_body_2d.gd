extends CharacterBody2D

@onready var roll_timer: Timer = $RollTimer
var rotation_speed: float = TAU / roll_timer.wait_time

@export var base_speed: int = 150
@export var roll_speed: int = 250
@export var roll_direction: Vector2 = Vector2.ZERO


func get_input_direction() -> Vector2:
	return Input.get_vector("Left", "Right", "Up", "Down")

func _physics_process(delta: float) -> void:
	if roll_timer.is_stopped():
		velocity = get_input_direction() * base_speed
		look_at(get_global_mouse_position())
	else:
		velocity = roll_direction * roll_speed
		rotate(rotation_speed * delta)
	var _collided: bool = move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll") and roll_timer.is_stopped():
		roll_direction = get_input_direction()
		roll_timer.start()

# currently doesn't do anything but may be a useful hook later
func _on_roll_timer_timeout() -> void:
	pass
