extends Node

var conn;
var env;
var connected = false;

signal channel()

func _ready():
	set_process(true)
	env = get_node("/root/env");
	conn = GodotHub.new( int(env.get("SERVER_PORT")), env.get("SERVER_HOST") );
	
	conn.connect("error",self,"_on_error")
	conn.connect("connected",self,"_on_connected")
	conn.connect("message",self,"_on_receive")
	conn.connect("join",self,"_on_join")
	conn.connect("left",self,"_on_left")
	conn.connect("ping",self,"_on_ping")
	
func channel(channelname):
	conn.change_channel(channelname);
	emit_signal("channel");
	
func _process(dt):
	conn.is_listening()
	
func _on_error(err):
	print("Error: ",err)
	connected = false;
	
func _on_connected():
	print("Connected to server as "+String(conn.client.ID))
	connected = true;
	
func _on_join(id):
	print(id);
	
func _on_left(id):
	print(id);
	
func _on_ping(ping):
	print("Ping: ",ping)
	
func _on_receive(data):
	#print("Receive Data: ",data)
	pass;
	
func _exit_tree():
	conn.disconnect_server()