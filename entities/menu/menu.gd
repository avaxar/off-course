extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("latch"):
		$StartButton.play("hold")
	if Input.is_action_just_released("latch"):
		$CanvasLayer/Transition.play("close")


func _on_transition_animation_finished() -> void:
	if $CanvasLayer/Transition.animation == "close":
		get_tree().change_scene_to_file("res://entities/opening_comic/opening_comic.tscn")
