extends Button

@onready var file_dialog: FileDialog = $file_dialog

func _on_pressed():
	file_dialog.show()

func _on_file_dialog_file_selected(path):
	text = path
