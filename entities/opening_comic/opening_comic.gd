extends Node2D

var panel := 0
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("latch") && panel == 0:
		$AnimationPlayer.play("panel_1")
		print("com")

	if Input.is_action_just_pressed("latch") && panel == 1:
		$AnimationPlayer.play("panel_2")
		print("com")
	if Input.is_action_just_pressed("latch") && panel == 2:
		$AnimationPlayer.play("panel_3")
		print("com")
	if Input.is_action_just_pressed("latch") && panel == 3:
		$AnimationPlayer.play("panel_4")
		print("com")

	if Input.is_action_just_pressed("latch") && panel == 4:
		get_tree().change_scene_to_file("res://levels/level_0.tscn")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	panel += 1
