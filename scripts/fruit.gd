extends Area2D

var velocity: Vector2 = Vector2.ZERO
var fall_gravity: float = 600.0
var fruit_type: int = 0
var sliced: bool = false
var rotation_speed: float = 0.0
var lifetime: float = 0.0
var fall_dead: bool = false

signal fruit_sliced
signal fruit_missed

const COLORS: Array[Color] = [
	Color(0.9, 0.2, 0.2),
	Color(1.0, 0.6, 0.1),
	Color(1.0, 0.85, 0.1),
	Color(0.2, 0.8, 0.2),
]


func _ready() -> void:
	fruit_type = randi() % COLORS.size()
	rotation_speed = randf_range(-3.0, 3.0)


func _process(delta: float) -> void:
	if sliced:
		lifetime += delta
		modulate.a = 1.0 - lifetime / 0.3
		scale += Vector2(0.5, 0.5) * delta
		if lifetime > 0.3:
			queue_free()
		return

	velocity.y += fall_gravity * delta
	position += velocity * delta
	rotation += rotation_speed * delta

	if position.y > get_viewport_rect().size.y + 100:
		fruit_missed.emit()
		queue_free()


func slice() -> void:
	if sliced:
		return
	sliced = true
	fruit_sliced.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(true)


func _draw() -> void:
	var c := COLORS[fruit_type]
	draw_circle(Vector2.ZERO, 40, c)
	draw_circle(Vector2.ZERO, 35, c.lightened(0.15))
	draw_circle(Vector2(-10, -12), 10, Color(1, 1, 1, 0.2))
