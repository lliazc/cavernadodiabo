extends Area2D

var velocidade: Vector2 = Vector2(500, 0)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var dano = 50

func _ready() -> void:
	# Conectar o sinal body_entered manualmente
	body_entered.connect(_on_body_entered)
	
	# Destruir após 3 segundos
	await get_tree().create_timer(3).timeout
	queue_free()
	
func _physics_process(delta: float) -> void:
	# Movimento usando a propriedade velocidade
	position += velocidade * delta

func _on_body_entered(body: Node2D) -> void:
	print("Bala colidiu com: ", body.name)
	
	if body.is_in_group("inimigo"):
		# Dano no inimigo fogo
		if Dados.fogo_vida:
			Dados.fogo_vida -= dano
			print("DANO NO INIMIGO! Vida do fogo: ", Dados.fogo_vida)
		queue_free()
	
	elif body.is_in_group("wall") or body.is_in_group("obstacle"):
		queue_free()
