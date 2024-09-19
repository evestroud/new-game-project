extends CharacterBody2D

var speed = 150
var roll_speed = 250
@onready var rotation_speed = TAU / $RollTimer.wait_time
var current_velocity = Vector2.ZERO # The player's movement vector.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $RollTimer.is_stopped():
		current_velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("Right"):
			current_velocity.x += 1
		if Input.is_action_pressed("Left"):
			current_velocity.x -= 1
		if Input.is_action_pressed("Down"):
			current_velocity.y += 1
		if Input.is_action_pressed("Up"):
			current_velocity.y -= 1
		
		var mouse_pos = get_viewport().get_mouse_position() * get_viewport_transform()
		rotation = position.angle_to_point(mouse_pos) + (PI / 2)
	else:
		rotate(rotation_speed * delta)
		
	if current_velocity.length() > 0:
		current_velocity = current_velocity.normalized() * (speed if $RollTimer.is_stopped() else roll_speed)
		move_and_slide()
		
	position += current_velocity * delta
	

func _input(event):
	if event.is_action_pressed("Roll") and $RollTimer.is_stopped():
		current_velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("Right"):
			current_velocity.x += 1
		if Input.is_action_pressed("Left"):
			current_velocity.x -= 1
		if Input.is_action_pressed("Down"):
			current_velocity.y += 1
		if Input.is_action_pressed("Up"):
			current_velocity.y -= 1
		
		$RollTimer.start()
