class_name SlideProduct
extends Control

@export var data: ProductData
@onready var obj_price: Label = $price
@onready var obj_name: Label = $name
@onready var http_request = $HTTPRequest

func _ready():
	obj_price.text =  ("%0.2f" % data.price) + "€"
	obj_name.text = data.name
	
	if Global.european:
		obj_price.text = obj_price.text.replace(".", ",")
	
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(data.img_url.split(",")[0])

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var image = Image.new()
		
		if data.img_url.ends_with(".jpg"):
			image.load_jpg_from_buffer(body)
		elif data.img_url.ends_with(".webp"):
			image.load_webp_from_buffer(body)
		elif data.img_url.ends_with(".png"):
			image.load_png_from_buffer(body)
		elif data.img_url.ends_with(".tga"):
			image.load_tga_from_buffer(body)
		elif data.img_url.ends_with(".bmp"):
			image.load_bmp_from_buffer(body)
		
		if not image == null:
			var texture = ImageTexture.new()
			texture.set_image(image)
			$image.texture = texture
			print("Image successfully loaded and displayed!")
		else:
			print("Image not loaded successfully.")
	else:
		print("Failed to download image. Response code:", response_code)

