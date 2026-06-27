extends CanvasLayer
## 화면 좌상단 HUD: 소지금과 보유 아이템(달걀/우유/치즈 …)을 한국어로 표시.

@onready var money_label: Label = $Panel/MoneyLabel
@onready var items_label: Label = $Panel/ItemsLabel

func _ready() -> void:
	GameState.money_changed.connect(_on_changed)
	GameState.inventory_changed.connect(_on_inv_changed)
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
