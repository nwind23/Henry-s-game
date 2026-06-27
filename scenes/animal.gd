extends Node2D
class_name Animal
## 동물 공통 로직: 집(시작 위치) 주변 배회 + 상호작용 시 생산품 지급(쿨다운).
## 닭/소 등은 이 스크립트를 extends 하고 _draw()만 각자 그린다.

@export var product: String = "egg"   # 생산 아이템 키
@export var secondary_product: String = ""  # 있으면 가끔 이걸 대신 준다(예: 오리깃털)
@export var secondary_chance: float = 0.4
@export var cooldown: float = 5.0      # 생산 재충전 시간(초)
@export var wander_radius: float = 48.0

const WANDER_SPEED := 24.0

var _has_product := true
var _timer := 0.0
var _home := Vector2.ZERO
var _target := Vector2.ZERO

func _ready() -> void:
	randomize()
	_home = position
	_pick_target()
	queue_redraw()

func _process(delta: float) -> void:
	position = position.move_toward(_target, WANDER_SPEED * delta)
	if position.distance_to(_target) < 2.0:
		_pick_target()
	if not _has_product:
		_timer -= delta
		if _timer <= 0.0:
			_has_product = true
			queue_redraw()

func _pick_target() -> void:
	var ang := randf() * TAU
	var dist := randf_range(8.0, wander_radius)
	_target = _home + Vector2(cos(ang), sin(ang)) * dist

## 플레이어가 호출한다.
func interact() -> void:
	if _has_product:
		_has_product = false
		_timer = cooldown
		var give := product
		if secondary_product != "" and randf() < secondary_chance:
			give = secondary_product
		GameState.add_item(give, 1)
		queue_redraw()
		print("%s을(를) 얻었다! (보유: %d개)" % [GameState.item_name(give), GameState.get_count(give)])
	else:
		print("%s이(가) 아직 준비되지 않았다..." % GameState.item_name(product))
