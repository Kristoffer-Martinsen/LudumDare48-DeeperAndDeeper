extends Node2D

onready var menu_sound := $MenuSound

func _on_BackButton_pressed():
	get_tree().change_scene("res://GUI/MainMenu/MainMenu.tscn")

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Game.tscn")

func _on_BackButton_mouse_entered():
	if !menu_sound.playing:
		menu_sound.play()

func _on_PlayButton_mouse_entered():
	if !menu_sound.playing:
		menu_sound.play()
