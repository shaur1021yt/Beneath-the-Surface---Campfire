extends RigidBody2D

@export var tilemap: TileMap
@export var layer: int = 0

var broken := false
var landed := false

func _ready():
	contact_monitor = true
	max_contacts_reported = 4

func _on_button_pressed() -> void:
	gravity_scale = 1
	$"../Camera2D".switch_to_player()

# Detect REAL collision using physics contacts
func _integrate_forces(state):
	if broken or landed:
		return
	
	if state.get_contact_count() > 0:
		landed = true
		call_deferred("start_break_sequence")

func start_break_sequence():
	await get_tree().create_timer(1.0).timeout
	check_tile_below()

func check_tile_below():
	if tilemap == null:
		return
	
	var shape = $CollisionShape2D.shape
	if shape is RectangleShape2D:
		var half_height = shape.size.y / 2
		var bottom_world_pos = global_position + Vector2(0, half_height)
		
		var local_pos = tilemap.to_local(bottom_world_pos)
		var tile_pos: Vector2i = tilemap.local_to_map(local_pos)
		
		if tilemap.get_cell_source_id(layer, tile_pos) != -1:
			explosion_break(tile_pos)

# Explosion wave effect
func explosion_break(start_tile: Vector2i):
	broken = true
	
	var visited := {}
	var queue := [start_tile]
	var delay := 0.0
	
	while queue.size() > 0:
		var current: Vector2i = queue.pop_front()
		
		if visited.has(current):
			continue
		
		visited[current] = true
		
		if tilemap.get_cell_source_id(layer, current) != -1:
			explode_tile(current, delay)
			
			delay += 0.015  # speed of wave
			
			queue.append(current + Vector2i(1, 0))
			queue.append(current + Vector2i(-1, 0))
			queue.append(current + Vector2i(0, 1))
			queue.append(current + Vector2i(0, -1))

func explode_tile(tile_pos: Vector2i, delay: float):
	await get_tree().create_timer(delay).timeout
	
	var world_pos = tilemap.map_to_local(tile_pos)
	world_pos = tilemap.to_global(world_pos)
	
	spawn_break_effect(world_pos)
	tilemap.erase_cell(layer, tile_pos)

func spawn_break_effect(world_pos: Vector2):
	var particles = preload("res://BreakParticles.tscn").instantiate()
	particles.global_position = world_pos
	get_tree().current_scene.add_child(particles)
