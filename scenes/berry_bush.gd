extends Node2D
## 산딸기 덤불 — 상호작용으로 채집(쿨다운 뒤 다시 열림). 숲 지역에 배치.

const PRODUCT := "berry"
const COOLDOWN := 6.0

var _has := true
var _t := 0.0

func _ready() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if not _has:
		_t -= delta
		if _t <= 0.0:
			_has = true
			queue_redraw()

func interact() -> void:
	if _has:
		_has = false
		_t = COOLDOWN
		GameState.add_item(PRODUCT, 1)
		if randf() < 0.12:
			GameState.add_item("forest_stone", 1)  # 숲의 돌(속성)
			print("✨ 숲의 돌 발견!")
		queue_redraw()
		print("%s 채집! (보유: %d개)" % [GameState.item_name(PRODUCT), GameState.get_count(PRODUCT)])
	else:
		print("%s가 아직 다시 열리지 않았다..." % GameState.item_name(PRODUCT))

func _draw() -> void:
	# 덤불
	draw_circle(Vector2.ZERO, 11, Color(0.18, 0.45, 0.2))
	draw_circle(Vector2(-5, 2), 7, Color(0.22, 0.52, 0.24))
	draw_circle(Vector2(5, 1), 7, Color(0.22, 0.52, 0.24))
	# 열매
	if _has:
		draw_circle(Vector2(-3, -2), 2.2, Color(0.8, 0.1, 0.3))
		draw_circle(Vector2(4, 1), 2.2, Color(0.8, 0.1, 0.3))
		draw_circle(Vector2(0, 5), 2.2, Color(0.8, 0.1, 0.3))
