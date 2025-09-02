extends CharacterBody2D

@export var speed: float = 100.0
@export var patrol_distance: float = 150.0
@export var wait_time: float = 1.0
@export var bullet_scene: PackedScene = preload("res://scene/bullet.tscn")
@export var fire_rate: float = 1.0
@export var bullet_speed: float = 300.0

var direction: int = 1
var starting_position: Vector2
var distance_traveled: float = 0.0
var is_waiting: bool = false
var can_shoot: bool = true
var fase_vencida = false

@onready var sprite = $anim
@onready var shoot_timer = $ShootTimer
@onready var wait_timer = $WaitTimer
@onready var gun_position = $GunPosition

func _ready():
	starting_position = global_position
	
	shoot_timer.wait_time = 1.0 / fire_rate
	shoot_timer.autostart = true
	shoot_timer.start()
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	
	wait_timer.wait_time = wait_time
	wait_timer.one_shot = true
	wait_timer.timeout.connect(_on_wait_timer_timeout)

func _physics_process(delta):
	if is_waiting:
		velocity.x = 0
		move_and_slide()
		morreu()
		return
	
	# Movimento de patrulha
	velocity.x = speed * direction
	move_and_slide()
	distance_traveled += abs(velocity.x) * delta
	
	if distance_traveled >= patrol_distance:
		turn_around()

func turn_around():
	is_waiting = true
	distance_traveled = 0.0
	direction *= -1

	if sprite:
		sprite.flip_h = direction == 1  # Vira quando for para a direita

	
	if gun_position:
		gun_position.position.x = abs(gun_position.position.x) * direction

	wait_timer.start()

func shoot():
	if not can_shoot or bullet_scene == null:
		return
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = gun_position.global_position
	
	var bullet_direction = Vector2(direction, 0)
	
	if bullet.has_method("set_velocity"):
		bullet.set_velocity(bullet_direction * bullet_speed)
	else:
		bullet.velocity = bullet_direction * bullet_speed
	
	can_shoot = false
	shoot_timer.start()

func _on_shoot_timer_timeout():
	can_shoot = true
	shoot()

func _on_wait_timer_timeout():
	is_waiting = false

func morreu():
	if Dados.fogo_vida <=0:
		print("morreu")
		queue_free()
		
