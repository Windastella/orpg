extends KinematicBody2D
class_name Entity

onready var playback = get_node("AnimationTree").get("parameters/playback");

export(float) var movespeed = 100;
var dir = Vector2.ZERO;

func _ready():
	playback.start("down");
	
func move(motion):
	if(motion != Vector2.ZERO):
		dir = motion;
		
		if(motion.y == -1):
			playback.travel("walk_up");
		elif(motion.y == 1):
			playback.travel("walk_down");
		elif(motion.x == -1):
			playback.travel("walk_left");
		elif(motion.x == 1):
			playback.travel("walk_right");
		
		move_and_slide(motion * movespeed);
	else:
		if(dir.y == -1):
			playback.travel("up");
		elif(dir.y == 1):
			playback.travel("down");
		elif(dir.x == -1):
			playback.travel("left");
		elif(dir.x == 1):
			playback.travel("right");
	post_move(motion);
	
func post_move(motion):
	pass