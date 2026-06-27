extends Node2D
## 연구소(마을 안 건물). 상호작용하면 연구소 메뉴(전설의 보석 진척 + 무지개 엔딩)를 연다.

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("lab_menu")
	if menu:
		menu.call("open")
