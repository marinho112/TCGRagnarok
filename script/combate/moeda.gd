extends Node2D

var imagemColorida = preload("res://sprites/zeny.png")
var imagemCinza = preload("res://sprites/zenyCinza.png")
var gasta = false

func _ready():
	pass # Replace with function body.

func definirGasta(gasta):
	self.gasta=gasta
	exibirImagem()
	
func exibirImagem():
	if gasta:
		$imagem.set_texture(imagemCinza)
	else:
		$imagem.set_texture(imagemColorida)
