extends Animal
## 양 — 양털 생산.

func _draw() -> void:
	# 양털(구름 모양)
	for o in [Vector2(-7, -2), Vector2(7, -2), Vector2(0, -8), Vector2(-4, 4), Vector2(4, 4)]:
		draw_circle(o, 7, Color(0.95, 0.95, 0.92))
	draw_circle(Vector2.ZERO, 9, Color(0.97, 0.97, 0.95))
	# 얼굴
	draw_circle(Vector2(0, 7), 5, Color(0.3, 0.28, 0.3))
	draw_circle(Vector2(-2, 6), 1.0, Color.WHITE)
	draw_circle(Vector2(2, 6), 1.0, Color.WHITE)
	if _has_product:
		draw_circle(Vector2(0, -16), 3.5, Color(0.95, 0.95, 0.92))
