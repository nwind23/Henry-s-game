extends Node2D
## 상점. 상호작용하면 판매 창(ShopMenu)을 연다.

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("shop_menu")
	if menu:
		menu.call("open")
	else:
		# 안전장치: 메뉴가 없으면 달걀만 즉시 판매
		var earned := GameState.sell_all("egg")
		print("달걀 판매 → +%dG" % earned)

func _draw() -> void:
	# 벽
	draw_rect(Rect2(-24, -20, 48, 40), Color(0.78, 0.62, 0.45))
	# 지붕
	draw_colored_polygon(PackedVector2Array([Vector2(-28, -20), Vector2(28, -20), Vector2(0, -40)]), Color(0.7, 0.25, 0.2))
	# 문
	draw_rect(Rect2(-7, 2, 14, 18), Color(0.4, 0.26, 0.15))
