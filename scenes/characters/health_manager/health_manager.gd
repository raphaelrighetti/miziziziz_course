class_name HealthManager
extends Node3D

@onready var cur_health := max_health

@export var max_health := 100
@export var gib_at := -10
@export var verbose := false

signal died
signal healed
signal damaged
signal gibbed
signal health_changed(cur_health: int, max_health: int)

func _ready():
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("starting health: %s/%s" % [cur_health, max_health])

func hurt(damage_data: DamageData) -> void:
	if cur_health <= 0:
		return
	
	cur_health -= damage_data.amount
	if cur_health <= gib_at:
		gibbed.emit()
	if cur_health <= 0:
		died.emit()
	else:
		damaged.emit()
	
	health_changed.emit(cur_health, max_health)
	
	if verbose:
		print("damaged for %s, health: %s/%s" % [damage_data.amount, cur_health, max_health])

func heal(amount: int) -> void:
	if cur_health <= 0:
		return
	
	cur_health = clamp(cur_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(cur_health, max_health)
	
	if verbose:
		print("healed for %s, health: %s/%s" % [amount, cur_health, max_health])

func test_damage() -> void:
	var damage = DamageData.new()
	damage.amount = 30
	hurt(damage)

func test_heal() -> void:
	heal(10)

func _on_timer_timeout():
	test_damage()
	test_heal()
