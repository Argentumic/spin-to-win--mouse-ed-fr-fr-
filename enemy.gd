extends CharacterBody2D

@export var speed = 800;
@export var maxHP = 100;
var player:RigidBody2D;
var target = position;
var hp:float;
var is_player_inside:bool = false;

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	hp = maxHP;

func deal_damage(damage:int):
	hp -= damage;
	if hp <= 0:
		_kms();

func _physics_process(delta):
	target = player.global_position;
	velocity = position.direction_to(target) * speed;
	#look_at(target);
	if position.distance_to(target) > 10:
		move_and_slide();

func _kms():
	self.queue_free()

func get_hp() -> float:
	return hp

func get_max_hp() -> float:
	return maxHP

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		is_player_inside = true;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		is_player_inside = false;

func _on_timer_timeout() -> void:
	if is_player_inside:
		player.deal_damage(10);
