extends Node

onready var SceneManager = get_node("/root/SceneManager")
onready var hub = get_node("/root/Hub");

export(Color) var clear_color = Color("#322125");
export(String, FILE) var defaultLevel = "res://scenes/map/map01.tscn"

var connected = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(clear_color);
	SceneManager.nextLevel(defaultLevel);

	hub.connect("channel",self,"_on_channel");
	hub.conn.connect("connected",self,"_on_connected");
	hub.conn.connect("join",self,"_on_join");
	hub.conn.connect("left",self,"_on_left");

func _on_channel():
	SceneManager.spawnPlayer("res://scenes/entities/entity.tscn", true, hub.conn.client.ID, Vector2.ZERO);

func _on_connected():
	connected = true;
	
func _on_join(data):
	SceneManager.spawnPlayer("res://scenes/entities/entity.tscn", false, data.ID, Vector2.ZERO);

func _on_left(data):
	connected = false;
