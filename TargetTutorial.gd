extends Node2D

signal open
var done: bool = false

func _physics_process(delta):
	if get_child_count() == 0 and done == false:
		done = true
		emit_signal("open")
