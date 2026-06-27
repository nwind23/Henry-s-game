extends Node2D
## 지역 이동 표지판. 상호작용하면 target_scene 으로 씬을 바꾼다.
## 인벤토리/돈은 autoload(GameState)라 지역이 바뀌어도 유지된다.

@export_file("*.tscn") var target_scene: String = ""
@export var label: String = "이동"

@onready var _label: Label = $Label

func _ready() -> void:
	_label.text = label
	queue_redraw()

func interact() -> void:
	if not target_scene.is_empty():
		get_tree().change_scene_to_file(target_scene)

func _draw() -> void:
	# 기둥
	draw_rect(Rect2(-3, -2, 6, 22), Color(0.5, 0.35, 0.2))
	# 표지판
	draw_rect(Rect2(-24, -22, 48, 20), Color(0.86, 0.72, 0.42))
	draw_rect(Rect2(-24, -22, 48, 20), Color(0.5, 0.35, 0.2), false, 2.0)
