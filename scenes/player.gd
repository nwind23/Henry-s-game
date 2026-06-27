extends CharacterBody2D
## 토캣몬(주인공). 탑다운 8방향 이동 + 상호작용. 4방향 걷기 스프라이트.

const SPEED := 110.0

var _interactables: Array[Node] = []

@onready var anim: AnimatedSprite2D = $Anim

func _ready() -> void:
	anim.sprite_frames = WalkFrames.build(preload("res://assets/art/character/tokatmon_walk.png"), 8.0)
	anim.play("down")
	anim.pause()

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = dir * SPEED
	move_and_slide()
	_update_anim(dir)
	if Input.is_action_just_pressed("interact"):
		var target := _nearest_interactable()
		if target:
			target.call("interact")

func _update_anim(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		anim.pause()
		return
	var a := WalkFrames.dir_anim(dir)
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
