class_name Ship
extends KinematicBody2D

signal no_health
signal health_changed(value)

var max_health: int = 5
var health: int = 5 setget set_health

export (float) var acceleration = 2
export (float) var max_speed = 128
export (float) var friction = 1
var rotation_speed: float = 4
var velocity: Vector2 = Vector2.ZERO

onready var turret := $Turret

export var bullet_scene: PackedScene
var can_shoot: bool = true
onready var shoot_cooldown: Timer = $Timers/ShootCooldown
export (float) var fire_rate = 0.2 
onready var screen_shake = $Camera2D/ScreenShake
export (int) var damage = 1

func _physics_process(delta):
	rotate_turret()
	controls(delta)
	velocity = velocity.clamped(max_speed)
	velocity = move_and_slide(velocity)
	print(velocity)

func controls(delta):
	var rot_dir = 0

	if Input.is_action_pressed("rotate_right"):
		rot_dir += 1
	if Input.is_action_pressed("rotate_left"):
		rot_dir -= 1
	
	rotation += rotation_speed * rot_dir * delta
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
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
	bullet.damage = damage
	bullet.look_at(get_global_mouse_position())
	screen_shake.start(0.1, 6, 10, 1)
	can_shoot = false
	shoot_cooldown.start(fire_rate)

func _on_ShootCooldown_timeout():
	can_shoot = true


func _on_Hurtbox_area_entered(area):
	health -= area.get_parent().damage
	screen_shake.start(0.2, 10, 13, 2)
	area.get_parent().queue_free()

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		queue_free()