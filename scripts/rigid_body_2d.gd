extends RigidBody2D

@export var maxHP = 100;
var hp:float;
@export var speed:int = 20;
@export var angularSpeed:int = 2;
@export var maxSpeed:int = 600;
@export var dashMaxSpeed: int = 1000;
@export var damage:int = 20;
var gameManager;
var canMoveToNextArea:bool = false;

@onready var duckSprite = $Duck;
@onready var sword = $Sword;
@onready var swordSprite = $Sword/Sword;

@export var dashCooldown:float = 1.0;
var dashCooldownRemaining:float = 0.0;
@export var dashTime:float = 0.15;
var dashTimeRemaining:float = 0.0;
@onready var dashCooldownBar = $DashCooldownBar;
var dash_tween:Tween;

# hold time for transitioning to next area in seconds
@onready var holdTimeLabel = $"../CanvasLayer/Control/HoldTimeLabel";
var holdTime:float = 5;
var elapsedHoldTime:float = 0;

func _ready() -> void:
	hp = maxHP;
	gameManager = get_tree().get_first_node_in_group("game_manager");

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
	if (swordAngle - oldSwordAngle) < -0.1:
		swordSprite.flip_h = false;
	elif (swordAngle - oldSwordAngle) > 0.1:
		swordSprite.flip_h = true;
		
	# flipping duck depending on if katana is on the right or left side of the duck
	if abs(sword.global_rotation_degrees) > 90:
		duckSprite.flip_h = false;
	else:
		duckSprite.flip_h = true;
	
	if Input.is_action_just_pressed("dash") and dashCooldownRemaining <= 0:
		if dash_tween and dash_tween.is_running():
			dash_tween.kill()
		dashCooldownBar.modulate = Color(1.0, 1.0, 1.0, 1.0);
		dashCooldownRemaining = dashCooldown;
		dashDirection = lastDirection;
		dashTimeRemaining = dashTime;
		dash_tween = get_tree().create_tween();
		dash_tween.tween_property(dashCooldownBar, "value", 0.0, dashTime);
		dash_tween.tween_property(dashCooldownBar, "value", 100.0, dashCooldown-0.1);
		dash_tween.tween_property(dashCooldownBar, "modulate", Color(1.0, 1.0, 1.0, 0.0), 0.5);
		
	
	dashCooldownRemaining -= delta;
	dashTimeRemaining -= delta;
	
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

func deal_damage(damage:int):
	hp -= damage;
	if hp <= 0:
		gameManager.restart_current_area();

func get_damage() -> int:
	return damage;

func get_hp() -> float:
	return hp

func get_max_hp() -> float:
	return maxHP

func teleport_to(point:Vector2):
	position = point;

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
