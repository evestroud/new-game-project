extends State


func enter() -> void:
	character.velocity = Vector2.ZERO


func update(_delta: float) -> void:
	if Input.get_vector("Left", "Right", "Up", "Down"):
		finished.emit("Move")
	character.look_at(character.get_global_mouse_position())


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll"):
		finished.emit("Dodge")
