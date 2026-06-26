extends Node2D

func _ready() -> void:
	$DeathSFXPlayer.pitch_scale = randf_range(0.8, 1.0)
	var tween = get_tree().create_tween();
	tween.tween_property(self, "position", Vector2(self.position.x, self.position.y-200.0), 3.0);
	tween.parallel().tween_property(self, "modulate", Color(1.0, 1.0, 1.0, 0.0), 3.0);
	await tween.finished;
	self.queue_free();
