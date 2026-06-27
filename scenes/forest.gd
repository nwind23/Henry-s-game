extends Node2D
## 숲 지역의 바닥과 장식 나무를 그린다.

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	# 숲 바닥(마을보다 어두운 초록)
	draw_rect(Rect2(0, 0, 640, 360), Color(0.28, 0.5, 0.3))
	# 장식 나무
	for p in [Vector2(110, 90), Vector2(530, 80), Vector2(560, 300), Vector2(90, 300), Vector2(300, 60)]:
		draw_rect(Rect2(p.x - 4, p.y, 8, 22), Color(0.4, 0.28, 0.18))
		draw_circle(p + Vector2(0, -4), 20, Color(0.13, 0.38, 0.17))
		draw_circle(p + Vector2(-10, 2), 13, Color(0.15, 0.42, 0.19))
		draw_circle(p + Vector2(10, 2), 13, Color(0.15, 0.42, 0.19))
