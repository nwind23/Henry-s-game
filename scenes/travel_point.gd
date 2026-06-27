extends Node2D
## 여행 표지판. 상호작용하면 여행 메뉴를 연다(어느 지역이든 이동).

@onready var _label: Label = $Label

func _ready() -> void:
	_label.text = "여행"

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("travel_menu")
	if menu:
		menu.call("open")
