extends CharacterBody2D

@export var velocidade := 20
@export var gravity = 1900
var direcao := 1
var andando := false

@export var velocidadeTiro = 120
@export var dano = 1
var tiro = preload("res://scripts/bullet.gd")

var idle_atirando = false
var atirando_cima = false 
var pode_atirar = false



func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	_apply_gravidade(delta)
	if andando:
		velocity.x = velocidade * direcao
		move_and_slide()
	_set_animation()
		
func _set_animation():
	if andando:
		$anim.play("andar")
	else:
		$anim.play("idle")

func _apply_gravidade(delta):
	velocity.y += gravity * delta  

func _on_timer_andar_timeout():
	andando = true 

func _on_timer_hit_timeout():
	pass # Replace with function body.
