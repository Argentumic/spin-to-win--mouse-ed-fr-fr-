extends Node2D

var player;

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player");
	$CPUParticles2D.direction = (global_position - player.global_position).normalized();
	$CPUParticles2D.emitting = true;
	$Sprite2D/DeathSFXPlayer.pitch_scale = randf_range(0.8, 1.0)
	var tween = get_tree().create_tween();
	tween.tween_property($Sprite2D, "position", Vector2($Sprite2D.position.x, $Sprite2D.position.y-200.0), 3.0);
	tween.parallel().tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 0.0), 3.0);
	await tween.finished;
	self.queue_free();
