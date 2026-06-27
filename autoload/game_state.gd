extends Node
## 게임 전역 상태(돈 + 인벤토리)를 담는 autoload 싱글톤.
## 어디서나 GameState.add_item(...) / GameState.money 처럼 접근한다.

signal money_changed(amount: int)
signal inventory_changed(item: String, count: int)
signal gems_changed()

# 7개의 전설의 보석(엔딩 수집품). 각 지역에서 하나씩 획득한다.
var GEMS: Array = [
	{"id": "fire", "name": "불의 보석", "color": Color(0.90, 0.20, 0.20), "where": "화산"},
	{"id": "lightning", "name": "번개의 보석", "color": Color(0.95, 0.55, 0.15), "where": "번개산"},
	{"id": "hope", "name": "희망의 보석", "color": Color(0.95, 0.85, 0.20), "where": "꽃의 들판"},
	{"id": "forest", "name": "숲의 보석", "color": Color(0.20, 0.70, 0.30), "where": "숲"},
	{"id": "water", "name": "물의 보석", "color": Color(0.25, 0.50, 0.90), "where": "광활한 바다"},
	{"id": "faith", "name": "신념의 보석", "color": Color(0.30, 0.30, 0.70), "where": "광산 1000층"},
	{"id": "foresight", "name": "예지의 보석", "color": Color(0.60, 0.30, 0.80), "where": "연구소"},
]

var gems: Dictionary = {}   # id -> true(보유)
var has_rainbow: bool = false

var money: int = 0
var inventory: Dictionary = {}

# 광산에서 현재 내려간 깊이(층). 지역을 오가도 유지된다.
var mine_depth: int = 1

# 임시 판매가 — DECISIONS.md 참고. 가공·다른 동물 추가 시 여기에 채운다.
const SELL_PRICES := {
	"egg": 50,    # 달걀
	"milk": 80,   # 우유
	"cheese": 180, # 치즈(가공품)
	"tomato": 40,  # 토마토(밭 작물)
	"berry": 30,   # 산딸기(숲 채집)
	"pickle": 90,  # 피클(토마토 가공)
	"jam": 80,     # 잼(산딸기 가공)
	"ember": 35,   # 불씨돌(화산 채집)
	"spark": 35,   # 번개돌(번개산 채집)
	"flower": 25,  # 꽃(꽃의 들판 채집)
	"pearl": 60,   # 진주(광활한 바다 채집)
	"stone": 5,    # 돌
	"coal": 15,    # 석탄
	"copper": 25,  # 구리광석
	"iron": 50,    # 철광석
	"gold": 120,   # 금광석
	"copper_bar": 70,  # 구리주괴(제련)
	"iron_bar": 130,   # 철주괴(제련)
	"gold_bar": 320,   # 금주괴(제련)
}

# 화면 표시용 한국어 이름.
const ITEM_NAMES := {
	"egg": "달걀",
	"milk": "우유",
	"cheese": "치즈",
	"tomato": "토마토",
	"berry": "산딸기",
	"pickle": "피클",
	"jam": "잼",
	"ember": "불씨돌",
	"spark": "번개돌",
	"flower": "꽃",
	"pearl": "진주",
	"stone": "돌",
	"coal": "석탄",
	"copper": "구리광석",
	"iron": "철광석",
	"gold": "금광석",
	"copper_bar": "구리주괴",
	"iron_bar": "철주괴",
	"gold_bar": "금주괴",
}

func item_name(item: String) -> String:
	return ITEM_NAMES.get(item, item)

func add_item(item: String, amount: int = 1) -> void:
	inventory[item] = get_count(item) + amount
	inventory_changed.emit(item, inventory[item])

func get_count(item: String) -> int:
	return int(inventory.get(item, 0))

func add_money(amount: int) -> void:
	money += amount
	money_changed.emit(money)

## --- 전설의 보석 ---

func collect_gem(id: String) -> bool:
	if gems.get(id, false):
		return false
	gems[id] = true
	gems_changed.emit()
	return true

func has_gem(id: String) -> bool:
	return gems.get(id, false)

func gem_count() -> int:
	var n := 0
	for g in GEMS:
		if gems.get(g.id, false):
			n += 1
	return n

func has_all_gems() -> bool:
	return gem_count() == GEMS.size()

## 7개를 다 모았을 때 레인보우 보석을 만든다. 성공 시 true.
func make_rainbow() -> bool:
	if has_all_gems() and not has_rainbow:
		has_rainbow = true
		gems_changed.emit()
		return true
	return false

## 해당 아이템을 전부 판매하고, 번 돈을 반환한다.
func sell_all(item: String) -> int:
	var count := get_count(item)
	if count <= 0:
		return 0
	var earned := count * int(SELL_PRICES.get(item, 0))
	inventory[item] = 0
	inventory_changed.emit(item, 0)
	add_money(earned)
	return earned
