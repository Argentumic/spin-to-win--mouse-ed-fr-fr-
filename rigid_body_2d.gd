extends RigidBody2D

@export var maxHP = 100;
var hp:float;
@export var speed:int = 20;
@export var angularSpeed:int = 200;
@export var maxSpeed:int = 800;
@export var damage:int = 20;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hp = maxHP;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down");
	apply_central_force(input_direction*speed);
	apply_torque(get_angle_to(get_global_mouse_position())*angularSpeed);
	if linear_velocity.length() > maxSpeed:
		linear_velocity = linear_velocity.normalized() * maxSpeed

func deal_damage(damage:int):
	print("damaged");
	hp -= damage;
	if hp <= 0:
		print("dead");

func get_damage() -> int:
	return damage;

func get_hp() -> float:
	return hp

func get_max_hp() -> float:
	return maxHP

func teleport_to(point:Vector2):
	position = point;
