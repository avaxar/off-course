extends Node2D



func _process(delta):
	$Rocks.position += Vector2.RIGHT * 20 * delta
	$Rocks2.position += Vector2.RIGHT * 20 * delta
	$Objects.position += Vector2.RIGHT * 50 * delta
	$Objects2.position += Vector2.RIGHT * 50 * delta
	$"Rocks/Rock8".rotation += 1 * delta
	$"Rocks/Rock2".rotation -= 1 * delta 
	$"Rocks/Rock3".rotation += 1 * delta
	$"Rocks/Rock4".rotation -= 1 * delta
	$"Rocks/Rock6".rotation += 1 * delta
	$"Rocks/Rock5".rotation -= 1 * delta
	$"Rocks/Rock7".rotation -= 1 * delta
	$"Rocks2/Rock1".rotation += 1 * delta
	$"Rocks2/Rock10".rotation -= 1 * delta
	$"Rocks2/Rock11".rotation += 1 * delta
	$"Rocks2/Rock12".rotation -= 1 * delta
	$"Rocks2/Rock13".rotation += 1 * delta
	$"Rocks2/Rock14".rotation -= 1 * delta

	$"Objects/1".rotation += 1 * delta
	$"Objects/2".rotation -= 1 * delta
	$"Objects/3".rotation += 1 * delta
	$"Objects2/4".rotation -= 1 * delta
	$"Objects2/5".rotation += 1 * delta
	$"Objects2/6".rotation -= 1 * delta
	$"Objects2/7".rotation -= 1 * delta	
	
	
	if $Rocks.global_position.x > 500:
		$Rocks.position.x = -500
	if $Rocks2.global_position.x > 1000:
		$Rocks2.position.x = 0
	if $Objects.global_position.x > 500:
		$Objects.position.x = -500
	if $Objects2.global_position.x > 1000:
		$Objects2.position.x = 0
		
