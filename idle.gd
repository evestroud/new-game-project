extends State


func update(_delta: float) -> void:
	if Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")):
		finished.emit("Move")
