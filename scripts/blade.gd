extends Node2D

var is_slicing: bool = false
var trail: Array[Vector2] = []
var trail_line: Line2D

const MAX_TRAIL: int = 30
const TRAIL_WIDTH: float = 5.0


func _ready() -> void:
	trail_line = Line2D.new()
	trail_line.width = TRAIL_WIDTH
	trail_line.default_color = Color(1, 1, 1, 0.7)
	trail_line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	trail_line.end_cap_mode = Line2D.LINE_CAP_ROUND
	trail_line.z_index = 10
	add_child(trail_line)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_start_slice()
			else:
				_stop_slice()
	elif event is InputEventScreenTouch:
		if event.pressed:
			_start_slice()
			_add_point(event.position)
		else:
			_stop_slice()
	elif event is InputEventMouseMotion and is_slicing:
		_add_point(event.position)
	elif event is InputEventScreenDrag and is_slicing:
		_add_point(event.position)


func _start_slice() -> void:
	is_slicing = true
	trail.clear()
	trail_line.clear_points()


func _stop_slice() -> void:
	is_slicing = false


func _add_point(pos: Vector2) -> void:
	trail.push_back(pos)
	if trail.size() > MAX_TRAIL:
		trail.pop_front()

	if trail.size() >= 2:
		_check_intersection(trail[-2], trail[-1])

	_draw_trail()


func _check_intersection(from: Vector2, to: Vector2) -> void:
	var space := get_world_2d().direct_space_state
	var steps := 8
	for i in range(steps + 1):
		var t := float(i) / steps
		var pt := from.lerp(to, t)
		var query := PhysicsPointQueryParameters2D.new()
		query.position = pt
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.collision_mask = 2
		var results := space.intersect_point(query)
		for result in results:
			var area := result.collider as Area2D
			if area != null and area.has_method("slice"):
				area.slice()


func _draw_trail() -> void:
	trail_line.clear_points()
	for pt in trail:
		trail_line.add_point(pt - global_position)


func _process(_delta: float) -> void:
	if not is_slicing and trail_line.points.size() > 0:
		trail_line.clear_points()
