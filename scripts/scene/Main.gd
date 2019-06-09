extends Node

onready var SceneManager = get_node("/root/SceneManager")
onready var hub = get_node("/root/Hub");

onready var main_menu = get_node("ui/main_menu");
onready var world = get_node("world");

export(Color) var clear_color = Color("#322125");
export(String, FILE) var defaultLevel = "res://scenes/map/map01.tscn"

var inMenu = true;

var inChat = false;
var typing = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(clear_color);
	
	hub.conn.connect("message",self,"_on_receive_message");
	hub.connect("channel",self,"_on_channel_change");

func _process(delta):
	var empty = world.get_child_count() == 0;
	
	# main menu
	if(!empty && Input.is_action_just_pressed("ui_cancel")):
		inMenu = !inMenu;
		
	main_menu.visible = inMenu;
	
	get_node("ui/background").visible = empty;
	get_node("ui/main_menu/continue").visible = !empty;
	get_node("ui/main_menu/new_game").disabled = !empty;
	get_node("ui/main_menu/load_game").disabled = empty;
	
	# chat hud
	if(!typing && Input.is_action_just_pressed("ui_chat") ):
		inChat = !inChat;
		
		get_node("ui/chat_menu/chat_opened").visible = inChat;
		get_node("ui/chat_menu/chat_closed").visible = !inChat;
		
	if(typing && Input.is_action_just_pressed("ui_accept")):
		_on_chat_input_submit()
	
func _on_new_game_pressed():
	SceneManager.nextLevel(defaultLevel);
	inMenu = false;

func _on_exit_pressed():
	get_tree().quit();

func _on_continue_pressed():
	inMenu = !inMenu;
	
func _on_channel_change():
	get_node("ui/chat_menu/chat_opened/chat_box").bbcode_text = "";
	get_node("ui/chat_menu/chat_closed/chat_box").bbcode_text = "";
	
func _on_message_received(data):
	match(data.event):
		"chat":
			get_node("ui/chat_menu/chat_opened/chat_box").append_bbcode(data.name+" > "+data.msg);
			get_node("ui/chat_menu/chat_closed/chat_box").bbcode_text = data.name+" > "+data.msg;

func _on_chat_input_focus_entered():
	typing = true;

func _on_chat_input_focus_exited():
	typing = false;

func _on_chat_input_submit():
	var text = get_node("ui/chat_menu/chat_opened/chat_input").text;
	if(!text.empty()):
		var data = {
			event="chat",
			ID=hub.conn.client.ID,
			name="player_"+String(hub.conn.client.ID),
			msg=text
		}
		
		hub.conn.multicast(data);
		_on_message_received(data);
		
	get_node("ui/chat_menu/chat_opened/chat_input").text = "";