class_name Ship
extends KinematicBody2D

onready var stats: Node = PlayerStats
onready var screen_shake = $Camera2D/ScreenShake
export var bullet_scene: PackedScene
onready var turret := $Turret
onready var shoot_cooldown: Timer = $Timers/ShootCooldown
onready var shoot_sound := $ShootSound
onready var hit_sound = $HitSound
onready var death_sound = $DeathSound

export (float) var acceleration = 2
export (float) var max_speed = 128
export (float) var friction = 1
var rotation_speed: float = 4
var velocity: Vector2 = Vector2.ZERO

var can_shoot: bool = true
export (float) var fire_rate = 0.2 
export (int) var damage = 1

func _ready():
	stats.connect("no_health", self, "_on_Stats_no_health")

func _physics_process(delta):
	rotate_turret()
	controls(delta)
	velocity = velocity.clamped(max_speed)
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
	shoot_sound.play()
	bullet.position = position
	bullet.damage = damage
	bullet.look_at(get_global_mouse_position())
	screen_shake.start(0.1, 6, 10, 1)
	can_shoot = false
	shoot_cooldown.start(fire_rate)

func _on_ShootCooldown_timeout():
	can_shoot = true

func _on_Hurtbox_area_entered(area):
	stats.health -= area.get_parent().damage
	hit_sound.play()
	screen_shake.start(0.2, 10, 13, 2)
	area.get_parent().queue_free()

func _on_Stats_no_health():
	death_sound.play()

func _on_DeathSound_finished():
	queue_free()
