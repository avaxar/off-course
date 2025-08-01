extends Camera2D

@export var focus_radius: float = 96.0
@export var correction_speed: float = 0.95


func _process(delta: float) -> void:
	var interest := get_interest()
	var correction := interest.global_position - global_position
	global_position += correction * correction_speed * delta


func get_interest() -> Node2D:
	var player: Player = null
	for p: Player in get_tree().get_nodes_in_group("player"):
		player = p
		break
	if player == null:
		return null
	
	var interest: Node2D = null
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		if orb in get_tree().get_nodes_in_group("player") or not orb.active:
			continue
		
		var distance := (orb.global_position - player.global_position).length()
		if distance > focus_radius:
			continue
		if interest == null or distance < (interest.global_position - player.global_position).length():
			interest = orb
	
	if interest == null:
		return player
	else:
		return interest
