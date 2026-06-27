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
