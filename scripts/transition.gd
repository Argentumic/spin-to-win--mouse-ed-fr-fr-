extends ColorRect

signal done_transitioning
@export var isTransperent = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_transition();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func toggle_transition() -> void:
	var tween = get_tree().create_tween();
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS);
	if isTransperent:
		tween.tween_property(material, "shader_parameter/progress", 2.5, 0.5);
		isTransperent = false;
	else:
		tween.tween_property(material, "shader_parameter/progress", 0.0, 0.5);
		isTransperent = true;
	await tween.finished;
	done_transitioning.emit();
