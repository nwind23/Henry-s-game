extends Node2D
## 가공 기계. kind 에 따라 부엌(가공대) 또는 제련소로 동작한다.
## 상호작용하면 ProcessMenu 를 열어 레시피를 고른다. 한 번에 하나씩 가공.

@export var kind: String = "kitchen"  # "kitchen" 또는 "smelter"

const KITCHEN_RECIPES := [
	{"id": "cheese", "inputs": {"milk": 1}, "output": "cheese", "time": 6.0},
	{"id": "pickle", "inputs": {"tomato": 1}, "output": "pickle", "time": 8.0},
	{"id": "jam", "inputs": {"berry": 2}, "output": "jam", "time": 8.0},
	{"id": "mayo", "inputs": {"egg": 1}, "output": "mayo", "time": 6.0},
	{"id": "cloth", "inputs": {"wool": 2}, "output": "cloth", "time": 9.0},
	{"id": "duck_mayo", "inputs": {"duck_egg": 1}, "output": "duck_mayo", "time": 6.0},
	{"id": "feather_deco", "inputs": {"duck_feather": 2}, "output": "feather_deco", "time": 8.0},
	{"id": "honey", "inputs": {"flower": 3}, "output": "honey", "time": 8.0},
]
const SMELTER_RECIPES := [
	{"id": "copper_bar", "inputs": {"copper": 2, "coal": 1}, "output": "copper_bar", "time": 10.0},
	{"id": "iron_bar", "inputs": {"iron": 2, "coal": 1}, "output": "iron_bar", "time": 12.0},
	{"id": "gold_bar", "inputs": {"gold": 2, "coal": 1}, "output": "gold_bar", "time": 14.0},
	{"id": "sirius_bar", "inputs": {"sirius": 20, "coal": 30}, "output": "sirius_bar", "time": 20.0},
	{"id": "hyper_gem", "inputs": {"sirius_bar": 1, "iridium": 10, "coal": 30}, "output": "hyper_gem", "time": 30.0},
]

const KITCHEN_TEX := preload("res://assets/art/buildings/workbench.png")
const SMELTER_TEX := preload("res://assets/art/buildings/smelter.png")

var recipes: Array = []
var _busy := false
var _timer := 0.0
var _time_total := 1.0
var _output := ""

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	recipes = SMELTER_RECIPES if kind == "smelter" else KITCHEN_RECIPES
	sprite.texture = SMELTER_TEX if kind == "smelter" else KITCHEN_TEX
	if has_node("Sign"):
		$Sign.text = display_name()
	queue_redraw()

func display_name() -> String:
	return "제련소" if kind == "smelter" else "가공대"

func _process(delta: float) -> void:
	if _busy:
		_timer -= delta
		queue_redraw()
		if _timer <= 0.0:
			_busy = false
			GameState.add_item(_output, 1)
			if _output == "hyper_gem":
				GameState.toast("🏆 전설의 하이퍼 시리우스메가 보석 완성!")
			else:
				GameState.toast("%s 완성! (보유: %d개)" % [GameState.item_name(_output), GameState.get_count(_output)])
			_output = ""
			queue_redraw()

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
	GameState.toast("%s 가공 시작..." % GameState.item_name(_output))
	return true

func _draw() -> void:
	# 가공 중이면 진행 바를 건물 스프라이트 아래에 표시(가려지지 않게)
	if _busy:
		var bar_y := 46.0 if kind == "smelter" else 32.0
		var p := 1.0 - clampf(_timer / _time_total, 0.0, 1.0)
		draw_rect(Rect2(-22, bar_y - 1, 44, 8), Color(0.05, 0.05, 0.07))     # 테두리
		draw_rect(Rect2(-20, bar_y, 40, 6), Color(0.18, 0.18, 0.2))
		draw_rect(Rect2(-20, bar_y, 40 * p, 6), Color(0.3, 0.85, 0.4))
