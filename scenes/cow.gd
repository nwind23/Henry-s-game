extends Animal
## 소 — 우유를 생산. 닭보다 크고 느리게(쿨다운 김) 설정은 cow.tscn에서.

func _draw() -> void:
	# 몸 (흰색, 큼)
	draw_circle(Vector2.ZERO, 14, Color.WHITE)
	# 갈색 반점
	draw_circle(Vector2(-6, 2), 4, Color(0.55, 0.4, 0.3))
	draw_circle(Vector2(5, -4), 3, Color(0.55, 0.4, 0.3))
	# 귀
	draw_colored_polygon(PackedVector2Array([Vector2(-14, -8), Vector2(-9, -16), Vector2(-7, -9)]), Color(0.9, 0.9, 0.9))
	draw_colored_polygon(PackedVector2Array([Vector2(14, -8), Vector2(9, -16), Vector2(7, -9)]), Color(0.9, 0.9, 0.9))
	# 코(분홍)
	draw_circle(Vector2(0, 8), 4, Color(0.95, 0.7, 0.7))
	# 눈
	draw_circle(Vector2(-4, -2), 1.5, Color.BLACK)
	draw_circle(Vector2(4, -2), 1.5, Color.BLACK)
	# 우유 준비 표시(머리 위 흰 방울)
	if _has_product:
		draw_circle(Vector2(0, -22), 4.0, Color(0.95, 0.95, 1.0))
