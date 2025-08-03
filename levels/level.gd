class_name Level
extends Node2D

@export var next_scene: PackedScene

@onready var entrance: Door = $EntranceDoor
@onready var entrance_timer: Timer = $EntranceDoor/Timer
@onready var player_spawn := $PlayerSpawn
@onready var player_velocity := $PlayerSpawn/Velocity
@onready var spawn_timer = $PlayerSpawn/Timer
@onready var camera: Camera = $PlayerSpawn/Camera

var player: Player


func _ready() -> void:
	spawn_player()


func _process(delta: float) -> void:
	camera.move(delta, player)


func spawn_player_timed() -> void:
	spawn_timer.start()


const PLAYER := preload("res://entities/player/player.tscn")
func spawn_player() -> void:
	entrance.open()
	player = PLAYER.instantiate()
	player.global_position = player_spawn.global_position
	player.linear_velocity = player_velocity.position
	player.die.connect(spawn_player_timed)
	add_child(player)
	entrance_timer.start()


func _on_entrance_timeout() -> void:
	entrance.close()


func _on_spawn_timer_timeout() -> void:
	spawn_player()


func _on_finish_area_entered(body: Node2D) -> void:
	if body is Player:
		print("Finish!")
		get_tree().call_deferred("change_scene_to_packed", next_scene)
