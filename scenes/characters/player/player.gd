class_name Player
extends CharacterBody3D

@onready var camera := $Camera3D
@onready var character_mover: CharacterMover = $CharacterMover
@onready var health_manager: HealthManager = $HealthManager
@onready var weapon_manager = $Camera3D/WeaponManager

@export var mouse_sensitivity_h := 0.15
@export var mouse_sensitivity_v := 0.15

var dead := false

func _ready():
	# hiding the cursor
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	health_manager.died.connect(kill.bind())

func _input(event):
	if dead:
		return
	
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity_h
		camera.rotation_degrees.x -= event.relative.y * mouse_sensitivity_v
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			weapon_manager.switch_next_weapon()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			weapon_manager.switch_previous_weapon()

func _process(_delta):
	handle_movement()
	handle_not_in_game_actions()

func handle_movement() -> void:
	if dead:
		return
	
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	character_mover.set_move_dir(move_dir)
	
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()

func handle_not_in_game_actions() -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var is_full_screen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if is_full_screen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func kill() -> void:
	dead = true
	character_mover.set_move_dir(Vector3.ZERO)
