extends Node2D
## 지역 바닥. 타일 텍스처가 있으면 반복해 깔고, 없으면 단색.

@export var ground_color: Color = Color(0.3, 0.5, 0.3)
@export var accent_color: Color = Color(0.28, 0.46, 0.28)
@export var ground_texture: Texture2D

func _ready() -> void:
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	queue_redraw()

func _draw() -> void:
	if ground_texture:
		draw_texture_rect(ground_texture, Rect2(0, 0, 640, 360), true)
	else:
		draw_rect(Rect2(0, 0, 640, 360), ground_color)
	draw_rect(Rect2(0, 0, 640, 360), accent_color, false, 10.0)
