extends CanvasLayer
## 좌상단 HUD: 소지금 + 보유 아이템(스크롤). 우상단 구석에 숨겨진 초기화 버튼.

@onready var money_label: Label = $Panel/MoneyLabel
@onready var items_label: Label = $Panel/Scroll/ItemsLabel
@onready var reset_btn: Button = $ResetBtn
@onready var confirm: Control = $Confirm
@onready var yes_btn: Button = $Confirm/Box/Yes
@onready var no_btn: Button = $Confirm/Box/No

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS  # 확인창이 일시정지 중에도 동작
	GameState.money_changed.connect(_on_changed)
	GameState.inventory_changed.connect(_on_inv_changed)
	reset_btn.pressed.connect(_on_reset)
	yes_btn.pressed.connect(_on_yes)
	no_btn.pressed.connect(_on_no)
	confirm.visible = false
	_refresh()

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
