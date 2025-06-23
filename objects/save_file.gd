extends Control

@export var title: String
@export_file var file: String

@onready var title_node: Label = $HBoxContainer/name

func _ready():
	title_node.text = title

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_btn_open_pressed():
	var content: PackedStringArray = load_from_file(file)
	content = content[0].split(",")
	Global.current_file_name =str(content[0])
	Global.current_save_file = file
	content.remove_at(0)
	content.remove_at(0)
	Global.current_data = content
	get_tree().change_scene_to_file("res://room/room_management.tscn")

func load_from_file(file: String):
	var fa = FileAccess.open(file, FileAccess.READ)
	var content = fa.get_as_text()
	return content.split("\n")
