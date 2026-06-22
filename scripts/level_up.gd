extends Control

@onready var nextLevelButton = $BG/HBoxContainer/NextLevel
@onready var resetButton = $BG/HBoxContainer/VBoxContainer/Reset

@onready var maxHpButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/MaxHP/MaxHP
@onready var maxHpLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/MaxHP/Amount
@export var maxHpUpgradePower:float = 10;

@onready var dashCooldownButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/DashCooldown/DashCooldown
@onready var dashCooldownLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/DashCooldown/Amount

@onready var katanaLengthButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/KatanaLength/KatanaLength
@onready var katanaLengthLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/KatanaLength/Amount

@onready var damageButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/Damage/Damage
@onready var damageLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/Damage/Amount
@export var damageUpgradePower:float = 2;

@onready var spinAttackButton = $BG/HBoxContainer/VBoxContainer/HBoxContainer/SpinAttack/SpinAttack
@onready var spinAttackLabel = $BG/HBoxContainer/VBoxContainer/HBoxContainer/SpinAttack/Amount

@onready var totalPointsNumberLabel = $BG/HBoxContainer/VBoxContainer/TotalPointsHBox/num
var gameManager
var transition
var player

var totalUpgradePoints:int = 0;
var freeUpgradePoints:int = 0;

func add_points(amtOfPts:int) -> void:
	totalUpgradePoints += amtOfPts;
	freeUpgradePoints += amtOfPts;

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("game_manager");
	transition = get_tree().get_first_node_in_group("transition");
	player = get_tree().get_first_node_in_group("player");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	totalPointsNumberLabel.text = str(freeUpgradePoints);
	maxHpLabel.text = str(maxHpCurrLvl);
	dashCooldownLabel.text = str(dashCooldownCurrLvl);
	katanaLengthLabel.text = str(katanaLengthCurrLvl);
	damageLabel.text = str(damageCurrLvl);
	spinAttackLabel.text = str(spinAttackCurrLvl);
	if freeUpgradePoints == 0:
		maxHpButton.disabled = true;
		dashCooldownButton.disabled = true;
		katanaLengthButton.disabled = true;
		damageButton.disabled = true;
		spinAttackButton.disabled = true;
	else:
		maxHpButton.disabled = false;
		dashCooldownButton.disabled = false;
		katanaLengthButton.disabled = false;
		damageButton.disabled = false;
		spinAttackButton.disabled = false;

func _on_next_level_pressed() -> void:
	_apply_upgrades();
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

var maxHpCurrLvl:int = 0;
func _on_max_hp_pressed() -> void:
	if freeUpgradePoints > 0:
		freeUpgradePoints -= 1;
		maxHpCurrLvl += 1;

var dashCooldownCurrLvl:int = 0;
func _on_dash_cooldown_pressed() -> void:
	if freeUpgradePoints > 0:
		freeUpgradePoints -= 1;
		dashCooldownCurrLvl += 1;

var katanaLengthCurrLvl:int = 0;
func _on_katana_length_pressed() -> void:
	if freeUpgradePoints > 0:
		freeUpgradePoints -= 1;
		katanaLengthCurrLvl += 1;

var damageCurrLvl:int = 0;
func _on_damage_pressed() -> void:
	if freeUpgradePoints > 0:
		freeUpgradePoints -= 1;
		damageCurrLvl += 1;

var spinAttackCurrLvl:int = 0;
func _on_spin_attack_pressed() -> void:
	if freeUpgradePoints > 0:
		freeUpgradePoints -= 1;
		spinAttackCurrLvl += 1;

func _apply_upgrades() -> void:
	player.maxHP = player.originalMaxHP + maxHpUpgradePower * maxHpCurrLvl;
	player.reset_hp();
	
	player.damage = player.originalDamage + damageUpgradePower * damageCurrLvl;
