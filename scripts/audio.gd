extends VBoxContainer

@onready var masterSlider = $MasterSlider/MasterSlider;
@onready var musicSlider = $MusicSlider/MusicSlider;
@onready var sfxSlider = $SfxSlider/SfxSlider;
var masterSliderIndex;
var musicSliderIndex;
var sfxSliderIndex;

func _ready() -> void:
	masterSliderIndex = AudioServer.get_bus_index("Master");
	musicSliderIndex = AudioServer.get_bus_index("Music");
	sfxSliderIndex = AudioServer.get_bus_index("SFX");
	masterSlider.value = AudioServer.get_bus_volume_linear(masterSliderIndex);
	musicSlider.value = AudioServer.get_bus_volume_linear(musicSliderIndex);
	sfxSlider.value = AudioServer.get_bus_volume_linear(sfxSliderIndex);


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(masterSliderIndex, value);


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(musicSliderIndex, value);


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(sfxSliderIndex, value);
