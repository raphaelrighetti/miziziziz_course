class_name CharacterMover
extends Node3D

@export var jump_force := 15.0
@export var gravity := 15.0

@export var max_speed := 15.0
@export var move_acceleration := 4.0
@export var stop_drag := 0.9

var character_body: CharacterBody3D
var move_drag: float
var move_dir: Vector3

func _ready():
	character_body = get_parent()
	move_drag = move_acceleration / max_speed

func set_move_dir(new_move_dir: Vector3):
	move_dir = new_move_dir

func jump():
	if character_body.is_on_floor():
		character_body.velocity.y = jump_force

func _physics_process(delta):
	# preventing player from getting stuck on ceiling, stopping the jump as they hit it
	if character_body.velocity.y > 0.0 and character_body.is_on_ceiling():
		character_body.velocity.y = 0.0
	# applying gravity
	if not character_body.is_on_floor():
		character_body.velocity.y -= gravity * delta
	
	var drag = move_drag
	if move_dir.is_zero_approx():
		drag = stop_drag
	
	var flat_velocity = character_body.velocity
	flat_velocity.y = 0.0
	character_body.velocity += move_acceleration * move_dir - flat_velocity * drag
	
	character_body.move_and_slide()
