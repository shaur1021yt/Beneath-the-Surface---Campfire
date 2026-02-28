extends CharacterBody2D
class_name Player

const GRAVITY = 1200.0
const MOVE_SPEED = 300.0
const MAX_FALL_SPEED = 900.0

var spawn_position : Vector2

@onready var anim = $AnimatedSprite2D

func _ready():
	spawn_position = global_position

func _physics_process(delta):
	# Apply Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		anim.play("falling")
	
	velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)

	# Left / Right Movement
	var dir = Input.get_axis("ui_LEFT", "ui_RIGHT")
	velocity.x = dir * MOVE_SPEED

	move_and_slide()

	update_animation(dir)


func update_animation(dir):
	# Falling
	if not is_on_floor():
		anim.play("falling")
		return

	# Running
	if dir != 0:
		anim.play("run right")
		anim.flip_h = dir < 0
	else:
		anim.stop()  # Stops on first frame (acts like idle)


func die():
	global_position = spawn_position
	velocity = Vector2.ZERO
