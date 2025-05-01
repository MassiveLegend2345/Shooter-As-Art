extends Sprite2D

@export var move_speed: float = 35.0
@export var health: int = 3
@export var damage_to_player: int = 1
@export var score_value: int = 100
@export var death_sfx: AudioStream
var player: Node2D = null
var can_take_damage: bool = true
var damage_cooldown: float = 0.5

signal enemy_died(score_value)
signal enemy_hit

func set_player(player_node: Node2D):
	player = player_node
func _physics_process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return
	
	
	# Movement toward player
	var direction = (player.global_position - global_position).normalized()
	position += direction * move_speed * delta

func take_damage(amount: int):
	if !can_take_damage or is_queued_for_deletion():
		return
		
	health -= amount
	emit_signal("enemy_hit")
	
	# Visual feedback on hit
	modulate = Color.GREEN  # Changed to red for hit effect
	var hit_tween = create_tween()
	hit_tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	if health <= 0:
		print("Enemy died!")
		ScoreManager.add_kill()
		emit_signal("enemy_died", score_value)
		
		if death_sfx:
			var sound = AudioStreamPlayer2D.new()
			sound.stream = death_sfx
			sound.finished.connect(sound.queue_free)
			get_parent().add_child(sound)
			sound.global_position = global_position
			sound.play()
		# Death fade-out effect (add just these 3 lines)
		var death_tween = create_tween()
		death_tween.tween_property(self, "modulate:a", 0.0, 0.5)
		death_tween.tween_callback(queue_free)
		
		return  # Skip damage cooldown if dying
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		# Damage player
		if body.has_method("take_damage"):
			body.take_damage(damage_to_player)
			
		modulate = Color.WHITE
		modulate = Color.GREEN
		
		# Knockback effect (optional)
		var knockback_direction = (global_position - body.global_position).normalized()
		position += knockback_direction * 6699
