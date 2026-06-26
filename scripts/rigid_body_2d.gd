extends RigidBody2D

@export var originalMaxHP:float = 100;
var maxHP:float = originalMaxHP;
var hp:float;
@export var originalSpeed:float = 13;
var speed:float = originalSpeed;
@export var maxSpeed:int = 600;
@export var dashMaxSpeed: int = 1000;
@export var originalDamage:float = 10;
var damage:float = originalDamage;
var gameManager;
var canMoveToNextArea:bool = false;
var camera:Camera2D;
@onready var levelLabel = $LevelLabel;

@onready var duckSprite = $Duck;
@onready var sword = $Sword;
@onready var swordInnerOrigin = $Sword/InnerOrigin;

@export var originalDashCooldown:float = 2.0;
var dashCooldown:float = originalDashCooldown;
var dashCooldownRemaining:float = 0.0;
@export var dashTime:float = 0.15;
var dashTimeRemaining:float = 0.0;
@onready var dashCooldownBar = $DashCooldownBar;
var dash_tween:Tween;

# hold time for transitioning to next area in seconds
@onready var holdTimeLabel = $"../CanvasLayer/Control/HoldTimeLabel";
var holdTime:float = 5;
var elapsedHoldTime:float = 0;

@export var poisonedTime:float = 10;
@export var poisonSlowdown:float = 0.66;
var poisonedTimeRemaining:float = 0;
@onready var poisonedBar = $PoisonBar;

@onready var theEndMenu = $"../CanvasLayer/Control/TheEnd";
@onready var dashPoisonSfxPlayer = $DashAndPoisonSFXPlayer;
@onready var humSfxPlayer = $HumSFXPlayer;
@onready var hurtSfxPlayer = $HurtSFXPlayer;
var dashSFX = preload("res://sfx/duck_dash.ogg");
var dashHumSFX = preload("res://sfx/duck_dash hum.ogg");
var hurtSFX = preload("res://sfx/duck_hurt.ogg");
var poisonSFX = preload("res://sfx/duck_poison.ogg");

func _ready() -> void:
	hp = maxHP;
	gameManager = get_tree().get_first_node_in_group("game_manager");
	camera = get_tree().get_first_node_in_group("camera");
	level_start_animation();

var lastDirection:Vector2 = Vector2.RIGHT;
var dashDirection:Vector2 = Vector2.RIGHT;
func _physics_process(delta: float) -> void:
	rotation = 0;
	var input_direction = Input.get_vector("left", "right", "up", "down");
	if input_direction != Vector2.ZERO:
		lastDirection = input_direction;
	if dashTimeRemaining <= 0:
		apply_central_force(input_direction*speed);
	else:
		apply_central_force(dashDirection*speed*2);
	
	# flipping sword depending on if it goes clockwise or counterclockwise
	var oldSwordAngle:float = sword.rotation_degrees;
	sword.look_at(get_global_mouse_position());
	var swordAngle:float = sword.rotation_degrees;
	if (swordAngle - oldSwordAngle) < -0.2:
		swordInnerOrigin.scale.y = -1;
	elif (swordAngle - oldSwordAngle) > 0.2:
		swordInnerOrigin.scale.y = 1;
		
	# flipping duck depending on if katana is on the right or left side of the duck
	if abs(sword.global_rotation_degrees) > 90:
		duckSprite.flip_h = false;
	else:
		duckSprite.flip_h = true;
	
	if Input.is_action_just_pressed("dash") and dashCooldownRemaining <= 0 and poisonedTimeRemaining <= 0:
		dashPoisonSfxPlayer.stream = dashSFX;
		dashPoisonSfxPlayer.pitch_scale = 1.0;
		dashPoisonSfxPlayer.play();
		if dash_tween and dash_tween.is_running():
			dash_tween.kill()
		dashCooldownBar.modulate = Color(1.0, 1.0, 1.0, 1.0);
		dashCooldownRemaining = dashCooldown;
		dashDirection = lastDirection;
		dashTimeRemaining = dashTime;
		dash_tween = get_tree().create_tween();
		humSfxPlayer.pitch_scale = 0.5;
		dash_tween.tween_property(dashCooldownBar, "value", 0.0, dashTime);
		dash_tween.parallel().tween_property(camera, "zoom", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_CUBIC);
		dash_tween.tween_callback(humSfxPlayer.play);
		dash_tween.tween_property(dashCooldownBar, "value", 100.0, dashCooldown-0.1);
		dash_tween.parallel().tween_property(humSfxPlayer, "pitch_scale", 2.0, dashCooldown-0.1);
		dash_tween.parallel().tween_property(camera, "zoom", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_CUBIC);
		dash_tween.tween_callback(humSfxPlayer.stop);
		dash_tween.tween_property(dashCooldownBar, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5);
	
	if poisonedTimeRemaining > 0:
		poisonedBar.value = (poisonedTimeRemaining/poisonedTime)*poisonedBar.max_value;
		poisonedBar.modulate.a = 1.0;
		speed = originalSpeed*poisonSlowdown;
	else:
		poisonedBar.modulate.a = lerpf(poisonedBar.modulate.a, 0.0, 8 * delta); # 8 * delta is 0.5s for some reason and I'm not even sure it IS 0.5s 
		speed = originalSpeed;
		
	dashCooldownRemaining -= delta;
	dashTimeRemaining -= delta;
	poisonedTimeRemaining -= delta;
	
	# clamping speed at max speed
	if linear_velocity.length() > maxSpeed and dashTimeRemaining <= 0:
		linear_velocity = linear_velocity.normalized() * maxSpeed
	elif linear_velocity.length() > dashMaxSpeed:
		linear_velocity = linear_velocity.normalized() * dashMaxSpeed
	
	
	
	if Input.is_action_pressed("do") and canMoveToNextArea:
		elapsedHoldTime += delta;
	else:
		elapsedHoldTime = 0;
	if elapsedHoldTime > holdTime:
		gameManager.finish_level();
	holdTimeLabel.text = str(round((holdTime - elapsedHoldTime)*10)/10);

func deal_damage(damage:float):
	if gameManager.dying:
		return;
	theEndMenu.damageTaken += damage;
	hp -= damage;
	if hp <= 0:
		gameManager.restart_current_area();
	hurtSfxPlayer.stream = hurtSFX;
	hurtSfxPlayer.pitch_scale = randf_range(0.9, 1.1);
	hurtSfxPlayer.play();

func get_damage() -> float:
	return damage;

func get_hp() -> float:
	return hp

func get_max_hp() -> float:
	return maxHP

func teleport_to(point:Vector2):
	global_position = point;

func reset_hp() -> void:
	hp = maxHP;

func heal_hp(amt:float) -> void:
	if (hp + amt) > maxHP:
		reset_hp();
	else:
		hp += amt;

func _on_collision_check_area_entered(area: Area2D) -> void:
	if area.is_in_group("next_area_trigger"):
		canMoveToNextArea = true;
		holdTimeLabel.visible = true;

func _on_collision_check_area_exited(area: Area2D) -> void:
	if area.is_in_group("next_area_trigger"):
		canMoveToNextArea = false;
		holdTimeLabel.visible = false;

func level_start_animation() -> void:
	levelLabel.modulate = Color(1.0, 1.0, 1.0, 1.0);
	camera.zoom = Vector2(2.0, 2.0);
	var labelTween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO);
	var cameraTween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO);
	labelTween.tween_property(levelLabel, "modulate", Color(1.0, 1.0, 1.0, 0.0), 1.5);
	cameraTween.tween_property(camera, "zoom", Vector2(1.0, 1.0), 1.5)

func make_poisoned() -> void:
	if poisonedTimeRemaining <= 0:
		dashPoisonSfxPlayer.stream = poisonSFX;
		dashPoisonSfxPlayer.pitch_scale = 1.0;
		dashPoisonSfxPlayer.play();
	elif !dashPoisonSfxPlayer.playing:
		dashPoisonSfxPlayer.stream = poisonSFX;
		dashPoisonSfxPlayer.pitch_scale = randf_range(0.9, 1.1);
		dashPoisonSfxPlayer.play(0.1);
	poisonedTimeRemaining = poisonedTime;
