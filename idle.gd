extends State


func update(_delta: float) -> void:
	if Input.get_vector("Left", "Right", "Up", "Down"):
		finished.emit("Move")


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("Roll"):
		finished.emit("Dodge")
