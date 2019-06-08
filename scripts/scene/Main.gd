extends Node

onready var SceneManager = get_node("/root/SceneManager")
onready var hub = get_node("/root/Hub");

onready var main_menu = get_node("ui/main_menu");
onready var world = get_node("world");

export(Color) var clear_color = Color("#322125");
export(String, FILE) var defaultLevel = "res://scenes/map/map01.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(clear_color);
	#SceneManager.nextLevel(defaultLevel);

func _process(delta):
	var empty = world.get_child_count() == 0;
	
	if(!empty && Input.is_action_just_pressed("ui_cancel")):
		main_menu.visible = !main_menu.visible;
	
	get_node("ui/background").visible = empty;
	get_node("ui/main_menu/continue").visible = !empty;
	
func _on_new_game_pressed():
	SceneManager.nextLevel(defaultLevel);
	main_menu.visible = false;

func _on_exit_pressed():
	get_tree().quit();


func _on_continue_pressed():
	main_menu.visible = !main_menu.visible;
