extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 500
@export var min_spawn_distance: float = 200
@export var enemies_per_wave: int = 5
@export var wave_cooldown: float = 3.0
@export var spawn_delay: float = 0.5

var current_wave: int = 0
var player: Node2D
var wave_timer: Timer

func _ready():
	# Create a simple timer for waves
	wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.timeout.connect(start_next_wave)
	
	player = get_tree().get_first_node_in_group("player")
	if enemy_scene == null:
		printerr("Enemy scene not assigned to spawner!")
		return
	if player == null:
		printerr("Player not found in 'player' group!")
		return
	
	# Start first wave immediately
	start_next_wave()
	# Set up recurring waves
	wave_timer.start(wave_cooldown + (enemies_per_wave * spawn_delay))

func start_next_wave():
	current_wave += 1
	print("Wave %d started" % current_wave)
	
	for i in range(enemies_per_wave):
		try_spawn_enemy()
		await get_tree().create_timer(spawn_delay).timeout

func try_spawn_enemy():
	var spawn_position = Vector2.ZERO
	var valid_position = false
	
	# Simple position finding (5 attempts)
	for attempts in range(5):
		var angle = randf() * TAU
		var distance = randf_range(min_spawn_distance, spawn_radius)
		spawn_position = player.global_position + Vector2(cos(angle), sin(angle)) * distance
		valid_position = true
		break
	
	if valid_position:
		spawn_enemy(spawn_position)

func spawn_enemy(position: Vector2):
	var enemy = enemy_scene.instantiate()
	enemy.global_position = position
	
	if enemy.has_method("set_player"):
		enemy.set_player(player)
	
	get_tree().current_scene.add_child(enemy)
	
	if enemy.has_signal("died"):
		enemy.died.connect(_on_enemy_died.bind(enemy))

func _on_enemy_died(enemy):
	if enemy.is_connected("died", _on_enemy_died):
		enemy.died.disconnect(_on_enemy_died)
