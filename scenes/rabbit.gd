extends Animal
## 토끼 — 토끼털 생산.

func _draw() -> void:
	draw_circle(Vector2.ZERO, 8, Color(0.93, 0.92, 0.95))
	# 귀
	draw_capsule(Vector2(-4, -14), 2.4, 12, Color(0.93, 0.92, 0.95))
	draw_capsule(Vector2(4, -14), 2.4, 12, Color(0.93, 0.92, 0.95))
	# 눈/코
	draw_circle(Vector2(-3, -1), 1.1, Color(0.8, 0.3, 0.3))
	draw_circle(Vector2(3, -1), 1.1, Color(0.8, 0.3, 0.3))
	draw_circle(Vector2(0, 3), 1.2, Color(0.9, 0.5, 0.6))
	if _has_product:
		draw_circle(Vector2(0, -20), 3.2, Color(0.93, 0.92, 0.95))

func draw_capsule(center: Vector2, r: float, h: float, col: Color) -> void:
	draw_circle(center + Vector2(0, -h * 0.5 + r), r, col)
	draw_circle(center + Vector2(0, h * 0.5 - r), r, col)
	draw_rect(Rect2(center.x - r, center.y - h * 0.5 + r, r * 2, h - r * 2), col)
