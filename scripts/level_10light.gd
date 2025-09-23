extends Node2D
@onready var guy = $Timer
@onready var player = $Player
var penis = 1

func _ready():
	guy.start()
	player.get_child(3).get_child(0).environment.tonemap_exposure=0.01
	

func _on_timer_timeout():
	guy.start()
	
	penis+=1
	if penis==10:
		penis-=9

func _physics_process(delta):
	
	if penis<4:
		player.get_child(3).get_child(0).environment.tonemap_exposure+=1
		#print(player.get_child(3).get_child(0).environment.tonemap_exposure)
	elif penis<6:
		pass
	elif penis<8:			
		player.get_child(3).get_child(0).environment.tonemap_exposure-=1.5
		#print(player.get_child(3).get_child(0).environment.tonemap_exposure)	
