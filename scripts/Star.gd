# ========================================
# STAR.GD - Attach this to your star scene
# ========================================

extends Area2D

@onready var sprite = $AnimatedSprite2D  # or whatever your star visual node is
@onready var collision = $CollisionShape2D
@onready var sfx_player = $AudioStreamPlayer


# Optional: Add some visual flair
var bob_speed = 2.0
var bob_height = 5.0
var time_passed = 0.0
var original_y_position

func _ready():
	# Connect the area entered signal
	body_entered.connect(_on_body_entered)
	
	# Store original position for bobbing animation
	if sprite:
		original_y_position = sprite.position.y
	
	# Optional: Add some random offset to make stars bob at different times
	time_passed = randf() * PI * 2

func _process(delta):
	# Optional: Make stars gently bob up and down
	time_passed += delta
	if sprite:
		sprite.position.y = original_y_position + sin(time_passed * bob_speed) * bob_height

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player"):
		collect_star()

func collect_star():
	GameManager.collect_star()
	
	# Detach SFX so it continues playing after node is freed
	var sfx = sfx_player.duplicate()
	get_parent().add_child(sfx)
	sfx.play()
	
	queue_free()  # Now safe to remove star

	# Optional: Simple scale-up animation before disappearing
