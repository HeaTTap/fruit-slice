extends Node2D

var score: int = 0
var misses: int = 0
const MAX_MISSES: int = 3
var game_over: bool = false

const FRUIT_SCENE := preload("res://scenes/fruit.tscn")

@onready var fruit_timer: Timer = $FruitTimer
@onready var hud: Control = $HUD


func _ready() -> void:
	fruit_timer.timeout.connect(_spawn_fruit)
	hud.set_score(0)
	hud.set_misses(0, MAX_MISSES)


func _spawn_fruit() -> void:
	if game_over:
		return

	var fruit := FRUIT_SCENE.instantiate() as Area2D
	var vp := get_viewport_rect().size
	fruit.position = Vector2(randf_range(80, vp.x - 80), vp.y + 60)
	fruit.velocity = Vector2(randf_range(-120, 120), randf_range(-450, -650))
	fruit.fruit_sliced.connect(_on_fruit_sliced)
	fruit.fruit_missed.connect(_on_fruit_missed)
	add_child(fruit)


func _on_fruit_sliced() -> void:
	if game_over:
		return
	score += 1
	hud.set_score(score)


func _on_fruit_missed() -> void:
	if game_over:
		return
	misses += 1
	hud.set_misses(misses, MAX_MISSES)
	if misses >= MAX_MISSES:
		_end_game()


func _end_game() -> void:
	game_over = true
	fruit_timer.stop()
	hud.show_game_over()


func _restart() -> void:
	get_tree().reload_current_scene()


func _input(event: InputEvent) -> void:
	if game_over:
		if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
			_restart()
		elif event is InputEventMouseButton and event.pressed:
			_restart()
		elif event is InputEventScreenTouch and event.pressed:
			_restart()
