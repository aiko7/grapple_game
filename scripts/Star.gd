# STAR.GD (modified)
extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@onready var sfx_player = $AudioStreamPlayer

var bob_speed = 2.0
var bob_height = 5.0
var time_passed = 0.0
var original_y_position

func _ready():
	# ensure this node is in the "Star" group so GameManager can count it
	if not is_in_group("Star"):
		add_to_group("Star")

	# Connect the body_entered signal
	body_entered.connect(_on_body_entered)

	# bobbing setup
	if sprite:
		original_y_position = sprite.position.y
	time_passed = randf() * PI * 2


func _process(delta):
	time_passed += delta
	if sprite:
		sprite.position.y = original_y_position + sin(time_passed * bob_speed) * bob_height

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player"):
		collect_star()

func collect_star():
	# Tell the game manager
	GameManager.collect_star()
	# Detach SFX so it plays after freeing
	var sfx = sfx_player.duplicate()
	get_parent().add_child(sfx)
	sfx.play()
	queue_free()
