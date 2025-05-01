extends CanvasLayer

@onready var kill_label = $KillLabel
@onready var health_label = $HealthLabel

func _ready():
	# Connect to ScoreManager signals (you'll need to add these to ScoreManager)
	ScoreManager.connect("kills_changed", update_kills)
	ScoreManager.connect("health_changed", update_health)
	
	# Initialize the labels
	update_kills(ScoreManager.kill_count)
	update_health(ScoreManager.player_health)

func update_kills(count: int):
	if kill_label:
		kill_label.text = "People Made Happy: %d" % count

func update_health(health: int):
	if health_label:
		health_label.text = "HP: %d" % health
