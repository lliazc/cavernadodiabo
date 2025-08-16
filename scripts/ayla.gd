extends CharacterBody2D

const SPEED = 170.0
const JUMP_FORCE = -320.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
@onready var animation:= $anim as AnimatedSprite2D

func _ready() -> void:
	$comarma.hide()
	$machado.hide()


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction !=0:
		
		velocity.x = direction * SPEED
		animation.scale.x = direction
		if !is_jumping:
			animation.play("andando")
	elif is_jumping:
		animation.play("pulando")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("parada lado") 
		$comarma.frame = 2

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("arma_on"):
		$comarma.show()
		$anim.hide()
		animation = $comarma
	if Input.is_action_just_pressed("arma_off"):
		$comarma.hide()
		$anim.show()
		animation = $anim
	if Input.is_action_just_released("ui_up"):
		Dados.vidas -=20
