extends Node2D
## 마을 NPC. 상호작용하면 대화창에 한 마디 한다.

@export var npc_name: String = "이웃"
@export var line: String = "안녕!"
@export var body_color: Color = Color(0.7, 0.5, 0.4)

@onready var _label: Label = $Label

func _ready() -> void:
	_label.text = npc_name
	queue_redraw()

func interact() -> void:
	var d := get_tree().get_first_node_in_group("dialogue")
	if d:
		d.call("show_dialogue", npc_name, line)

func _draw() -> void:
	# 몸
	draw_rect(Rect2(-6, -4, 12, 16), body_color)
	# 머리
	draw_circle(Vector2(0, -10), 7, Color(0.96, 0.82, 0.68))
	# 머리카락
	draw_arc(Vector2(0, -10), 7, PI, TAU, 12, Color(0.35, 0.25, 0.18), 4.0)
	# 눈
	draw_circle(Vector2(-2.5, -10), 1.0, Color.BLACK)
	draw_circle(Vector2(2.5, -10), 1.0, Color.BLACK)
