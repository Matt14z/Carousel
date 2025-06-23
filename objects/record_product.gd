class_name RecordProduct
extends Control

var csv_name: String = "INVALID_PRODUCT"
var csv_image: String = "INVALID IMAGE"
var csv_price: String = "INVALID PRICE"
var reference_code: String = ""

@onready var product: Label = $HBoxContainer/name
@onready var presentable: CheckBox = $HBoxContainer/presentable
@onready var image_product: TextureRect = $HBoxContainer/image
@onready var image_big: TextureRect = $CanvasLayer/image_big
var pressed: bool = false
var http_request: HTTPRequest = HTTPRequest.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(http_request)
	
	image_big.texture = image_product.texture
	
	var str: String
	
	if csv_name.length() > 50:
		str = csv_name.substr(0, 20)
		str += "..."
		str += csv_name.substr(40)
		product.text = str
	else:
		product.text = csv_name
	
	presentable.set_pressed_no_signal(pressed)
	
	if product.text == "INVALID PRODUCT":
		presentable.visible = false
		
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(csv_image.split(",")[0])

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		
		if csv_image.ends_with(".jpg"):
			image.load_jpg_from_buffer(body)
		elif csv_image.ends_with(".webp"):
			image.load_webp_from_buffer(body)
		elif csv_image.ends_with(".png"):
			image.load_png_from_buffer(body)
		elif csv_image.ends_with(".tga"):
			image.load_tga_from_buffer(body)
		elif csv_image.ends_with(".bmp"):
			image.load_bmp_from_buffer(body)
		
		if not image == null:
			var texture = ImageTexture.new()
			texture.set_image(image)
			image_product.texture = texture
			image_big.texture = image_product.texture
			#print("Image successfully loaded and displayed!")
		else:
			print("Image not loaded successfully.")
	else:
		print("Failed to download image. Response code:", response_code)
	
	http_request.queue_free()

func _on_image_mouse_entered():
	image_big.visible = true

func _on_image_mouse_exited():
	image_big.visible = false

func _on_presentable_toggled(button_pressed):
	if button_pressed:
		Global.current_data.push_back(reference_code)
	else:
		Global.current_data.remove_at(Global.current_data.find(reference_code))
