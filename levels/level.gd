class_name Level
extends Node2D

@export var level: int
@export var next_scene: PackedScene

@export var initial_dialogs: Array[String] = [
	"A:Initiating level #{level}..."
]

@export var default_spawn_dialogs: Array[Array] = [
	[
		"B:Looping Lupin #{lupin}..."
	],
	[
		"B:This one's for sure... Lupin #{lupin}!"
	],
	[
		"A:Lupin #{lupin} is now in."
	],
	[
		"A:Lupin #{lupin} is deployed."
	]
]

@export var spawn_dialogs: Dictionary[int, Array] = {
	1: [
		"B:Here's Lupin! Look at him go!",
		"A:The gravity orbs seem to be functional."
	],
	2: [
		"A:Wait, where did the previous one go?",
		"B:He failed. Look at his successor, though!",
		"A:I don't think this is ethical..."
	]
}

@onready var entrance: Door = $EntranceDoor
@onready var entrance_timer: Timer = $EntranceDoor/Timer
@onready var player_spawn := $PlayerSpawn
@onready var player_velocity := $PlayerSpawn/Velocity
@onready var spawn_timer = $PlayerSpawn/Timer
@onready var camera: Camera = $PlayerSpawn/Camera
@onready var dialogs: Dialogs = $CanvasLayer/Dialogs

var player: Player


func _ready() -> void:
	spawn_player(true)
	dialogs.queue_list(format_dialogs(initial_dialogs))


func _process(delta: float) -> void:
	camera.move(delta, player)


func format_dialogs(array: Array):
	var formatted: Array[String] = []
	formatted.resize(len(array))

	for i in range(len(array)):
		formatted[i] = array[i].replace("{level}", str(level)).replace("{lupin}", str(Global.lupin))

	return formatted


func spawn_player_timed() -> void:
	spawn_timer.start()


const PLAYER := preload("res://entities/player/player.tscn")
func spawn_player(first_time: bool = false) -> void:
	if not first_time:
		Global.lupin += 1
		if spawn_dialogs.has(Global.lupin):
			dialogs.queue_list(format_dialogs(spawn_dialogs[Global.lupin]))
		else:
			dialogs.queue_list(format_dialogs(default_spawn_dialogs[randi() % len(default_spawn_dialogs)]))

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
		Global.level += 1
		get_tree().call_deferred("change_scene_to_packed", next_scene)


func _on_loop_button_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			$CanvasLayer/LoopButton/Sprite.play("pressed")
		else:
			$CanvasLayer/LoopButton/Sprite.play("default")
			player.die.emit()
