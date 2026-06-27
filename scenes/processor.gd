extends Node2D
## 가공대 — 여러 레시피를 만들 수 있다. 상호작용하면 가공 메뉴(ProcessMenu)를 연다.
## 한 번에 하나씩 가공하며, 시간이 지나면 결과물이 인벤토리에 들어온다.

# 레시피 목록. inputs = {아이템키: 개수}, output = 결과 아이템, time = 가공 초.
const RECIPES := [
	{"id": "cheese", "inputs": {"milk": 1}, "output": "cheese", "time": 6.0},
	{"id": "pickle", "inputs": {"tomato": 1}, "output": "pickle", "time": 8.0},
	{"id": "jam", "inputs": {"berry": 2}, "output": "jam", "time": 8.0},
]

var _busy := false
var _timer := 0.0
var _time_total := 1.0
var _output := ""

func _process(delta: float) -> void:
	if _busy:
		_timer -= delta
		queue_redraw()
		if _timer <= 0.0:
			_busy = false
			GameState.add_item(_output, 1)
			print("%s 완성! (보유: %d개)" % [GameState.item_name(_output), GameState.get_count(_output)])
			_output = ""
			queue_redraw()

## 플레이어가 호출 → 가공 메뉴를 연다.
func interact() -> void:
	var menu := get_tree().get_first_node_in_group("process_menu")
	if menu:
		menu.call("open", self)

func is_busy() -> bool:
	return _busy

func remaining() -> int:
	return ceili(_timer)

func can_make(recipe: Dictionary) -> bool:
	for item in recipe.inputs:
		if GameState.get_count(item) < recipe.inputs[item]:
			return false
	return true

## 레시피 시작. 성공 시 true.
func start_recipe(recipe: Dictionary) -> bool:
	if _busy or not can_make(recipe):
		return false
	for item in recipe.inputs:
		GameState.add_item(item, -int(recipe.inputs[item]))
	_busy = true
	_time_total = recipe.time
	_timer = recipe.time
	_output = recipe.output
	queue_redraw()
	print("%s 가공 시작..." % GameState.item_name(_output))
	return true

func _draw() -> void:
	# 기계 본체
	draw_rect(Rect2(-20, -16, 40, 32), Color(0.45, 0.45, 0.52))
	draw_rect(Rect2(-20, -16, 40, 32), Color(0.25, 0.25, 0.3), false, 2.0)
	# 가공실(가공 중엔 노랗게)
	draw_rect(Rect2(-12, -8, 24, 16), Color(1.0, 0.9, 0.5) if _busy else Color(0.7, 0.7, 0.78))
	# 진행 바
	if _busy:
		var p := 1.0 - clampf(_timer / _time_total, 0.0, 1.0)
		draw_rect(Rect2(-18, 18, 36, 5), Color(0.2, 0.2, 0.2))
		draw_rect(Rect2(-18, 18, 36 * p, 5), Color(0.3, 0.85, 0.4))
