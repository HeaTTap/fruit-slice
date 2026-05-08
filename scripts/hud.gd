extends Control


func show_game_over() -> void:
	$GameOverPanel.visible = true


func hide_game_over() -> void:
	$GameOverPanel.visible = false


func set_score(val: int) -> void:
	$ScoreLabel.text = "Score: " + str(val)


func set_misses(val: int, max_val: int) -> void:
	$MissesLabel.text = "Misses: " + str(val) + "/" + str(max_val)
