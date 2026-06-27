extends Animal
## 오리 — 오리알(가끔 오리깃털) 생산.

func _draw() -> void:
	draw_circle(Vector2.ZERO, 9, Color(0.97, 0.9, 0.4))
	# 머리
	draw_circle(Vector2(6, -7), 5, Color(0.97, 0.9, 0.4))
	# 부리
	draw_colored_polygon(PackedVector2Array([Vector2(10, -8), Vector2(16, -6), Vector2(10, -4)]), Color(1.0, 0.6, 0.1))
	# 눈
	draw_circle(Vector2(7, -8), 1.1, Color.BLACK)
	if _has_product:
		draw_circle(Vector2(-2, -15), 3.2, Color(1, 1, 0.9))
