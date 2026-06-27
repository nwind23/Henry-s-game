extends CharacterBody2D
## 토캣몬(주인공). 탑다운 8방향 이동 + 가까운 대상과 상호작용.
## 비주얼은 임시로 _draw()의 색 도형으로 그린다(나중에 픽셀아트 스프라이트로 교체).

const SPEED := 110.0

# 상호작용 범위(InteractArea) 안에 들어와 있는, interact()를 가진 대상들.
var _interactables: Array[Node] = []

func _ready() -> void:
	queue_redraw()

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * SPEED
	move_and_slide()
	# interact 는 폴링으로 처리 → 키보드/패드/터치 버튼 모두 동일하게 동작
	if Input.is_action_just_pressed("interact"):
		var target := _nearest_interactable()
		if target:
			target.call("interact")

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

func _draw() -> void:
	# 몸 (주황)
	draw_circle(Vector2(0, -2), 10, Color(0.95, 0.55, 0.2))
	# 귀
	draw_colored_polygon(PackedVector2Array([Vector2(-9, -8), Vector2(-5, -20), Vector2(-1, -9)]), Color(0.9, 0.45, 0.15))
	draw_colored_polygon(PackedVector2Array([Vector2(9, -8), Vector2(5, -20), Vector2(1, -9)]), Color(0.9, 0.45, 0.15))
	# 눈
	draw_circle(Vector2(-4, -4), 1.6, Color.BLACK)
	draw_circle(Vector2(4, -4), 1.6, Color.BLACK)
	# 부리(새 느낌)
	draw_colored_polygon(PackedVector2Array([Vector2(-3, 0), Vector2(3, 0), Vector2(0, 5)]), Color(1.0, 0.8, 0.2))
