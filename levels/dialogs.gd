class_name Dialogs
extends Node2D

@onready var dialog_a := $DialogA
@onready var dialog_b := $DialogB

@onready var letter_timer := $LetterTimer
@onready var letter_retract_timer := $LetterRetractTimer
@onready var dialog_retract_timer := $DialogRetractTimer

@export var dialog_queue: Array[String] = []
@export var letter_time: float = 0.1
@export var dialog_time: float = 1.0


func _ready() -> void:
	letter_timer.start()


func queue(dialog: String) -> void:
	dialog_queue.append(dialog)
	letter_timer.start()


func queue_list(dialogs: Array[String]) -> void:
	dialog_queue.append_array(dialogs)
	letter_timer.start()


var current_dialog: Control = null
func _on_letter_timer_timeout() -> void:
	if dialog_queue.is_empty():
		return
	
	var dialog := dialog_a if dialog_queue[0][0] == 'A' else dialog_b
	var label: Label = dialog.get_node("MarginContainer/Label")
	var message := dialog_queue[0].substr(2)
	current_dialog = dialog

	if message.is_empty():
		dialog_queue = dialog_queue.slice(1)
		dialog_retract_timer.start()
		return

	dialog.visible = true
	label.text += message[0]
	dialog_queue[0] = dialog_queue[0].substr(0, 2) + message.substr(1)

	letter_timer.start()


func _on_letter_retract_timer_timeout() -> void:
	var label: Label = current_dialog.get_node("MarginContainer/Label")
	if label.text.is_empty():
		current_dialog.visible = false
		letter_timer.start()
	else:
		label.text = label.text.substr(1)
		letter_retract_timer.start()


func _on_dialog_retract_timer_timeout() -> void:
	_on_letter_retract_timer_timeout()
