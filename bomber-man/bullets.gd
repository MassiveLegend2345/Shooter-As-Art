extends RigidBody2D
# Bullet speed
@export var speed: float = 600.0

# Lifetime before it auto-destroys
@export var lifetime: float = 1.0
var life_timer: float = 0.0

# Direction should be set before firing (normalized vector)
var direction: Vector2 = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	life_timer += delta
	if life_timer >= lifetime:
		queue_free() # Auto-destroy after lifetime
	pass
func _ready():
	# Apply initial velocity
	linear_velocity = direction * speed
	add_to_group("bullet")  # Important for detection



func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Destroy when it leaves the screen

func _on_Bullet_body_entered(body):
	if body.is_in_group("destroyable"):
		body.queue_free()  # Destroy the object
	queue_free()  # Destroy the bullet
pass
