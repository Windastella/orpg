extends Node2D

onready var hub = get_node("/root/Hub");

export(String) var channel = "global";
export(NodePath) var spawnPoint;
var spawn = Vector2.ZERO;

func _ready():
	hub.channel(channel);
	
	if(has_node(spawnPoint)):
		spawn = get_node(spawnPoint).position;
	
	if(!get_parent().has_node("player_"+String(hub.conn.client.ID))):
		SceneManager.spawnPlayer("res://scenes/entities/entity.tscn", true, hub.conn.client.ID, spawn);
		
	hub.connect("channel",self,"_on_channel");
	hub.conn.connect("join",self,"_on_join");
	hub.conn.connect("left",self,"_on_left");
	
func _on_channel():
	pass
	
func _on_join(id):
	if(!get_parent().has_node("player_"+String(id))):
		SceneManager.spawnPlayer("res://scenes/entities/entity.tscn", false, id, spawn);
	
	var player = get_parent().get_node("player_"+String(hub.conn.client.ID)) as Player;
	if(player == null):
		return
		
	hub.conn.unicast({
			event="idle", 
			ID = hub.conn.client.ID, 
			data = { 
				x = player.position.x, 
				y = player.position.y, 
				dirx = player.dir.x, 
				diry = player.dir.y
			}
		}, id);
		
func _on_left(id):
	var player = get_parent().get_node("player_"+String(id)) as Player;
	if(player == null):
		return
		
	player.queue_free();

func _exit_tree():
	hub.channel("global");
	