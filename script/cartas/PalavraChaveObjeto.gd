extends Node2D

var palavrasChave = []
var preInfo = preload("res://cenas/elementos/infoCarta.tscn")

func _ready():
	pass

func disparaPopUp(palavraChave):
	var pai = get_parent()
	var info = preInfo.instance()
	pai.add_child(info)
	pai.ativado=false
	var posicao = get_position()
	if(posicao.x < 0):
		posicao.x = 0
	if(posicao.x > 150):
		posicao.x = 150
	if(posicao.y < -100):
		posicao.y = -100
	if(posicao.y > 300):
		posicao.y = 300
	info.set_position(posicao)
	
	info.efeito=palavraChave.efeito
		
	var texto = Ferramentas.receberTexto("palavrasChave",palavraChave.id,1)
	if(palavraChave.efeito != null):
		texto +=" " + Ferramentas.receberTexto("efeitos",palavraChave.efeito.id)
	info.setTexto(texto)

func atualizaPalavraChave(palavra):
	palavrasChave.append(palavra)


func _on_texto_meta_clicked(meta):
	
	if(get_parent().zoom):
		for item in palavrasChave:
			if(("function"+str(item.id))==meta):
				disparaPopUp(item)
				return
