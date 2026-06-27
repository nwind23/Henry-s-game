extends Node2D
## "더 내려가기" 사다리. 상호작용하면 부모(광산)의 descend()를 호출해 한 층 깊이 내려간다.

@onready var _label: Label = $Label

func _ready() -> void:
	_label.text = "더 내려가기"
	queue_redraw()

func interact() -> void:
	var mine := get_parent()
	if mine and mine.has_method("descend"):
		mine.descend()

func _draw() -> void:
	# 사다리/구덩이
	draw_rect(Rect2(-14, -14, 28, 28), Color(0.1, 0.09, 0.12))
	draw_rect(Rect2(-14, -14, 28, 28), Color(0.5, 0.45, 0.3), false, 2.0)
	# 사다리 가로대
	for y in [-8, -2, 4, 10]:
		draw_line(Vector2(-10, y), Vector2(10, y), Color(0.6, 0.5, 0.3), 2.0)
