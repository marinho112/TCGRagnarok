extends "res://script/cartas/Carta.gd"


func preparaCartaEspecificoInicio():
	pass
	
func preparaCartaEspecifico():
	desenhaAtributosItem()
	
func carregaImagem():
	var imagem = load("res://sprites/cartas/Itens/"+str(carta.imagem)+".png")
	$fundo.set_texture(imagem)

func desenhaAtributosItem():
	$fundoDescricao/descricao.set_text(carta.recebeDescricao())
	var tipo=Ferramentas.receberTexto("tipoCarta",Constante.CARTA_ITEM)
	var subTipo=Ferramentas.receberTexto("tipoCarta",Constante.CARTA_CONSUMIVEL)
	$tipo.set_text(tipo+" - "+subTipo)
