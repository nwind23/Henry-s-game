extends CanvasLayer
## 화면 좌상단 HUD: 소지금과 달걀 수를 한국어로 표시.

@onready var money_label: Label = $Panel/MoneyLabel
@onready var egg_label: Label = $Panel/EggLabel

func _ready() -> void:
	GameState.money_changed.connect(_on_money_changed)
	GameState.inventory_changed.connect(_on_inventory_changed)
	_refresh()

func _refresh() -> void:
	money_label.text = "돈: %dG" % GameState.money
	egg_label.text = "달걀: %d개" % GameState.get_count("egg")

func _on_money_changed(_amount: int) -> void:
	_refresh()

func _on_inventory_changed(_item: String, _count: int) -> void:
	_refresh()
