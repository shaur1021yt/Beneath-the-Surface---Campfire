extends CharacterBody2D

const GRAVITY = 1200.0
const MOVE_SPEED = 300.0
const MAX_FALL_SPEED = 900.0

var spawn_position : Vector2

func _ready():
	spawn_position = global_position

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)

	# Left / Right Movement
	var dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * MOVE_SPEED

	move_and_slide()

	# Death check
	if global_position.y > 2000:
		die()

func die():
	global_position = spawn_position
	velocity = Vector2.ZERO
