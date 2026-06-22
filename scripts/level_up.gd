extends Control

@onready var nextLevelButton = $BG/HBoxContainer/NextLevel
@onready var resetButton = $BG/HBoxContainer/VBoxContainer/Reset
@onready var maxHpButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/MaxHP/MaxHP
@onready var dashCooldownButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/DashCooldown/DashCooldown
@onready var katanaLengthButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/KatanaLength/KatanaLength
@onready var damageButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/Damage/Damage
@onready var spinAttackButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/VBoxContainer/SpinAttack
@onready var totalPointsNumberLabel = $BG/HBoxContainer/VBoxContainer/TotalPointsHBox/num
var gameManager
var transition

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("game_manager");
	transition = get_tree().get_first_node_in_group("transition");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_next_level_pressed() -> void:
	transition.toggle_transition();
	await transition.done_transitioning;
	visible = false;
	get_tree().paused = false;
	transition.toggle_transition();

func _on_reset_pressed() -> void:
	pass # Replace with function body.


func _on_max_hp_pressed() -> void:
	pass # Replace with function body.


func _on_dash_cooldown_pressed() -> void:
	pass # Replace with function body.


func _on_katana_length_pressed() -> void:
	pass # Replace with function body.


func _on_damage_pressed() -> void:
	pass # Replace with function body.


func _on_spin_attack_pressed() -> void:
	pass # Replace with function body.
