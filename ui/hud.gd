extends CanvasLayer
## 좌상단 HUD: 소지금 + 보유 아이템(스크롤). 우상단 구석에 숨겨진 초기화 버튼.

const TOAST_MAX := 4          # 동시에 띄우는 최대 개수
const TOAST_HOLD := 1.8       # 유지 시간(초)
const TOAST_FADE := 0.4       # 사라지는 시간(초)

@onready var money_label: Label = $Panel/MoneyLabel
@onready var items_label: Label = $Panel/Scroll/ItemsLabel
@onready var reset_btn: Button = $ResetBtn
@onready var confirm: Control = $Confirm
@onready var yes_btn: Button = $Confirm/Box/Yes
@onready var no_btn: Button = $Confirm/Box/No
@onready var toasts: VBoxContainer = $Toasts

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # 확인창/토스트가 일시정지 중에도 동작
	GameState.money_changed.connect(_on_changed)
	GameState.inventory_changed.connect(_on_inv_changed)
	GameState.toasted.connect(_on_toast)
	reset_btn.pressed.connect(_on_reset)
	yes_btn.pressed.connect(_on_yes)
	no_btn.pressed.connect(_on_no)
	confirm.visible = false
	_refresh()

# --- 토스트 알림 ---
func _on_toast(msg: String) -> void:
	while toasts.get_child_count() >= TOAST_MAX:
		toasts.get_child(0).free()
	var box := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.1, 0.85)
	style.border_color = Color(0.4, 0.4, 0.48, 1)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 10.0
	style.content_margin_right = 10.0
	style.content_margin_top = 3.0
	style.content_margin_bottom = 3.0
	box.add_theme_stylebox_override("panel", style)
	box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var lbl := Label.new()
	lbl.text = msg
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(lbl)
	toasts.add_child(box)
	_expire_toast(box)

func _expire_toast(box: PanelContainer) -> void:
	await get_tree().create_timer(TOAST_HOLD, true).timeout
	if not is_instance_valid(box):
		return
	var tw := create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(box, "modulate:a", 0.0, TOAST_FADE)
	tw.tween_callback(box.queue_free)

func _refresh() -> void:
	money_label.text = "돈: %dG" % GameState.money
	var lines: Array[String] = []
	for item in GameState.SELL_PRICES:
		var c := GameState.get_count(item)
		if c > 0:
			lines.append("%s: %d개" % [GameState.item_name(item), c])
	items_label.text = "\n".join(lines) if not lines.is_empty() else "(가진 것 없음)"

func _on_changed(_v: int) -> void:
	_refresh()

func _on_inv_changed(_i: String, _c: int) -> void:
	_refresh()

# --- 숨겨진 초기화 ---
func _on_reset() -> void:
	confirm.visible = true
	get_tree().paused = true

func _on_no() -> void:
	confirm.visible = false
	get_tree().paused = false

func _on_yes() -> void:
	GameState.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()
