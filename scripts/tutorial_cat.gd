extends Node2D

@export_multiline var text_area: String = ""

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var cat_menu: Panel = $CatMenu

var text_label: RichTextLabel

signal leftInfoArea()

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	cat_menu.global_position.y -= cat_menu.size.y*cat_menu.scale.y + 15
	cat_menu.global_position.x -= (cat_menu.size.x*cat_menu.scale.x)/2
	
	text_label = cat_menu.get_child(0)
	
	if text_area != "":
		text_label.clear()
		text_label.append_text(text_area)
	
	if self.scale.x <= 0:
		cat_menu.scale.x *= -1

func _on_interact():
	cat_menu.show()
	await leftInfoArea

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Cat_Spawn":
		interaction_area.activate()
		interaction_area.manual_in_area_check()

func _on_info_area_body_exited(body: Node2D) -> void:
	cat_menu.hide()
	leftInfoArea.emit()
