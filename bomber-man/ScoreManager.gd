extends Node

signal kills_changed(count)
signal health_changed(health)

var kill_count: int = 0:
	set(value):
		kill_count = value
		emit_signal("kills_changed", kill_count)

var player_health: int = 5:
	set(value):
		player_health = value
		emit_signal("health_changed", player_health)

func add_kill():
	kill_count += 1

func record_damage(amount: int):
	player_health -= amount
	print("Health:", player_health)
	if player_health <= 0:
		player_died()

func player_died():
	print("PLAYER DIED (via ScoreManager)")
