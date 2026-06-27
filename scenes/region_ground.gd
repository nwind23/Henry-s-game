extends Node2D
## 지역 바닥. 색만 바꿔 여러 지역에 재사용.

@export var ground_color: Color = Color(0.3, 0.5, 0.3)
@export var accent_color: Color = Color(0.28, 0.46, 0.28)

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, 640, 360), ground_color)
	# 가장자리 살짝 어둡게(테두리 느낌)
	draw_rect(Rect2(0, 0, 640, 360), accent_color, false, 10.0)
