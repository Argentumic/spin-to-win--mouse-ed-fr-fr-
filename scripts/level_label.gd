extends Label

var gameManager;

func _ready() -> void:
	gameManager = get_tree().get_first_node_in_group("game_manager");

func _process(delta: float) -> void:
	text = str("Level ", gameManager.currentArea)
