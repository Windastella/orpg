extends Entity
class_name Player

onready var hub = get_node("/root/Hub");
onready var main = get_node("/root/main");

export(bool) var isPlayer = false;
export(int) var id = null;

onready var cam = get_node("cam");

enum {MOVING, IDLE}
var state = MOVING;

func _ready():
	cam.current = isPlayer;
	
	if(!isPlayer):
		hub.conn.connect("message",self,"_on_message");
		movespeed = 0;
		
	set_physics_process(true);

func _on_message(data):
	if(data.ID == id):
		match(data.event):
			"moving":
				position = Vector2(data.data.x, data.data.y);
				dir = Vector2(data.data.dirx, data.data.diry);
				move(dir);
			"idle":
				position = Vector2(data.data.x, data.data.y);
				dir = Vector2(data.data.dirx, data.data.diry);
				move(Vector2.ZERO);
				
func _physics_process(delta):
	if(!isPlayer):
		return;
		
	if(main.inMenu || main.typing):
		return;
		
	var motion = Vector2.ZERO;
	if(Input.is_action_pressed("ctrl_up")):
		motion.y = -1;
	elif(Input.is_action_pressed("ctrl_down")):
		motion.y = 1;
	elif(Input.is_action_pressed("ctrl_left")):
		motion.x = -1;
	elif(Input.is_action_pressed("ctrl_right")):
		motion.x = 1;
		
	move(motion);

func post_move(motion):
	if(motion != Vector2.ZERO):
		state = MOVING;
		hub.conn.multicast({ 
			event="moving", 
			ID = id, 
			data = { 
				x = position.x, 
				y = position.y, 
				dirx = dir.x, 
				diry = dir.y
			}
		});
	else:
		if(state == MOVING):
			state = IDLE;
			hub.conn.multicast({ 
				event="idle", 
				ID = id,
				data = { 
					x = position.x, 
					y = position.y, 
					dirx = dir.x, 
					diry = dir.y
				}
			});