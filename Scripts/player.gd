extends CharacterBody2D
class_name Player

signal air

const GRAVITY := 1200.0
const MOVE_SPEED := 300.0
const MAX_FALL_SPEED := 900.0

@export var unlock_y_position: float = 800.0

var control_locked := false
var spawn_position: Vector2

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	spawn_position = global_position

func _physics_process(delta):
	apply_gravity(delta)
	handle_movement()
	move_and_slide()
	update_animation()

# -------------------------
# GRAVITY
# -------------------------

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	velocity.y = min(velocity.y, MAX_FALL_SPEED)

# -------------------------
# MOVEMENT
# -------------------------

func handle_movement():
	# Only allow movement if:
	# 1. Dialogue is NOT active
	# 2. Player has fallen past unlock_y_position
	
	if control_locked:
		velocity.x = 0
		return
	
	if global_position.y < unlock_y_position:
		velocity.x = 0
		return
	
	var dir := Input.get_axis("ui_LEFT", "ui_RIGHT")
	velocity.x = dir * MOVE_SPEED

# -------------------------
# ANIMATION
# -------------------------

func update_animation():
	if not is_on_floor():
		anim.play("falling")
		return
	
	if abs(velocity.x) > 0:
		anim.play("run right")
		anim.flip_h = velocity.x < 0
	else:
		anim.stop()

# -------------------------
# RESPAWN
# -------------------------

func die():
	global_position = spawn_position
	velocity = Vector2.ZERO
