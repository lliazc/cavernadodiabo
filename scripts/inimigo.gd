extends CharacterBody2D

@export var speed: float = 160.0
@export var bullet_scene: PackedScene
@export var shoot_cooldown: float = 1.5

var direction: int = 1
var can_shoot: bool = true

@onready var anim = $anim
@onready var vision_ray = $VisionRay
@onready var edge_ray = $EdgeRay
@onready var muzzle = $Muzzle

func _ready():
	$ShootTimer.wait_time = shoot_cooldown
	update_rays()

func _physics_process(delta):
	update_rays()
	
	if is_player_seen():
		handle_combat()
	else:
		handle_patrol()
	
	move_and_slide()

func update_rays():
	# Configura RayCasts conforme a direção
	vision_ray.target_position.x = 300 * direction
	edge_ray.position.x = 25 * direction
	edge_ray.target_position = Vector2(0, 30)  # Aponta levemente para baixo

func is_player_seen():
	vision_ray.force_raycast_update()
	return (
		vision_ray.is_colliding() and 
		"ayla" in vision_ray.get_collider().name.to_lower()
	)

func handle_combat():
	velocity.x = 0  # Para de se mover
	face_player()
	if can_shoot:
		shoot()

func handle_patrol():
	velocity.x = speed * direction
	anim.play("walk")
	anim.flip_h = (direction < 0)
	
	edge_ray.force_raycast_update()
	if !edge_ray.is_colliding() and is_on_floor():
		flip_direction()

func face_player():
	if vision_ray.is_colliding():
		direction = sign(vision_ray.get_collider().global_position.x - global_position.x)
		anim.flip_h = (direction < 0)

func flip_direction():
	direction *= -1
	anim.flip_h = not anim.flip_h

func shoot():
	if bullet_scene == null: return
	
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.direction = Vector2(direction, 0)
	
	anim.play("shoot")
	can_shoot = false
	$ShootTimer.start()

func _on_shoot_timer_timeout():
	can_shoot = true
	anim.play("idle")
