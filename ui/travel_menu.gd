extends CanvasLayer
## 여행 메뉴. 표지판(travel_point)이 open() 으로 연다. 현재 지역을 빼고
## 갈 수 있는 지역 목록을 보여주고, 고르면 씬을 전환한다.

const REGIONS := [
	{"name": "마을", "scene": "res://scenes/village.tscn"},
	{"name": "숲", "scene": "res://scenes/forest.tscn"},
	{"name": "목장", "scene": "res://scenes/ranch.tscn"},
	{"name": "광산", "scene": "res://scenes/mine.tscn"},
	{"name": "화산", "scene": "res://scenes/volcano.tscn"},
	{"name": "번개산", "scene": "res://scenes/thunder.tscn"},
	{"name": "꽃의 들판", "scene": "res://scenes/flower_field.tscn"},
	{"name": "광활한 바다", "scene": "res://scenes/sea.tscn"},
	{"name": "강", "scene": "res://scenes/river.tscn"},
]

@onready var rows: VBoxContainer = $Panel/Scroll/Rows
@onready var close_button: Button = $Panel/Close

func _ready() -> void:
	add_to_group("travel_menu")
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	close_button.pressed.connect(close)

func open() -> void:
	visible = true
	get_tree().paused = true
	_rebuild()

func close() -> void:
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		close()
		get_viewport().set_input_as_handled()

func _rebuild() -> void:
	for c in rows.get_children():
		c.queue_free()
	var here := ""
	if get_tree().current_scene:
		here = get_tree().current_scene.scene_file_path
	for region in REGIONS:
		if region.scene == here:
			continue
		var btn := Button.new()
		btn.text = region.name
		btn.pressed.connect(_go.bind(region.scene))
		rows.add_child(btn)

func _go(scene_path: String) -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)
