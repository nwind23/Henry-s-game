extends Node2D
class_name Animal
## 동물 공통: 배회 + 4방향 걷기 스프라이트 + 상호작용 시 생산품(쿨다운).

@export var product: String = "egg"
@export var secondary_product: String = ""
@export var secondary_chance: float = 0.4
@export var cooldown: float = 5.0
@export var wander_radius: float = 48.0
@export var sheet: Texture2D
@export var sprite_scale: float = 1.0

const WANDER_SPEED := 22.0

var _has_product := true
var _timer := 0.0
var _home := Vector2.ZERO
var _target := Vector2.ZERO

@onready var anim: AnimatedSprite2D = $Anim

func _ready() -> void:
	randomize()
	_home = position
	_pick_target()
	if sheet:
		anim.sprite_frames = WalkFrames.build(sheet, 6.0)
		anim.scale = Vector2(sprite_scale, sprite_scale)
		anim.offset = Vector2(0, -14)
		anim.play("down")
		anim.pause()
	queue_redraw()

func _process(delta: float) -> void:
	var prev := position
	position = position.move_toward(_target, WANDER_SPEED * delta)
	_animate(position - prev)
	if position.distance_to(_target) < 2.0:
		_pick_target()
	if not _has_product:
		_timer -= delta
		if _timer <= 0.0:
			_has_product = true
			queue_redraw()

func _animate(v: Vector2) -> void:
	if anim == null or anim.sprite_frames == null:
		return
	if v.length() < 0.02:
		anim.pause()
		return
	var a := WalkFrames.dir_anim(v)
	if anim.animation != a or not anim.is_playing():
		anim.play(a)

func _pick_target() -> void:
	var ang := randf() * TAU
	var dist := randf_range(8.0, wander_radius)
	_target = _home + Vector2(cos(ang), sin(ang)) * dist

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

func _draw() -> void:
	# 생산품 준비 표시(머리 위 노란 점)
	if _has_product:
		var y := -34.0
		draw_circle(Vector2(0, y), 4.0, Color(1, 1, 0.5))
		draw_circle(Vector2(0, y), 4.0, Color(0.6, 0.5, 0.1), false, 1.5)
