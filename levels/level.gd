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
	],
	[
		"A:I hope this one's the last..."
	]
]

@export var spawn_dialogs: Dictionary[int, Array] = {
	2: [
		"A:Wait, where did the previous one go?",
		"B:He failed. Look at his successor, though!",
		"A:I don't think this is ethical..."
	],
	3: [
		"B:Welp. Third time's the charm."
	],
	4: [
		"B:Man, This one's fantastic!",
		"A:Wait, say that again..."
	],
	5: [
		"B:Pentakill!!!",
		"A:What is wrong with you?"
	],
	6: [
		"B:Guys, I think this one is afraid of Lupin the 7th."
	],
	7: [
		"B:Oh God. It's HIM",
	],
	8: [
		"B:LOOP!!!",
		"A:Uh... What?",
		"B:INFINITY!!!",
		"A:..."
	],
	10: [
		"B:Let's go Lupin the Tenth!",
		"A:Yeah... Yay..."
	],
	11: [
		"B:Is it 11:11 yet?",
		"A:You gonna wish for this one's success?",
		"B:Nah, just for a raise"
	],
	12: [
		"A:It's the 12th one...",
		"B:This one will do it"
	],
	13: [
		"B:Oh 13. this one's cursed."
	],
	14: [
		"B:You ever had a valentine?",
		"A:Oh, I'm uh... I'm not into that.",
	],
	15: [
		"A:Lupin the 15th... Why are we doing this again?",
		"B:Research.",
		"A:But-",
		"B:I know. Research."
	],
	16: [
		"B:16... Bit?",
		"A:That one's a bit of a stretch",
		"B:...",
		"A:...That wasn't intentional."
	],
	17: [
		"B:Which one are we at again?",
		"A:This is Lupin the 17th, Mam."
	],
	18: [
		"B:18... What's a funny joke for 18...",
		"A:Can we not joke about this?"
	],
	19: [
		"B:You know, when I first entered this job, i was 19.",
		"B:I was just like you.",
		"A:What changed?",
		"B:...",
	],
	20: [
		"B:WOO that's a nat 20!",
		"A:Are you... playing at a time like this?"
	],
	21: [
		"B:What's 9 + 10?",
		"A:19",
		"B:Stupid, it's 21",
		"A:...What?"
	],
	22: [
		"B:I'm feeling 22~",
		"A:Please never sing again..."
	],
	23: [
		"B:Happy Birthday!",
		"B:It's the 23rd right?",
		"A:Oh, i didn't realize...",
		"A:Thanks"
	],
	24: [
		"B:You know what's funnier than 24?",
		"A:...What's funny with 24?",
		"B:Ugh, young people...",
	],
	25: [
		"B:HO HO HO",
		"A:Mam, It's summer.",
		"B:Forgetting about the southern hemisphere, are we?",
		"A:Mam, they still have it on December, not August.",
		"B:..."
	],
	26: [
		"B:I'm thirsty...",
		"B:Have you peed yet?",
		"A:Oh God, is it my turn this week?"
	],
	27: [
		"B:Third time third time's the charm"
	],
	28: [
		"B:It's the Alpha",
		"A:i... don't think it's this one?"
	],
	29: [
		"A:The other branches...",
		"A:Are they doing this too?",
		"B:No comment."
	],
	30: [
		"A:Deploying Lupin the 30th.",
		"B:Hey it's my age!",
		"B:I'm still young, right?",
		"A:..."
	],
	31: [
		"B:HAPPY NEW YEAR!",
	],
	32: [
		"A:Deploying Lupin the 32nd...",
		"A:What do the higher ups even want from this??",
		"B:I.. I'm sorry, you just have to trust me..."
	],
	33: [
		"B:For those who come after",
		"A:No more I hope..."
	],
	34: [
		"B:You think there's rule-",
		"A:Don't even go there."
	],
	35: [
		"A:Lupin the 35th...",
		"A:Are you sure about this plan? We could get-",
		"B:Yes.",
		"B:This is bigger than us."
	],
	36: [
		"A:Mam, is your password really 36 characters long?",
		"B:ITS FOR PRIVACY."
	],
	37: [
		"A:Lupin the 37th...",
		"B:Are you prepared for what happens?",
		"A:Yes."
	],
	42: [
		"B:He's the answer to life itself",
	],
	47: [
		"B:Lupin 47, your mission is to-",
		"A:Don't."
	],
	50: [
		"B:Halfway there.",
	],
	51: [
		"B:Are there aliens in area 51?",
		"A:What do you mean? They're everywhere...?",
		"B:Yeah but are there aliens there though?",
		"A:Probably?"
	],
	52: [
		"A:Deploying Lupin the 52nd",
		"B:Great! We can play a deck with the number of-",
		"A:Don't.",
	],
	53: [
		"B:Puhuhuhuhu",
		"A:What are you doing...?"
	],
	64: [
		"A:Lupin the 64th",
		"B:Man, i remember my first console...",
		"B:Ahh the good old days...",
	],
	66: [
		"B:EXECUTE ORDER 66",
	],
	77: [
		"A:Lupin the 77th",
		"B:Corpos are gonks.",
		"A:Mam, we're the corpos in this situation.",
	],
	69: [
		"A:Deploying number 69",
		"B:Nice",
		"A:..."
	],
	81: [
		"B:Third time third time third time's the charm",
	],
	84: [
		"A:Deploying Lupin the 84th",
		"B:Literally 1984",
		"A:You're LITERALLY 1900 off"
	],
	86: [
		"A:Deploying Lupin the 86th",
		"B:Ooh i love that anime",
		"A:It WAS a novel series FIRST"
	],
	87: [
		"B:IS THAT THE BITE OF 87!?",
		"A:Well, he did bite someone...",
		"B:Oh you're no fun.",
	],
	88: [
		"B:Can we go back in time now?",
		"A:Mam, we do not have a delorean.",
	],
	100: [
		"B:LETS GOOO WE REACHED 100!!!",
		"A:I don't think it's something to celebrate, Mam."
	],
	151: [
		"B:GOTTA CATCH 'EM ALL",
	],
	173: [
		"A:Deploying Lupin the 173rd",
		"B:Don't. Look. Away.",
	],
	243: [
		"B:B:Third time third time third time third time's the charm",
	],
	365: [
		"A:Deploying Lupin the 365th",
		"B:It's been a year huh...",
	],
	420: [
		"A:Deploying Lupin the 420th",
		"B:Duuuudee."
	],
	456: [
		"B:RED LIGHT!!",
		"A:GREEN LIGHT!!"
	],
	616:[
		"B:Do you think WE'RE in the main universe?",
		"A:Well there are many theories about thi-",
		"B:Nevermind.",
	],
	666: [
		"A:Deploying Lupin the 666th",
		"B:DIOS MIO."
	],
	729: [
		"B:B:Third time third time third time third time third time's the charm",
	],
	1000: [
		"A:1000... How have we gone this far?"
	],
}

@onready var entrance: Door = $EntranceDoor
@onready var entrance_timer: Timer = $EntranceDoor/Timer
@onready var player_spawn := $PlayerSpawn
@onready var player_velocity := $PlayerSpawn/Velocity
@onready var spawn_timer = $PlayerSpawn/Timer
@onready var camera: Camera = $PlayerSpawn/Camera
@onready var level_indicator: AnimatedSprite2D = $CanvasLayer/LevelIndicator
@onready var dialogs: Dialogs = $CanvasLayer/Dialogs
@onready var transition: AnimatedSprite2D = $CanvasLayer/Transition

var player: Player


func _ready() -> void:
	spawn_player(true)
	level_indicator.play(str(level))
	dialogs.set_queue(format_dialogs(initial_dialogs))


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
		if Global.lupin == 9: # Because 7 8 9
			Global.lupin = 10

		if spawn_dialogs.has(Global.lupin):
			dialogs.set_queue(format_dialogs(spawn_dialogs[Global.lupin]))
		else:
			dialogs.set_queue(format_dialogs(default_spawn_dialogs[randi() % len(default_spawn_dialogs)]))

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
		transition.play("close")


func _on_transition_animation_finished() -> void:
	if transition.animation == "close":
		get_tree().call_deferred("change_scene_to_packed", next_scene)


func _on_loop_button_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			$CanvasLayer/LoopButton/Sprite.play("pressed")
		else:
			$CanvasLayer/LoopButton/Sprite.play("default")
			player.die.emit()
