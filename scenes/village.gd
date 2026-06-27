extends Node2D
## 마을 씬의 바닥(잔디)을 그린다. 자식 노드(플레이어/닭/상점)는 그 위에 그려진다.

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	# 잔디 바닥 (뷰포트 전체)
	draw_rect(Rect2(0, 0, 640, 360), Color(0.42, 0.66, 0.36))
	# 상점 앞 흙길 느낌
	draw_rect(Rect2(408, 150, 64, 200), Color(0.62, 0.5, 0.35))
