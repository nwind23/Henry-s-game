extends Node2D
## 연구소(마을 안 건물). 상호작용하면 연구소 메뉴(전설의 보석 진척 + 무지개 엔딩)를 연다.

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("lab_menu")
	if menu:
		menu.call("open")

func _draw() -> void:
	# 본체(흰 연구소)
	draw_rect(Rect2(-26, -12, 52, 28), Color(0.86, 0.89, 0.93))
	draw_rect(Rect2(-26, -12, 52, 28), Color(0.5, 0.55, 0.6), false, 2.0)
	# 돔 지붕
	draw_circle(Vector2(0, -12), 20, Color(0.72, 0.8, 0.88))
	# 문
	draw_rect(Rect2(-7, 2, 14, 14), Color(0.3, 0.4, 0.5))
	# 창(빛나는 장치 느낌)
	draw_circle(Vector2(-15, -1), 3, Color(0.5, 0.9, 1.0))
	draw_circle(Vector2(15, -1), 3, Color(0.5, 0.9, 1.0))
