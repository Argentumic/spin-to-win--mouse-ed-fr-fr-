extends Sprite2D

@onready var theEndMenu = $"../../../../CanvasLayer/Control/TheEnd";
@onready var swordSfxPlayer = $SwordSfxPlayer
var hitSFX = preload("res://sfx/duck_katana hitting.ogg");

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var damage:int = get_parent().get_parent().get_parent().get_damage();
		swordSfxPlayer.stream = hitSFX;
		swordSfxPlayer.pitch_scale = randf_range(0.9, 1.1);
		swordSfxPlayer.play();
		body.deal_damage(damage);
		theEndMenu.damageDealt += damage;
