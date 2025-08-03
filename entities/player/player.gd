class_name Player
extends Orb

@export var rotation_factor: float = 0.95
@export var trajectory_steps: int = 96
@export var trajectory_step_size: float = 1.0 / 60.0
@export var trajectory_line_steps: int = 4
@export var unlatched_gravitation: float = 0.15
@export var unlatching_boost: float = 1.1
@export var unlatching_time: float = 2.0
@export var arcs: int = 12
@export var arc_divisions: int = 8

@onready var trajectory_probe: Orb = $TrajectoryProbe

var unlatched_trajlines := []
var latched_trajlines := []
var latched := false
var dead := false


func _ready() -> void:
	if Global.lupin == 3:
		$Sprites/Lupin.play("third")

	for trajlines in [unlatched_trajlines, latched_trajlines]:
		for i in range(trajectory_line_steps, trajectory_steps, trajectory_line_steps * 2):
			var line := Line2D.new()
			add_child(line)
			trajlines.append(line)


var latch_time := 0.0
func _process(delta: float) -> void:
	super(delta)
	handle_rotation(delta)

	# Because 7 8 9
	if Global.lupin == 7:
		$Sprites/Lupin.scale = Vector2(1.45, 1.45)

	clear_arcs()
	if not dead:
		draw_trajectories()
		draw_arcs()

		if check_collisions([trajectory_probe]):
			die.emit()
		if Input.is_action_just_pressed("latch"):
			latched = true
			latch_time = time

			# var strength := gravitate().length() / 18.0
			$LatchAudio.volume_db = 10.0 # log(strength) * 3.5
			$LatchAudio.pitch_scale = randf_range(0.95, 1.20)
			$LatchAudio.play()
			$Sprites/LatchSmoke.emitting = true
			$Sprites/Front.modulate = Color(1.0, 0.0, 0.0)
			$Sprites/Back.modulate = Color(1.0, 0.0, 0.0)
		if Input.is_action_just_released("latch"):
			var boost := get_unlatch_boost()
			latched = false
			linear_velocity *= boost

			var strength := linear_velocity.length() / 32.0
			$DelatchAudio.volume_db = log(strength) * 5.0 - 5.0
			$DelatchAudio.play()
			$Sprites/DelatchSmoke.emitting = true
			$Sprites/Front.modulate = Color(1.0, 1.0, 1.0)
			$Sprites/Back.modulate = Color(1.0, 1.0, 1.0)
	else:
		latched = false


func handle_rotation(delta: float) -> void:
	var rot := atan2(linear_velocity.y, linear_velocity.x)
	$Sprites.rotation = lerp_angle($Sprites.rotation, rot, rotation_factor * delta)


func get_unlatch_boost() -> float:
	if not latched:
		return 1.0

	var time_latched := clampf(time - latch_time, 0.0, unlatching_time)
	var boost := lerpf(1.0, unlatching_boost, time_latched / unlatching_time)
	return boost ** 2


static func calc_latch(force: Vector2, velocity: Vector2, latching: bool, unlatched_grav: float) -> Vector2:
	if latching:
		return force
	else:
		var dotted := force.normalized().dot(velocity.normalized())
		if dotted > 0:
			return force * unlatched_grav * dotted
		else:
			return Vector2(0.0, 0.0)


func gravitate(exclusions: Array = []) -> Vector2:
	return calc_latch(super(exclusions + [trajectory_probe]), linear_velocity, latched, unlatched_gravitation)


func map_trajectory(latching: bool) -> PackedVector2Array:
	trajectory_probe.position = Vector2(0.0, 0.0)
	trajectory_probe.mass = mass
	trajectory_probe.linear_velocity = linear_velocity * (1.0 if latching else get_unlatch_boost())
	trajectory_probe.radius = radius

	var path: PackedVector2Array = [Vector2(0.0, 0.0)]
	for _i in range(trajectory_steps):
		trajectory_probe.position += trajectory_probe.linear_velocity * trajectory_step_size

		var accel := trajectory_probe.gravitate([self]) / trajectory_probe.mass
		trajectory_probe.linear_velocity += calc_latch(accel, trajectory_probe.linear_velocity,
													   latching, unlatched_gravitation) * trajectory_step_size

		if trajectory_probe.check_collisions([self], 1.0):
			break

		path.append(trajectory_probe.position)

	return path


func draw_trajectories() -> void:
	var unlatched_traj := map_trajectory(false)
	var latched_traj := map_trajectory(true)

	for tuple in [[unlatched_trajlines, unlatched_traj, Color(1.0, 1.0, 1.0)],
				  [latched_trajlines, latched_traj, Color(1.0, 0.0, 0.0)]]:
		var lines: Array = tuple[0]
		var traj: PackedVector2Array = tuple[1]
		var tint: Color = tuple[2]

		for i in range(trajectory_line_steps, trajectory_steps, trajectory_line_steps * 2):
			@warning_ignore("integer_division")
			var j := i / (trajectory_line_steps * 2)

			lines[j].width = 1.0
			lines[j].default_color = Color(tint.r, tint.g, tint.b, 1.0 - float(i) / trajectory_steps)
			lines[j].points = traj.slice(i, i + trajectory_line_steps)


# I can't be bothered to optimize and create a recycling system for this.
var orb_arcs := []
func clear_arcs() -> void:
	for arc: Line2D in orb_arcs:
		arc.queue_free()
	orb_arcs = []


func draw_arcs() -> void:
	for orb: Orb in get_tree().get_nodes_in_group("orbs"):
		var orbit_audio: AudioStreamPlayer2D = orb.get_node("OrbitAudio")
		orbit_audio.volume_db = -INF;

		if orb == self or orb == trajectory_probe or not orb.active:
			continue
		
		var distance := (orb.global_position - global_position).length()
		if distance > orb.influence_radius:
			continue
		var strength := 1.0 - (distance / orb.influence_radius) ** 2.0
		orbit_audio.volume_db = log(strength) * 10.0

		if not latched:
			strength *= unlatched_gravitation * 4.0

		var normalized := (orb.global_position - global_position) / distance
		var perpendicular := normalized.rotated(PI / 2.0)
		var start := global_position + normalized * radius
		var end := orb.global_position - normalized * orb.radius

		for i in range(arcs):
			@warning_ignore("integer_division")
			var is_red := i >= arcs / 2

			var points := PackedVector2Array()
			points.resize(arc_divisions)
			for j in range(arc_divisions):
				var progress := float(j) / (arc_divisions - 1.0)
				points[j] = lerp(start, end, progress)

				var random := perpendicular * randf_range(-8.0, 8.0) * sqrt(strength) * progress ** 1.25
				points[j] += random * (0.25 if is_red else 1.0)

				points[j] -= global_position

			var arc := Line2D.new()
			arc.points = points
			arc.width = 1.0
			if is_red and latched:
				arc.default_color = Color(1.0, 0.0, 0.0)
			else:
				arc.default_color = orb.color
			arc.default_color.a = strength ** 2
			arc.z_index = -1
			add_child(arc)
			orb_arcs.append(arc)


signal die
func _on_die() -> void:
	call_deferred("do_death")


func do_death() -> void:
	dead = true
	active = false
	$CollisionShape.disabled = true
	linear_velocity = Vector2(0.0, 0.0)

	for trajlines in [latched_trajlines, unlatched_trajlines]:
		for line in trajlines:
			line.hide()
	$Sprites/Back.hide()
	$Sprites/Lupin.hide()
	$Sprites/DelatchSmoke.emitting = true
	$Sprites/Front.modulate = Color(1.0, 1.0, 1.0)
	$Sprites/Front.play("pop")

	$DeathAudio.play()


func _on_danger_body_enter(_body: Node2D) -> void:
	if not dead:
		die.emit()


func _on_death_audio_finished() -> void:
	queue_free()
