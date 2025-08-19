extends Area2D

var direcao = 1
var eixo = "X"
@export var velocidade = 800
var dano = 1 

func _ready():
	set_process(true)

func _process(delta): 
	if eixo == "X": 
		global_position.x += velocidade * direcao * delta 
	else:
		global_position.y += velocidade * direcao * delta 

func _on_body_entered(body):
	if body.name == "ayla": 
		body.ayla_damage ()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
