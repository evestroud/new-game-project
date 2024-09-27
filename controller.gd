class_name Controller
extends Node

signal input_received(input: String)

var character: Character
var target: Vector2
var input_direction: Vector2


func _ready() -> void:
	character = owner as Character
	assert(character != null)


func _physics_process(_delta: float) -> void:
	input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	target = character.get_global_mouse_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll"):
		input_received.emit("Roll")
