extends Node

onready var world = get_node("/root/main/world");

onready var loader = SceneLoader.new();

class SceneLoader:
	var scenes = []
	
	var m 
	var t
	
	signal loading(s,l)
	signal loaded(r)
	signal error(m)
	
	func _init():
		t = Thread.new()
		m = Mutex.new()
	
	func hasScene(path):
		for item in scenes:
			if item.get_path() == path:
				return item;
		return null;
		
	func loadScene(path):
		var scene = hasScene(path);
		if(scene != null):
			return scene
		
		scene = load(path);
		scenes.push_front(scene);
		return scenes[0];
		
	func loadSceneAsync(path):
		t.start(self,"_loadSceneAsync", path);
		 
	func _loadSceneAsync(path):
		var res = ResourceLoader.load_interactive(path);
		while res.poll() == OK:
			call_deferred("_send_loading_signal", res.get_stage(), res.get_stage_count())
		
		if(res.poll() != ERR_FILE_EOF):
			call_deferred("_send_error_signal");
			return res.poll()
			
		var scene = res.get_resource();
		scenes.push_front(scene);
		call_deferred("_send_loaded_signal");
		return scenes[0];
	
	func _send_loading_signal(size,length):
		emit_signal("loading",size,length)
	 
	func _send_loaded_signal():
		var result = t.wait_to_finish()
		emit_signal("loaded",result)
		
	func _send_error_signal():
		var result = t.wait_to_finish()
		emit_signal("error",result)
		
func _ready():
	loader.connect("loading",self,"_sceneLoading");
	loader.connect("loaded",self,"_sceneLoaded");
	
func loadMap(path):
	var res = loader.hasScene(path);
	if(res != null):
		world.add_child(res.instance());
	
	loader.loadSceneAsync(path);
	
func _sceneLoading(size, length):
	pass
	
func _sceneLoaded(scene):
	world.add_child(scene.instance());
	
func nextLevel(scenepath):
	clearLevel()
	loadMap(scenepath)

func clearLevel():
	var child = world.get_children()
	for item in child:
		item.queue_free()

func spawnPlayer(path, isPlayer, id, pos):
	var player = loader.loadScene(path).instance()
	player.position = pos;
	player.id = id;
	player.isPlayer = isPlayer;
	player.name = "player_"+String(id);
	world.add_child(player);
		
#func spawnEntity(path, pos):
#	var entity = loader.loadScene(path).instance()
#	entity.set_translation(pos)
#	world.add_child(entity)
	
#func spawnProjectile(path, offset, dir, ref):
#	var projectile = loader.loadScene(path).instance();
#	projectile.set_translation(offset);
#	projectile.setDirection(dir);
#	projectile.setOwner(ref);
#	world.add_child(projectile);