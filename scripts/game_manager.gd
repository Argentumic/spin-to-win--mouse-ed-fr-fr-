extends Node

var areaPath = "res://areas/";
var startingArea = 1;
var currentArea = startingArea;
var areaContainer;
var player;
var camera;
var transition;
@onready var pauseMenu = $"../CanvasLayer/Control/Pause";
@onready var levelUpMenu = $"../CanvasLayer/Control/LevelUp"
@onready var musicPlayer = $"../MusicPlayer"
@onready var mainTheme = preload("res://duckinja main theme (demo 1).mp3");
@onready var elevatorMusic = preload("res://duckinja_elevator music(demo 1).mp3");
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	areaContainer = get_tree().get_first_node_in_group("area_container");
	player = get_tree().get_first_node_in_group("player");
	camera = get_tree().get_first_node_in_group("camera");
	transition = get_tree().get_first_node_in_group("transition");
	_load_area(startingArea);

func _next_area() -> void:
	currentArea += 1;
	transition.toggle_transition();
	get_tree().paused = true;
	await transition.done_transitioning;
	_load_area(currentArea);
	transition.toggle_transition();

func _load_area(area:int) -> void:
	get_tree().paused = true;
	var fullPath =  areaPath + "area_" + str(area) + ".tscn"; 
	for child in areaContainer.get_children():
		child.queue_free();
	var scene:PackedScene = load(fullPath);
	var instance:Node = scene.instantiate();
	areaContainer.add_child(instance);
	var playerSpawnpoint:Node2D = get_tree().get_first_node_in_group("spawn_point");
	player.teleport_to(playerSpawnpoint.position);
	camera.teleport_to(playerSpawnpoint.position);
	get_tree().paused = false;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func restart_current_area() -> void:
	transition.toggle_transition();
	await transition.done_transitioning;
	_load_area(currentArea);
	transition.toggle_transition();
	player.reset_hp();

func finish_level() -> void:
	musicPlayer.stop();
	await _next_area();
	get_tree().paused = true;
	musicPlayer.stream = elevatorMusic;
	musicPlayer.play();
	levelUpMenu.visible = true;
	levelUpMenu.add_points(1);
