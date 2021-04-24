extends KinematicBody2D

export(float) var acceleration
export(float) var max_speed
export(float) var friction

func _ready():
	print("position " + str(position))
	print("global pos " + str(global_position))

func _process(delta):
	look_at(get_global_mouse_position())
	update()
	pass

func _draw():
	draw_line(Vector2(0,0), get_local_mouse_position(), Color(255, 0, 0), 1)
