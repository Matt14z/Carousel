extends Label

@export var max_size: float = 48
@export var min_size: float = 36;
@export var max_lines = 6;

var fontRangeDiff:float = 0;
var fontChangePerLine: float = 0;

func _ready():
	fontRangeDiff = float(max_size) - float(min_size)
	fontChangePerLine = float(fontRangeDiff)/(float(max_size)-1) 

func _process(delta):
	add_theme_font_size_override("font_size", float(max_size) - (fontChangePerLine * 50.0))
