extends Node
## 게임 전역 상태(돈 + 인벤토리)를 담는 autoload 싱글톤.
## 어디서나 GameState.add_item(...) / GameState.money 처럼 접근한다.

signal money_changed(amount: int)
signal inventory_changed(item: String, count: int)

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
