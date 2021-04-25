extends Control

var health = 5 setget set_health
var max_health = 5 setget set_max_health

onready var bar = $Bar/TextureProgress

func set_health(value):
	health = clamp(value, 0, max_health)
	if bar != null:
		bar.value = value

func set_max_health(value):
	max_health = max(value, 1)

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	bar.max_value = max_health
	PlayerStats.connect("health_changed", self, "set_health")
	set_health(max_health)
