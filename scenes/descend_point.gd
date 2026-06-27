extends Node2D
## "더 내려가기" 사다리. 상호작용하면 부모(광산)의 descend()를 호출해 한 층 깊이 내려간다.

@onready var _label: Label = $Label

func _ready() -> void:
	_label.text = "더 내려가기"

func interact() -> void:
	var mine := get_parent()
	if mine and mine.has_method("descend"):
		mine.descend()
