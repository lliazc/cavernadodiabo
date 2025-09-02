extends CharacterBody2D

const SPEED = 170.0
const JUMP_FORCE = -320.0
const DANO_MACHADO = 5
const LIMITE_ARMA = 3

var cena_bala: PackedScene = preload("res://scene/bala.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var ArmaMachado := 1
var is_attacking := false
var fase_vencida = false

@onready var animation := $anim as AnimatedSprite2D
@onready var machado := $machado as AnimatedSprite2D
@onready var arma := $comarma as AnimatedSprite2D
@onready var machado_area := $machado/Area2D  # Referência à área de colisão do machado
@onready var area_vitoria := $vitoria  # A área que marca a vitória

func _ready() -> void:
	arma.visible = false
	machado.visible = false
	animation.play("parada lado")
	
	add_to_group("player")
	
	# Conectar o sinal de body_entered da área de vitória corretamente
	if area_vitoria:
		area_vitoria.connect("body_entered", Callable(self, "_on_area_vitoria_body_entered"))
	else:
		print("Área de vitória não encontrada!")
	
	# Conectar o sinal de body_entered da área do machado corretamente
	if machado_area:
		machado_area.connect("body_entered", Callable(self, "_on_machado_body_entered"))
		machado_area.monitoring = false  # Começar desabilitada
	else:
		print("Área do machado não encontrada!")

func _physics_process(delta: float) -> void:
	if is_attacking:
		velocity.x = 0
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		
		var flip = direction == -1
		animation.flip_h = flip
		arma.flip_h = flip
		machado.flip_h = flip
		
		if not is_jumping:
			play_animation("andando")
	else:
		velocity.x = 0
		
		if is_on_floor() and not is_jumping:
			play_idle_animation()

	if is_jumping:
		if animation.visible:
			animation.play("pulando")
		elif arma.visible or machado.visible:
			play_animation("andando", true)

	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("arma_on"):
		ArmaMachado = (ArmaMachado % LIMITE_ARMA) + 1
		verificar_acao()
	
	if Input.is_action_just_pressed("ataque") and not is_attacking:
		if machado.visible:
			ataque_machado()
		elif arma.visible:
			disparo()

func play_animation(anim_name: String, force_frame: bool = false) -> void:
	if arma.visible:
		arma.play(anim_name)
		if force_frame:
			arma.frame = 0
	elif machado.visible:
		machado.play(anim_name)
		if force_frame:
			machado.frame = 0
	elif animation.visible:
		animation.play(anim_name)

func play_idle_animation() -> void:
	if animation.visible:
		animation.play("parada lado")
	elif arma.visible:
		arma.play("andando")
		arma.frame = 2
	elif machado.visible:
		machado.play("andando")
		machado.frame = 2

func ataque_machado():
	is_attacking = true
	machado.play("ataque")  # USANDO A ANIMAÇÃO "ataque"
	print("Ataque com machado iniciado!")
	
	# Habilitar a área de colisão do machado durante o ataque
	if machado_area:
		machado_area.monitoring = true
	
	# Esperar a animação "ataque" terminar
	await machado.animation_finished
	
	# Desabilitar a área de colisão após o ataque
	if machado_area:
		machado_area.monitoring = false
	
	# Voltar para animação de andar
	machado.play("andando")
	is_attacking = false
	print("Ataque com machado finalizado!")

func _on_machado_body_entered(body: Node2D):
	if body.is_in_group("inimigo") and is_attacking:
		print("Machado acertou inimigo: ", body.name)
		
		# Causar dano ao inimigo nos Dados
		if "Dados" in get_tree().root and "fogo_vida" in Dados:
			Dados.fogo_vida -= DANO_MACHADO
			print("DANO COM MACHADO! -5 de vida. Vida do fogo: ", Dados.fogo_vida)

func disparo():
	arma.play("mirando")
	print("Animação mirando iniciada!")
	
	var bala = cena_bala.instantiate()
	var direcao = -1 if arma.flip_h else 1
	
	bala.position = global_position + Vector2(direcao * 42, -23)
	bala.velocidade = Vector2(direcao * 500, 0)
	
	get_parent().add_child(bala)
	print("Bala disparada!")
	
	await get_tree().create_timer(0.3).timeout
	if arma.visible:
		arma.play("andando")

func verificar_acao():
	match ArmaMachado:
		1:
			arma.visible = true
			animation.visible = false
			machado.visible = false
			arma.play("andando")
		2:
			machado.visible = true
			animation.visible = false
			arma.visible = false
			machado.play("andando")  # Começa com animação "andando"
		3:
			arma.visible = false
			machado.visible = false
			animation.visible = true
			animation.play("parada lado")

# Novo sinal para detectar quando o personagem entra na área de vitória
func _on_area_vitoria_body_entered(body: Node2D):
	# Verifica se o personagem entrou na área de vitória
	if body.is_in_group("player"):
		# Marcar a fase como vencida
		fase_vencida = true
		# Chamar a função para realizar a transição de fase
		_celebrar_vitoria()

# Função para mostrar tela de vitória ou outras ações
func _celebrar_vitoria():
	print("Você venceu a fase!")
	get_tree().change_scene("res://scene/level_2.tscn")  # Muda para a próxima fase (ajuste o caminho para o próximo nível)
