extends Node2D


var closing := false
func _process(_delta: float) -> void:
	if closing:
		$Music.volume_db -= 100.0 * _delta

	if Input.is_action_just_pressed("latch"):
		$StartButton.play("hold")
	if Input.is_action_just_released("latch"):
		$StartButton.play("default")
		$CanvasLayer/Transition.play("close")
		closing = true


func _on_transition_animation_finished() -> void:
	if $CanvasLayer/Transition.animation == "close":
		get_tree().change_scene_to_file("res://entities/opening_comic/opening_comic.tscn")
