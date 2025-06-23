extends Control

@onready var timer: Timer = $timer
@onready var csv = load(Global.current_csv)
@onready var slide_product = preload("res://objects/slide_product.tscn")
var inst: SlideProduct
var current = 0

var to_show: Array

func _ready():
	for record in csv.records:
		if not Global.current_data.count(record[2]) == 0:
			to_show.push_back(record)
	
	inst = slide_product.instantiate()
	inst.data = ProductData.new()
	inst.data.name = to_show[current][4]
	inst.data.price = to_show[current][26]
	inst.data.img_url = to_show[current][30]
	
	add_child(inst)
	
	current += 1
	
	timer.start()

func _process(delta):
	if Input.is_action_just_pressed("go_back"):
		get_tree().change_scene_to_file("res://room/room_saves.tscn")

func _on_timer_timeout():
	inst.queue_free()
	
	current = current % to_show.size()
	
	inst = slide_product.instantiate()
	inst.data = ProductData.new()
	inst.data.name = to_show[current][4]
	inst.data.price = to_show[current][26]
	inst.data.img_url = to_show[current][30]
	
	current += 1

	
	add_child(inst)
	timer.start()
