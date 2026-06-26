extends CharacterBody2D

var isActive:bool = false;
@export var speed:float = 400;
@export var maxHP:float = 100;
@export var dps:float = 10;
@export var powerOfHpRestoration:float = 20;
var player:RigidBody2D;
var target = position;
var hp:float;
var is_player_inside:bool = false;
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D;
var heal_node = preload("res://heal.tscn");
var soul_node = preload("res://soul.tscn");
@onready var sprite:Sprite2D = $Sprite2D;
var fullWhiteShaderMaterial = preload("res://shaders/full_white.tres");

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0
	
	player = get_tree().get_first_node_in_group("player")
	hp = maxHP
	
	# Make sure to not await during _ready.
	actor_setup.call_deferred()

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(player.global_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	if navigation_agent.is_navigation_finished() or !isActive:
		return
	actor_setup.call_deferred()
	var current_agent_position: Vector2 = global_position;
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	if abs(rad_to_deg(get_angle_to(next_path_position))) > 90:
		sprite.flip_h = false;
	else:
		sprite.flip_h = true;
	velocity = current_agent_position.direction_to(next_path_position) * speed
	move_and_slide()
	
func get_hp() -> float:
	return hp

func get_max_hp() -> float:
	return maxHP

func deal_damage(damage:int) -> void:
	hp -= damage;
	_damaged_effect();
	if hp <= 0:
		_kms();

func _damaged_effect() -> void:
	sprite.material = fullWhiteShaderMaterial;
	await get_tree().create_timer(0.05).timeout;
	sprite.material = null;

func is_active() -> bool:
	return isActive;

func _kms():
	if randi()%100+1 <= 20:
		_spawn_heal();
	_spawn_soul();
	self.queue_free();

func _spawn_heal():
	var node:Node2D = heal_node.instantiate() as Node2D;
	node.global_position = global_position;
	node.powerOfHpRestoration = powerOfHpRestoration;
	get_parent().add_child(node);

func _spawn_soul():
	var node:Node2D = soul_node.instantiate() as Node2D;
	node.global_position = global_position;
	get_parent().add_child(node);

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		is_player_inside = true;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_inside = false;

func _on_timer_timeout() -> void:
	$EnemyAttackSFXPlayer.play();
	if is_player_inside:
		player.deal_damage(dps);

func _on_wake_up_area_body_entered(body: Node2D) -> void:
	if body == player:
		isActive = true;
