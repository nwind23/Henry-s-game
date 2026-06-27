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

# 곡괭이 등급(1~). 높을수록 한 번에 캐는 광물 수가 늘어난다.
var pickaxe_level: int = 1

signal pickaxe_changed()

# 인트로(토캣몬 이야기)를 봤는지.
var seen_intro: bool = false

# --- 세이브/로드 (브라우저 user:// 에 저장 → 진행 유지) ---
const SAVE_PATH := "user://save.json"
var _dirty := false

func _ready() -> void:
	_load()
	money_changed.connect(func(_a): mark_dirty())
	inventory_changed.connect(func(_a, _b): mark_dirty())
	gems_changed.connect(mark_dirty)
	pickaxe_changed.connect(mark_dirty)
	var t := Timer.new()
	t.wait_time = 2.0
	t.autostart = true
	add_child(t)
	t.timeout.connect(func():
		if _dirty:
			_dirty = false
			_write())

func mark_dirty() -> void:
	_dirty = true

## 처음부터 다시 시작 — 저장을 지우고 모든 상태를 초기화한다.
func reset_game() -> void:
	money = 0
	inventory = {}
	gems = {}
	has_rainbow = false
	mine_depth = 1
	pickaxe_level = 1
	seen_intro = false
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
	_dirty = false
	money_changed.emit(money)
	gems_changed.emit()

func _write() -> void:
	var data := {
		"money": money, "inventory": inventory, "gems": gems,
		"has_rainbow": has_rainbow, "mine_depth": mine_depth,
		"pickaxe_level": pickaxe_level, "seen_intro": seen_intro,
	}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(data))
		f.close()

func _load() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not f:
		return
	var d = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(d) != TYPE_DICTIONARY:
		return
	money = int(d.get("money", 0))
	var inv: Dictionary = d.get("inventory", {})
	inventory = {}
	for k in inv:
		inventory[k] = int(inv[k])
	gems = d.get("gems", {})
	has_rainbow = bool(d.get("has_rainbow", false))
	mine_depth = int(d.get("mine_depth", 1))
	pickaxe_level = int(d.get("pickaxe_level", 1))
	seen_intro = bool(d.get("seen_intro", false))

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
	"wool": 60,        # 양털
	"truffle": 150,    # 송로버섯(돼지)
	"duck_egg": 55,    # 오리알
	"duck_feather": 45, # 오리깃털
	"rabbit_fur": 70,  # 토끼털
	"mayo": 110,       # 마요네즈(달걀 가공)
	"cloth": 160,      # 천(양털 가공)
	"duck_mayo": 120,  # 오리 마요네즈
	"feather_deco": 130, # 깃털 장식품
	"honey": 90,       # 꿀(꽃 가공)
	"stone": 5,    # 돌
	"coal": 15,    # 석탄
	"copper": 25,  # 구리광석
	"iron": 50,    # 철광석
	"gold": 120,   # 금광석
	"magic_ore": 200,  # 마의광석
	"opal": 280,       # 오팔
	"sirius": 400,     # 시리우스광석
	"iridium": 500,    # 이리듐
	"copper_bar": 70,  # 구리주괴(제련)
	"iron_bar": 130,   # 철주괴(제련)
	"gold_bar": 320,   # 금주괴(제련)
	"sirius_bar": 1200,  # 시리우스 주괴
	"hyper_gem": 5000,   # 하이퍼 시리우스메가 보석
	"minnow": 20,    # 송사리(낚시)
	"carp": 50,      # 붕어(낚시)
	"bigfish": 120,  # 큰물고기(낚시)
	"fire_stone": 120,     # 불의 돌(속성)
	"water_stone": 120,    # 물의 돌
	"lightning_stone": 120, # 번개의 돌
	"forest_stone": 120,   # 숲의 돌
	"ice_stone": 140,      # 얼음의 돌
	"dark_stone": 160,     # 어둠의 돌
	"light_stone": 160,    # 빛의 돌
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
	"wool": "양털",
	"truffle": "송로버섯",
	"duck_egg": "오리알",
	"duck_feather": "오리깃털",
	"rabbit_fur": "토끼털",
	"mayo": "마요네즈",
	"cloth": "천",
	"duck_mayo": "오리마요",
	"feather_deco": "깃털장식",
	"honey": "꿀",
	"stone": "돌",
	"coal": "석탄",
	"copper": "구리광석",
	"iron": "철광석",
	"gold": "금광석",
	"magic_ore": "마의광석",
	"opal": "오팔",
	"sirius": "시리우스광석",
	"iridium": "이리듐",
	"copper_bar": "구리주괴",
	"iron_bar": "철주괴",
	"gold_bar": "금주괴",
	"sirius_bar": "시리우스주괴",
	"hyper_gem": "하이퍼시리우스메가보석",
	"minnow": "송사리",
	"carp": "붕어",
	"bigfish": "큰물고기",
	"fire_stone": "불의 돌",
	"water_stone": "물의 돌",
	"lightning_stone": "번개의 돌",
	"forest_stone": "숲의 돌",
	"ice_stone": "얼음의 돌",
	"dark_stone": "어둠의 돌",
	"light_stone": "빛의 돌",
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

## --- 곡괭이(도구) 강화 ---

# 현재 레벨에서 다음 레벨로 올리는 비용. index = 현재 레벨.
var PICKAXE_UPGRADES: Array = [
	{},  # 0 (미사용)
	{"money": 500, "items": {"fire_stone": 2}},                        # 1 -> 2
	{"money": 1500, "items": {"water_stone": 2, "lightning_stone": 2}}, # 2 -> 3
	{"money": 4000, "items": {"forest_stone": 2, "ice_stone": 2}},      # 3 -> 4
	{"money": 10000, "items": {"dark_stone": 3, "light_stone": 3}},     # 4 -> 5
]
const MAX_PICKAXE := 5

func pickaxe_upgrade_cost() -> Dictionary:
	if pickaxe_level >= MAX_PICKAXE:
		return {}
	return PICKAXE_UPGRADES[pickaxe_level]

func can_upgrade_pickaxe() -> bool:
	var c := pickaxe_upgrade_cost()
	if c.is_empty():
		return false
	if money < int(c.money):
		return false
	for it in c.items:
		if get_count(it) < int(c.items[it]):
			return false
	return true

func upgrade_pickaxe() -> bool:
	if not can_upgrade_pickaxe():
		return false
	var c := pickaxe_upgrade_cost()
	add_money(-int(c.money))
	for it in c.items:
		add_item(it, -int(c.items[it]))
	pickaxe_level += 1
	pickaxe_changed.emit()
	return true

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
