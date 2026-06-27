extends Node2D
## 가공대 — 상호작용하면 재료 1개를 넣어 일정 시간 뒤 가공품 1개를 만든다.
## 기본: 우유 → 치즈 (6초).

@export var input_item: String = "milk"
@export var output_item: String = "cheese"
@export var process_time: float = 6.0

var _busy := false
var _timer := 0.0

func _ready() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	if _busy:
		_timer -= delta
		queue_redraw()  # 진행 바 애니메이션
		if _timer <= 0.0:
			_busy = false
			GameState.add_item(output_item, 1)
			queue_redraw()
			print("%s 완성! (보유: %d개)" % [GameState.item_name(output_item), GameState.get_count(output_item)])

## 플레이어가 호출한다.
func interact() -> void:
	if _busy:
		print("가공 중... (%d초 남음)" % ceili(_timer))
		return
	if GameState.get_count(input_item) <= 0:
		print("%s이(가) 없다." % GameState.item_name(input_item))
		return
	GameState.add_item(input_item, -1)
	_busy = true
	_timer = process_time
	queue_redraw()
	print("%s → %s 가공 시작..." % [GameState.item_name(input_item), GameState.item_name(output_item)])

func _draw() -> void:
	# 기계 본체
	draw_rect(Rect2(-20, -16, 40, 32), Color(0.45, 0.45, 0.52))
	draw_rect(Rect2(-20, -16, 40, 32), Color(0.25, 0.25, 0.3), false, 2.0)
	# 통(가공실)
	draw_rect(Rect2(-12, -8, 24, 16), Color(0.7, 0.7, 0.78) if not _busy else Color(1.0, 0.9, 0.5))
	# 진행 바
	if _busy:
		var p := 1.0 - clampf(_timer / process_time, 0.0, 1.0)
		draw_rect(Rect2(-18, 18, 36, 5), Color(0.2, 0.2, 0.2))
		draw_rect(Rect2(-18, 18, 36 * p, 5), Color(0.3, 0.85, 0.4))
