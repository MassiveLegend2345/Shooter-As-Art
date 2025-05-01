extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.is_in_group("bullet"):
		print("Hit by bullet!")
		get_parent().take_damage(1)
	elif body.is_in_group("player"):
		print("Hit player!")
		body.take_damage(1)
