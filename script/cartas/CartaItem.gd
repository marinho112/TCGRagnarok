extends "res://script/cartas/Carta.gd"


func preparaCartaEspecificoInicio():
	pass
	
func preparaCartaEspecifico():
	pass
	
func carregaImagem():
	var imagem = load("res://sprites/cartas/Itens/"+str(carta.imagem)+".png")
	$fundo.set_texture(imagem)

func desenhaAtributosMonstro():
	pass
