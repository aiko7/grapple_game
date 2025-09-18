extends Panel

@onready var master_slider = $MasterVolumeSlider
@onready var music_slider = $MusicVolumeSlider
@onready var back_button = $BackButton

func _ready():

	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	back_button.pressed.connect(_on_back_pressed)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),master_slider.value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_slider.value)

func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),value)

func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_back_pressed():
	hide()
	get_parent().get_node("PauseMenu").show()
