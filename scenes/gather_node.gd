extends Node2D
## 범용 채집물(덤불/광맥/꽃 등). 상호작용으로 자원 1개 획득, 쿨다운 후 다시.
## 지역마다 product/색만 바꿔 재사용한다.

@export var product: String = "ember"
@export var cooldown: float = 6.0
@export var body_color: Color = Color(0.5, 0.25, 0.15)
@export var fruit_color: Color = Color(1.0, 0.5, 0.15)
@export var rare_drop: String = ""      # 가끔 추가로 주는 속성의 돌
@export var rare_chance: float = 0.12

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
		_t = cooldown
		GameState.add_item(product, 1)
		if rare_drop != "" and randf() < rare_chance:
			GameState.add_item(rare_drop, 1)
			print("✨ %s 발견!" % GameState.item_name(rare_drop))
		queue_redraw()
		print("%s 획득! (보유: %d개)" % [GameState.item_name(product), GameState.get_count(product)])
	else:
		print("%s이(가) 아직 다시 생기지 않았다..." % GameState.item_name(product))

func _draw() -> void:
	draw_circle(Vector2.ZERO, 11, body_color)
	draw_circle(Vector2(-5, 2), 7, body_color.lightened(0.12))
	draw_circle(Vector2(5, 1), 7, body_color.lightened(0.12))
	if _has:
		draw_circle(Vector2(-3, -2), 2.4, fruit_color)
		draw_circle(Vector2(4, 1), 2.4, fruit_color)
		draw_circle(Vector2(0, 5), 2.4, fruit_color)
