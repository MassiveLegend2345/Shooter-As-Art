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

	# Use the gun's global position for bullet starting position
	bullet.global_position = $".".global_position  # Assuming "Gun" is your gun node
	# Correct bullet direction using the gun's global rotation
	var gun_global_rotation = $".".global_rotation  # Gun's global rotation in radians
	bullet.direction = Vector2.RIGHT.rotated(gun_global_rotation)  # Rotate by global rotation
	bullet.rotation = gun_global_rotation  # Set bullet's rotation to match the gun's global rotation
	get_tree().current_scene.add_child(bullet)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
