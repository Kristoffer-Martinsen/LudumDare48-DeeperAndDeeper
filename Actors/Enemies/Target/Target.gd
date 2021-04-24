extends Area2D



func _on_Hurtbox_area_entered(area):
	area.get_owner().queue_free()
	queue_free()
