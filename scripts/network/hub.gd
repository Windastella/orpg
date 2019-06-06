extends Node

var conn;
var env;

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
	
func _process(dt):
	conn.is_listening()
	
func _on_error(err):
	print("Error: ",err)
	
func _on_connected():
	print("Connected to server")
	
func _on_join(data):
	print(data.msg)
	
func _on_left(data):
	print(data.msg)
	
func _on_ping(ping):
	print("Ping: ",ping)
	
func _on_receive(data):
	print("Receive Data: ",data)
	
func _exit_tree():
	conn.disconnect_server()