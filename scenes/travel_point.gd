extends Node2D
## 여행 표지판. 상호작용하면 여행 메뉴를 연다(어느 지역이든 이동).

@onready var _label: Label = $Label

func _ready() -> void:
	_label.text = "여행"
	queue_redraw()

func interact() -> void:
	var menu := get_tree().get_first_node_in_group("travel_menu")
	if menu:
		menu.call("open")

func _draw() -> void:
	draw_rect(Rect2(-3, -2, 6, 22), Color(0.5, 0.35, 0.2))
	draw_rect(Rect2(-22, -22, 44, 20), Color(0.55, 0.78, 0.95))
	draw_rect(Rect2(-22, -22, 44, 20), Color(0.3, 0.45, 0.6), false, 2.0)
