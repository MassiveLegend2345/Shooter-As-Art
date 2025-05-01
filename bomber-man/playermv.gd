extends RigidBody2D

@export var engine_power = 800
@export var double_power = 1200
@export var spin_power = 10000
@export var lives:int = 100
var thrust = Vector2.ZERO
var rotation_dir = 0
var esc = KEY_ESCAPE
var shift = KEY_SHIFT
var can_fire = true
@export var max_health: int = 5
var health = 3
@onready var sprite = $player  # Make sure this path matches your sprite node
func take_damage(amount):
	health -= amount
	flash_red()  # Trigger flash effect
	ScoreManager.record_damage(amount)  # Pass the actual amount
	print("Player Health:", health)

	if health <= 0:
		die()
var score: int = 0

func update_health_ui():
	pass
#	Hud.update_health(health)

func die():
	print("Player died!")
	get_tree().change_scene_to_file("res://gameover.tscn")		
	# Or go to game over scene: get_tree().change_scene_to_file("res://GameOver.tscn")

func _on_enemy_died(score_value):
	score += score_value
	
func flash_red():
	# Immediately turn red
	sprite.modulate = Color(1, 0, 0)  # Full red
	
	# Create a tween to fade back to white
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)

func _ready():
	add_to_group("player")
	health = max_health
	print_tree()
	update_health_ui()

func respawn():
	# Tween my scale using elastic
	scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 1)
	
	position = Vector2.ZERO
	rotation = randf_range(0, TAU)
	# Randomly vary the pitch of the audio and play it

func _on_RigidBody2D_area_entered(area):
	if area.get_parent().name.begins_with("shidstain"):
		get_tree().quit()
	pass

func _on_area_entered(area: Area2D) -> void:
	print ("collided")
	print(area)
	area.queue_free()
pass


func get_input():
	thrust = Vector2.ZERO
	if Input.is_action_pressed("thrust"):
		thrust -= transform.y * engine_power
	rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://Menu for bomb ber.tscn")		
	#if Input.is_action_pressed("e"):
		#thrust -= transform.y * double_power
		rotation_dir = Input.get_axis("rotate_left", "rotate_right")
	pass
func _physics_process(delta: float) -> void:
	get_input()
	constant_force = thrust
	constant_torque = rotation_dir * spin_power
	pass 
pass
