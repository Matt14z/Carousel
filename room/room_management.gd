extends Control

@onready var csv = load(Global.current_csv)
var record = preload("res://objects/record_product.tscn")
var filtered_csv: Array

@onready var vcontainer = $ScrollContainer/VBoxContainer
@onready var count_pages = $bar/count_pages
@onready var to_search = $bar/to_search

var how_many_to_show = 50
var current = 0
var num_of_pages: int

func _ready():
	count_pages.text = str(current+1) + "/" + str(num_of_pages+1)
	filter(to_search.text)
	clear_and_show(current, filtered_csv)

func _process(delta):
	if Input.is_action_just_pressed("go_back"):
		get_tree().change_scene_to_file("res://room/room_saves.tscn")

func clear_and_show(which: int, arr: Array):
	num_of_pages = arr.size() / 50
	count_pages.text = str(current+1) + "/" + str(num_of_pages+1)
	
	for child in vcontainer.get_children():
		child.queue_free()
	
	for i in range(current * how_many_to_show, (current * how_many_to_show) + how_many_to_show):
		if i >= arr.size():
			break
		
		if not arr[i][4] == "Nombre":
			var tmp: RecordProduct = record.instantiate()
			tmp.csv_name = str(arr[i][4])
			tmp.csv_image = str(arr[i][30])
			tmp.reference_code = str(arr[i][2])
			
			if not Global.current_data.count(tmp.reference_code) == 0:
				tmp.pressed = true
			else:
				tmp.pressed = false
			
			vcontainer.add_child(tmp)

func _on_btn_back_pressed():
	current -= 1
	current = clamp(current, 0, num_of_pages)
	count_pages.text = str(current+1) + "/" + str(num_of_pages+1)
	clear_and_show(current, filtered_csv)

func _on_btn_forward_pressed():
	current += 1
	current = clamp(current, 0, num_of_pages)
	count_pages.text = str(current+1) + "/" + str(num_of_pages+1)
	clear_and_show(current, filtered_csv)

func _on_btn_buscar_pressed():
	filter(to_search.text)
	current = 0
	clear_and_show(current, filtered_csv)

func filter(text: String):
	filtered_csv.clear()
	for i in range(0, csv.records.size()):
		if text == "":
			filtered_csv.push_back(csv.records[i])
		elif csv.records[i][4].capitalize().contains(text.capitalize()):
			filtered_csv.push_back(csv.records[i])

func _on_btn_save_pressed():
	var f = FileAccess.open(Global.current_save_file, FileAccess.WRITE)
	f.store_string(Global.current_file_name + "," + Global.current_csv)
	for code in Global.current_data:
		f.store_string("," + code)
	f.close()

func _on_btn_show_pressed():
	get_tree().change_scene_to_file("res://room/room_carousel.tscn")
