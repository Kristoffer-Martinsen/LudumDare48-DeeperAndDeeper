class_name Ship
extends KinematicBody2D

export (float) var acceleration = 8
export (float) var max_speed = 16
export (float) var friction = 1
var rotation_speed: float = 4
var velocity: Vector2 = Vector2.ZERO

onready var turret := $Turret

export var bullet_scene: PackedScene
var can_shoot: bool = true
onready var shoot_cooldown: Timer = $Timers/ShootCooldown
export (float) var fire_rate = 0.2 

func _physics_process(delta):
	rotate_turret()
	controls(delta)
	velocity = move_and_slide(velocity)

func controls(delta):
	var rot_dir = 0

	if Input.is_action_pressed("rotate_right"):
		rot_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rot_dir -= 1
	
	rotation += rotation_speed * rot_dir * delta
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()


	# TODO: Improve movement. Specifically making moving opposite to the current
	# TODO: velocity more influential
	if Input.is_action_pressed("thrust"):
		velocity += Vector2(acceleration, 0).rotated(rotation)
	if Input.is_action_pressed("brake"):
		velocity += Vector2(-acceleration, 0).rotated(rotation)
	
	if !Input.is_action_pressed("thrust") and !Input.is_action_pressed("brake"):
		velocity = velocity.move_toward(Vector2.ZERO, friction)
	

func rotate_turret():
	turret.look_at(get_global_mouse_position())
	if turret.rotation_degrees < -360:
		turret.rotation_degrees = 0
	if turret.rotation_degrees > 360:
		turret.rotation_degrees = 0

func shoot():
	var bullet = bullet_scene.instance()
	get_tree().get_root().add_child(bullet)
	bullet.position = position
	bullet.look_at(get_global_mouse_position())
	can_shoot = false
	shoot_cooldown.start(fire_rate)

func _on_ShootCooldown_timeout():
	can_shoot = true
