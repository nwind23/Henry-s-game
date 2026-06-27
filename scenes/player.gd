extends CharacterBody2D
## 토캣몬(주인공). 탑다운 8방향 이동 + 가까운 대상과 상호작용.
## 비주얼은 player.png 스프라이트 시트(정면/뒷면/측면 걷기 3프레임)로 애니메이션.

const SPEED := 110.0

var _interactables: Array[Node] = []

@onready var anim: AnimatedSprite2D = $Anim

func _ready() -> void:
	_build_frames()
	anim.play("down")
	anim.pause()  # 가만히 있을 땐 멈춘 프레임

func _build_frames() -> void:
	var sheet: Texture2D = preload("res://assets/player.png")
	var sf := SpriteFrames.new()
	if sf.has_animation("default"):
		sf.remove_animation("default")
	var rows := {"down": 0, "up": 1, "side": 2}
	for dir_name in rows:
		sf.add_animation(dir_name)
		sf.set_animation_loop(dir_name, true)
		sf.set_animation_speed(dir_name, 7.0)
		for col in 3:
			var at := AtlasTexture.new()
			at.atlas = sheet
			at.region = Rect2(col * 64, int(rows[dir_name]) * 64, 64, 64)
			sf.add_frame(dir_name, at)
	anim.sprite_frames = sf

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * SPEED
	move_and_slide()
	_update_anim(dir)
	# interact 는 폴링으로 처리 → 키보드/패드/터치 버튼 모두 동일하게 동작
	if Input.is_action_just_pressed("interact"):
		var target := _nearest_interactable()
		if target:
			target.call("interact")

func _update_anim(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		anim.pause()
		return
	var a := "down"
	if absf(dir.x) > absf(dir.y):
		a = "side"
		anim.flip_h = dir.x < 0.0  # 측면 기본은 오른쪽 보기 → 왼쪽 이동 시 반전
	elif dir.y < 0.0:
		a = "up"
	else:
		a = "down"
	if anim.animation != a or not anim.is_playing():
		anim.play(a)

func _nearest_interactable() -> Node:
	var best: Node = null
	var best_d := INF
	for n in _interactables:
		if not is_instance_valid(n):
			continue
		var d := global_position.distance_to((n as Node2D).global_position)
		if d < best_d:
			best_d = d
			best = n
	return best

func _on_interact_area_area_entered(area: Area2D) -> void:
	var node := area.get_parent()
	if node and node.has_method("interact") and not _interactables.has(node):
		_interactables.append(node)

func _on_interact_area_area_exited(area: Area2D) -> void:
	var node := area.get_parent()
	_interactables.erase(node)
