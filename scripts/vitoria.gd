extends Area2D

var fase_vencida = false
@onready var area_vitoria := self  # A própria Area2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_area_vitoria_body_entered"))

func _on_area_vitoria_body_entered(body: Node2D):
	if body.is_in_group("player") and not fase_vencida:
		fase_vencida = true
		_celebrar_vitoria()

func _celebrar_vitoria():
	print("Você venceu a fase!")
	get_tree().change_scene_to_file("res://scene/level_2.tscn")  # Caminho para próxima cena
