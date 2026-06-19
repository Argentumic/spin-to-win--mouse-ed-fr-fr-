extends RigidBody2D

@export var maxHP = 100;
var hp:float;
@export var speed:int = 50;
@export var angularSpeed:int = 1600;
@export var maxSpeed:int = 1000;
@export var damage:int = 20;
@export var healthBarForeground:Sprite2D;

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
	healthBarForeground.scale.x = hp/maxHP;
	if hp <= 0:
		print("dead");

func get_damage() -> int:
	return damage;
