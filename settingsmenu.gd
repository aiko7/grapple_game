extends CanvasLayer

@onready var master_slider = $Panel/MasterVolumeSlider
@onready var music_slider = $Panel/MusicVolumeSlider
@onready var back_button = $Panel/BackButton

func _ready():
	master_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	music_slider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music"))

	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	back_button.pressed.connect(_on_back_pressed)

func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)


func _on_back_pressed():
	hide()
	# Show pause menu again
