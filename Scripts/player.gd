extends CharacterBody2D
class_name Player

signal air

const GRAVITY = 1200.0
const MOVE_SPEED = 300.0
const MAX_FALL_SPEED = 900.0
var is_in_air = false :
	set(val):
		is_in_air = val
		if is_in_air:
			air.emit()
var spawn_position : Vector2

@onready var anim = $AnimatedSprite2D


func _ready():
	spawn_position = global_position


func _physics_process(delta):
	if is_in_air == is_on_floor():
		is_in_air = not is_on_floor()
	# Apply Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.y = clamp(velocity.y, -INF, MAX_FALL_SPEED)

	# Left / Right Movement
	var dir = Input.get_axis("ui_LEFT", "ui_RIGHT") # MUST be lowercase
	velocity.x = dir * MOVE_SPEED

	move_and_slide()

	update_animation(dir)


func update_animation(dir):
	# Falling animationaad

	# Running animation
	if dir != 0:
		anim.play("run right")
		anim.flip_h = dir < 0
	else:
		anim.stop()  # Stops on first frame (acts like idle)


func die():
	global_position = spawn_position
	velocity = Vector2.ZERO


func _on_air() -> void:
	anim.play("falling")
