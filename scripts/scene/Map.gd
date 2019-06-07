extends Node2D

onready var hub = get_node("/root/Hub");

export(String) var channel = "global";

func _ready():
	hub.channel(channel);