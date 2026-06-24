extends Node

var areaPath = "res://areas/";
var startingArea = 1;
var currentArea = startingArea;
var areaContainer;
var player;
var camera;
var transition;
@onready var pauseMenu = $"../CanvasLayer/Control/Pause";
var levelUpMenu;
@onready var musicPlayer = $"../MusicPlayer"
@onready var mainTheme = preload("res://duckinja main theme (demo 1).mp3");
@onready var elevatorMusic = preload("res://duckinja_elevator music(demo 1).mp3");
var collectedPoints:int = 0;

func _ready() -> void:
	areaContainer = get_tree().get_first_node_in_group("area_container");
	player = get_tree().get_first_node_in_group("player");
	camera = get_tree().get_first_node_in_group("camera");
	transition = get_tree().get_first_node_in_group("transition");
	levelUpMenu = get_tree().get_first_node_in_group("level_up_menu");
	_load_area(startingArea);

func _next_area() -> void:
	currentArea += 1;
	transition.toggle_transition();
	get_tree().paused = true;
	await transition.done_transitioning;
	await _load_area(currentArea);
	transition.toggle_transition();

func _load_area(area:int) -> void:
	get_tree().paused = true;
	var fullPath =  areaPath + "area_" + str(area) + ".tscn"; 
	for child in areaContainer.get_children():
		child.queue_free();
	var scene:PackedScene = load(fullPath);
	var instance:Node = scene.instantiate();
	areaContainer.add_child(instance);
	await get_tree().process_frame;
	var playerSpawnpoint:Node2D = get_tree().get_first_node_in_group("spawn_point");
	player.teleport_to(playerSpawnpoint.global_position);
	camera.teleport_to(playerSpawnpoint.global_position);
	get_tree().paused = false;

func restart_current_area() -> void:
	transition.toggle_transition();
	await transition.done_transitioning;
	_load_area(currentArea);
	transition.toggle_transition();
	player.reset_hp();
	player.poisonedTimeRemaining = 0;
	collectedPoints = 0;

func finish_level() -> void:
	musicPlayer.stop();
	await _next_area();
	levelUpMenu.add_points(collectedPoints);
	collectedPoints = 0;
	get_tree().paused = true;
	musicPlayer.stream = elevatorMusic;
	musicPlayer.play();
	levelUpMenu.visible = true;
