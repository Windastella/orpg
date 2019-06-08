extends Node

onready var SceneManager = get_node("/root/SceneManager")
onready var hub = get_node("/root/Hub");

export(Color) var clear_color = Color("#322125");
export(String, FILE) var defaultLevel = "res://scenes/map/map01.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(clear_color);
	SceneManager.nextLevel(defaultLevel);
