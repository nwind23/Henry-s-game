extends Node2D
## 상점. 구역 안에서 상호작용하면 가진 달걀을 전부 판매한다.

func interact() -> void:
	var earned := GameState.sell_all("egg")
	if earned > 0:
		print("달걀을 팔아 %dG 획득! (소지금: %dG)" % [earned, GameState.money])
	else:
		print("팔 달걀이 없다.")

func _draw() -> void:
	# 벽
	draw_rect(Rect2(-24, -20, 48, 40), Color(0.78, 0.62, 0.45))
	# 지붕
	draw_colored_polygon(PackedVector2Array([Vector2(-28, -20), Vector2(28, -20), Vector2(0, -40)]), Color(0.7, 0.25, 0.2))
	# 문
	draw_rect(Rect2(-7, 2, 14, 18), Color(0.4, 0.26, 0.15))
