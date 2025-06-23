extends Control

@onready var save_node: PackedScene = preload("res://objects/save_file.tscn")
@onready var vbox: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var file: Button = $file
@onready var title: LineEdit = $name

func _ready():
	var dir = DirAccess.open(OS.get_environment("USERPROFILE") + "/carousel_save_files")
	
	if dir == null:
		dir = DirAccess.open(OS.get_environment("USERPROFILE"))
		dir.make_dir("carousel_save_files")
	else:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			var inst = save_node.instantiate()
			inst.title = file_name
			inst.file = OS.get_environment("USERPROFILE") + "/carousel_save_files/" + file_name
			
			var fa = FileAccess.open(inst.file, FileAccess.READ)
			var content = fa.get_as_text().split(",")
			Global.current_csv = content[1]
			
			vbox.add_child(inst)
			file_name = dir.get_next()

func _process(delta):
	pass

func _on_plus_pressed():
	var t: String = title.text
	var do_exist = FileAccess.file_exists(file.text)
	
	if do_exist and t.length() >= 0:
		Global.current_csv = file.text
		Global.current_file_name = title.text
		get_tree().change_scene_to_file("res://room/room_management.tscn")
		var f = FileAccess.open(OS.get_environment("USERPROFILE") + "/carousel_save_files" + "/" + t, FileAccess.WRITE)
		f.store_string(t + "," + file.text)
		Global.current_save_file = OS.get_environment("USERPROFILE") + "/carousel_save_files" + "/" + t
		f.close()
