extends Node

var vidas: int = 100  # Ou valor inicial desejado
var fogo_vida:int = 50
# Opcional: métodos getter/setter se preferir

func get_vidas() -> int:
	return vidas

func set_vidas(value: int):
	vidas = value
	vidas = max(0, vidas)  # Garante que não fique negativo
