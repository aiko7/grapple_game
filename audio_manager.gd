extends Node

@onready var jump_player    = $jump
@onready var walk_player    = $walk
@onready var land_player    = $land
@onready var death_player   = $death
@onready var grapple_player = $grapple
@onready var portal_player  = $portal
#@onready var bg_player = $bg


func play_jump():
	jump_player.play()

func play_walk():
	if not walk_player.playing:
		walk_player.play()

func stop_walk():
	if walk_player.playing:
		walk_player.stop()

func play_land():
	land_player.play()

func play_death():
	death_player.play()

func play_grapple():
	grapple_player.play()

func play_portal():
	portal_player.play()
