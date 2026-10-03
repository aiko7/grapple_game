extends Area2D
class_name InteractionArea

@export var action_name: String = "INTERACT"

var isActive = false
var inArea = false

var interact: Callable = func():
	pass

func activate():
	isActive = true

func deactivate():
	isActive = false

func _on_body_entered(_body: Node2D) -> void:
	inArea = true
	if isActive:
		InteractionManager.register_area(self)

func _on_body_exited(_body: Node2D) -> void:
	inArea = false
	InteractionManager.unregister_area(self)

func manual_in_area_check():
	if inArea:
		InteractionManager.register_area(self)
