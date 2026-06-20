extends Control

@export var target:Node2D;
@export var percentLabel:Label;
@export var showPercentageEnabled:bool = true;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if showPercentageEnabled:
		percentLabel.visible = true;
	else:
		percentLabel.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var hp = target.get_hp();
	var maxHP = target.get_max_hp();
	$ForeGround.scale.x = hp/maxHP;
	percentLabel.text = str(int(hp)) + "/" + str(int(maxHP)) + "hp";
