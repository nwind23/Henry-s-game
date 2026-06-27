extends Node2D
## 대장장이. 상호작용하면 도구 강화 메뉴(곡괭이 등급)를 연다.

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("smith_menu")
	if menu:
		menu.call("open")

func _draw() -> void:
	# 대장간 본체(돌벽)
	draw_rect(Rect2(-24, -14, 48, 30), Color(0.42, 0.4, 0.42))
	draw_rect(Rect2(-24, -14, 48, 30), Color(0.25, 0.24, 0.26), false, 2.0)
	# 지붕
	draw_colored_polygon(PackedVector2Array([Vector2(-28, -14), Vector2(28, -14), Vector2(0, -34)]), Color(0.3, 0.28, 0.3))
	# 모루
	draw_rect(Rect2(-8, 2, 16, 6), Color(0.2, 0.2, 0.22))
	draw_rect(Rect2(-3, 8, 6, 6), Color(0.2, 0.2, 0.22))
	# 불(화로)
	draw_circle(Vector2(14, 6), 4, Color(1.0, 0.5, 0.1))
