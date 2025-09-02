extends Area2D

var velocity:int = 0
var direction:int = -1
var proximo_fogo:bool= false

func _process(delta: float) -> void:
	if proximo_fogo == true:
		velocity = 100
		position.x += velocity * direction * delta
	if proximo_fogo== false: 
		velocity = 0
	


func _on_body_entered(_body: Node2D) -> void:
	print("pertinho")
	proximo_fogo= true
	
	# Replace with function body.


func _on_body_exited(_body: Node2D) -> void:
	proximo_fogo = false
