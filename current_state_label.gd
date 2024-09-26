extends Label

@onready var character: CharacterBody2D = $"../Character"


func _process(_delta: float) -> void:
	position = character.position + Vector2(-15, -65)


func _on_character_state_changed(new_state: String) -> void:
	text = new_state
