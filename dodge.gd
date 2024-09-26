extends State

var timer: Timer = Timer.new()


func enter() -> void:
	timer.wait_time = 0.5
	var err: int = timer.timeout.connect(func() -> void: finished.emit("Idle"))
	if err:
		printerr(err)
	else:
		timer.autostart = true


func _on_roll_timer_timeout() -> void:
	if Input.get_vector("Left", "Right", "Up", "Down"):
		finished.emit("Move")
	else:
		finished.emit("Idle")
