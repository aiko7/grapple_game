extends Node2D
@onready var guy = $Timer
var penis = 1
func _ready():
	guy.start()
	

func _on_timer_timeout():
	guy.start()
	penis+=10
	print(penis)
	if penis>80:
		penis+=5

func _physics_process(delta):

	position.x+=((delta*15)+(delta*penis))
	
