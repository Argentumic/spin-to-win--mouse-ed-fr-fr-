extends Control

@onready var nextLevelButton = $BG/HBoxContainer/NextLevel
@onready var resetButton = $BG/HBoxContainer/VBoxContainer/Reset

@onready var maxHpButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/MaxHP/MaxHP
@onready var maxHpLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/MaxHP/Amount

@onready var dashCooldownButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/DashCooldown/DashCooldown
@onready var dashCooldownLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/DashCooldown/Amount

@onready var katanaLengthButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/KatanaLength/KatanaLength
@onready var katanaLengthLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/KatanaLength/Amount

@onready var damageButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/Damage/Damage
@onready var damageLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/Damage/Amount

@onready var spinAttackButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/SpinAttack/SpinAttack
@onready var spinAttackLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/SpinAttack/Amount

@onready var totalPointsNumberLabel = $BG/HBoxContainer/VBoxContainer/TotalPointsHBox/num
var gameManager
var transition

var totalUpgradePoints:int = 0;
var freeUpgradePoints:int = 0;

func add_points(amtOfPts:int) -> void:
	totalUpgradePoints += amtOfPts;
	freeUpgradePoints += amtOfPts;

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("game_manager");
	transition = get_tree().get_first_node_in_group("transition");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalPointsNumberLabel.text = str(freeUpgradePoints);
	maxHpLabel.text = str(maxHpCurrLvl, "/", maxHpMaxLvl);
	dashCooldownLabel.text = str(dashCooldownCurrLvl, "/", dashCooldownMaxLvl);
	katanaLengthLabel.text = str(katanaLengthCurrLvl, "/", katanaLengthMaxLvl);
	damageLabel.text = str(damageCurrLvl, "/", dagameMaxLvl);
	spinAttackLabel.text = str(spinAttackCurrLvl, "/", spinAttackMaxLvl);
	if freeUpgradePoints == 0:
		maxHpButton.disabled = true;
		dashCooldownButton.disabled = true;
		katanaLengthButton.disabled = true;
		damageButton.disabled = true;
		spinAttackButton.disabled = true;

func _on_next_level_pressed() -> void:
	transition.toggle_transition();
	await transition.done_transitioning;
	visible = false;
	get_tree().paused = false;
	transition.toggle_transition();

func _on_reset_pressed() -> void:
	maxHpCurrLvl = 0;
	dashCooldownCurrLvl = 0;
	katanaLengthCurrLvl = 0;
	damageCurrLvl = 0;
	spinAttackCurrLvl = 0;
	freeUpgradePoints = totalUpgradePoints;

var maxHpMaxLvl:int = 10;
var maxHpCurrLvl:int = 0;
func _on_max_hp_pressed() -> void:
	pass # Replace with function body.

var dashCooldownMaxLvl:int = 10;
var dashCooldownCurrLvl:int = 0;
func _on_dash_cooldown_pressed() -> void:
	pass # Replace with function body.

var katanaLengthMaxLvl:int = 10;
var katanaLengthCurrLvl:int = 0;
func _on_katana_length_pressed() -> void:
	pass # Replace with function body.

var dagameMaxLvl:int = 10;
var damageCurrLvl:int = 0;
func _on_damage_pressed() -> void:
	pass # Replace with function body.

var spinAttackMaxLvl:int = 1;
var spinAttackCurrLvl:int = 0;
func _on_spin_attack_pressed() -> void:
	pass # Replace with function body.
