extends Node2D

var panel:int = 0
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("latch") && panel == 0:
		$AnimationPlayer.play("panel1")
		print("com")
		
	if Input.is_action_just_pressed("latch") && panel == 1:
		$AnimationPlayer.play("panel2")
		print("com")
	if Input.is_action_just_pressed("latch") && panel == 2:
		$AnimationPlayer.play("panel3")
		print("com")
	if Input.is_action_just_pressed("latch") && panel == 3:
		$AnimationPlayer.play("panel4")
		print("com")
	
	if Input.is_action_just_pressed("latch") && panel == 4:
		get_tree().change_scene_to_file("res://entities/menu/menu.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	panel += 1
