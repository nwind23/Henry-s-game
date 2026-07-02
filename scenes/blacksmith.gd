extends Node2D
## 대장장이. 상호작용하면 도구 강화 메뉴(곡괭이 등급)를 연다.

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("smith_menu")
	if menu:
		menu.call("open")

func _draw() -> void:
	# 대장간 본체(돌벽 + 명암)
	draw_rect(Rect2(-28, -16, 56, 34), Color(0.46, 0.44, 0.47))
	draw_rect(Rect2(-28, 10, 56, 8), Color(0.38, 0.36, 0.4))        # 하단 그림자
	draw_rect(Rect2(-28, -16, 56, 34), Color(0.22, 0.21, 0.24), false, 2.0)
	# 돌벽 벽돌 줄눈
	for y in [-6, 4]:
		draw_line(Vector2(-26, y), Vector2(26, y), Color(0.34, 0.33, 0.36), 1.0)
	for x in [-14, 0, 14]:
		draw_line(Vector2(x, -14), Vector2(x, -6), Color(0.34, 0.33, 0.36), 1.0)
		draw_line(Vector2(x + 7, -6), Vector2(x + 7, 4), Color(0.34, 0.33, 0.36), 1.0)
	# 지붕(2톤) + 굴뚝
	draw_colored_polygon(PackedVector2Array([Vector2(-32, -16), Vector2(32, -16), Vector2(0, -38)]), Color(0.5, 0.28, 0.2))
	draw_colored_polygon(PackedVector2Array([Vector2(-32, -16), Vector2(0, -38), Vector2(0, -30), Vector2(-24, -16)]), Color(0.42, 0.22, 0.16))
	draw_rect(Rect2(12, -34, 8, 12), Color(0.3, 0.29, 0.32))
	draw_circle(Vector2(16, -38), 3, Color(0.75, 0.75, 0.78, 0.6))  # 연기
	draw_circle(Vector2(19, -44), 2.2, Color(0.8, 0.8, 0.82, 0.4))
	# 문(나무)
	draw_rect(Rect2(-8, -4, 16, 22), Color(0.42, 0.3, 0.2))
	draw_rect(Rect2(-8, -4, 16, 22), Color(0.28, 0.2, 0.13), false, 1.5)
	draw_circle(Vector2(4, 8), 1.5, Color(0.8, 0.7, 0.4))           # 손잡이
	# 화로(입구 옆, 달아오른 불)
	draw_rect(Rect2(14, 0, 12, 14), Color(0.3, 0.28, 0.3))
	draw_circle(Vector2(20, 6), 3.6, Color(1.0, 0.5, 0.1))
	draw_circle(Vector2(20, 6), 2.0, Color(1.0, 0.8, 0.3))
	# 모루
	draw_rect(Rect2(-24, 4, 12, 5), Color(0.2, 0.2, 0.22))
	draw_rect(Rect2(-20, 9, 4, 6), Color(0.2, 0.2, 0.22))
