extends Area2D

var velocity: Vector2 = Vector2.ZERO
var speed: float = 300.0
var damage: int = 5

func _ready():
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta):
	position += velocity * delta

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity

func _on_body_entered(body):
	if body.is_in_group("player"):
		if "vidas" in Dados:
			Dados.vidas -= damage
			print("Vidas: ", Dados.vidas)
			if Dados.vidas <= 0:
				get_tree().quit()
				
		queue_free()
