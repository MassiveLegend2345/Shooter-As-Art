extends Node2D

@export var bullet_scene: PackedScene
@export var fire_rate: float = 0.3
var fire_timer := 0.0

func _process(delta):
	fire_timer += delta

	# Only fire if fire button is pressed and cooldown has passed
	if Input.is_action_pressed("fire") and fire_timer >= fire_rate:
		fire_timer = 0.0
		shoot()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	bullet.rotation = rotation
	get_tree().current_scene.add_child(bullet)
