extends Animal
## 닭 — 달걀을 생산. 로직은 Animal 베이스가 담당, 여기선 모양만 그린다.

func _draw() -> void:
	# 몸 (흰색)
	draw_circle(Vector2.ZERO, 9, Color.WHITE)
	# 벼슬
	draw_circle(Vector2(0, -9), 3, Color(0.9, 0.2, 0.2))
	# 부리
	draw_colored_polygon(PackedVector2Array([Vector2(8, -1), Vector2(13, 0), Vector2(8, 2)]), Color(1.0, 0.7, 0.1))
	# 눈
	draw_circle(Vector2(3, -3), 1.2, Color.BLACK)
	# 달걀이 준비되면 머리 위에 표시
	if _has_product:
		draw_circle(Vector2(0, -17), 3.5, Color(1, 1, 0.85))
