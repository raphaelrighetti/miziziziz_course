class_name WeaponManager
extends Node3D

@onready var weapons = $Weapons.get_children()

@export var verbose := false

var weapons_unlocked = []
var cur_slot := 0
var cur_weapon

func _ready():
	for _i in range(weapons.size()):
		#weapons_unlocked.append(false)
		weapons_unlocked.append(true)

func disable_all_weapons() -> void:
	for weapon in weapons:
		if weapon.has_method("set_active"):
			weapon.set_ative(false)
		else:
			weapon.hide()

func switch_previous_weapon() -> void:
	#for i in range(weapons.size()):
		#var wrapped_index: int = wrapi(cur_slot - 1 - i, 0, weapons.size())
		#if !can_switch_weapon_slot(wrapped_index):
			#return
		#switch_weapon_slot(wrapped_index)
	var index :=

func switch_next_weapon() -> void:
	for i in range(weapons.size()):
		var wrapped_index: int = wrapi(cur_slot + 1 + i, 0, weapons.size())
		if !can_switch_weapon_slot(wrapped_index):
			return
		switch_weapon_slot(wrapped_index)

func get_weapon_index() -> int:
	return 1

func switch_weapon_slot(slot_index: int) -> void:
	if !can_switch_weapon_slot(slot_index):
		return
	
	disable_all_weapons()
	cur_slot = slot_index
	cur_weapon = weapons[cur_slot]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active(true)
	else:
		cur_weapon.show()

func can_switch_weapon_slot(slot_index: int) -> bool:
	if slot_index >= weapons.size() or slot_index < 0:
		if verbose:
			print("deu merda 1")
		return false
	if weapons_unlocked.size() == 0 or !weapons_unlocked[slot_index]:
		if verbose:
			print("deu merda 2")
		return false
	
	if verbose:
		print("deu bom carai")
	return true
