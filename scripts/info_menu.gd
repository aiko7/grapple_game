extends Panel

@onready var back_button = $BackButton

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	

func _on_back_pressed():
	hide()
	get_parent().get_node("PauseMenu").show()
