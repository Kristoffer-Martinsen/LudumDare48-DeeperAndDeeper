extends Area2D

signal died

func _on_Hurtbox_area_entered(area):
	area.get_owner().queue_free()
	emit_signal("died")
	queue_free()
