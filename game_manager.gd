extends Node

var areaPath = "res://areas/";
var startingArea = 1;
var currentArea = startingArea;
var areaContainer;
var player;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	areaContainer = get_tree().get_first_node_in_group("area_container");
	player = get_tree().get_first_node_in_group("player");
	_load_area(startingArea);

func _next_area() -> void:
	currentArea += 1;
	_load_area(currentArea);

func _load_area(area:int) -> void:
	var fullPath =  areaPath + "area_" + str(area) + ".tscn"; 
	for child in areaContainer.get_children():
		child.queue_free();
	var scene:PackedScene = load(fullPath);
	var instance:Node = scene.instantiate();
	areaContainer.add_child(instance);
	var playerSpawnpoint:Node2D = get_tree().get_first_node_in_group("spawn_point");
	player.teleport_to(playerSpawnpoint.position);
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
