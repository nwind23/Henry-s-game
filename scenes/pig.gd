extends Animal
## 돼지 — 송로버섯 생산.

func _draw() -> void:
	draw_circle(Vector2.ZERO, 11, Color(0.95, 0.65, 0.7))
	# 귀
	draw_colored_polygon(PackedVector2Array([Vector2(-10, -7), Vector2(-5, -14), Vector2(-3, -7)]), Color(0.9, 0.55, 0.62))
	draw_colored_polygon(PackedVector2Array([Vector2(10, -7), Vector2(5, -14), Vector2(3, -7)]), Color(0.9, 0.55, 0.62))
	# 코
	draw_circle(Vector2(0, 4), 4, Color(0.85, 0.5, 0.58))
	draw_circle(Vector2(-1.5, 4), 0.9, Color(0.4, 0.2, 0.25))
	draw_circle(Vector2(1.5, 4), 0.9, Color(0.4, 0.2, 0.25))
	# 눈
	draw_circle(Vector2(-4, -2), 1.2, Color.BLACK)
	draw_circle(Vector2(4, -2), 1.2, Color.BLACK)
	if _has_product:
		draw_circle(Vector2(0, -16), 3.5, Color(0.4, 0.25, 0.2))
