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
		
	var texto = palavraChave.recebeDescricao()
	var primeiro = true
	for palavra in palavrasChave:
		if(palavra.id == palavraChave.id):
			if(palavra.efeito != null):
				if primeiro:
					texto +=" " + palavra.efeito.recebeDescricao()
					primeiro = false
				else:
					texto+="\n" + palavra.efeito.recebeDescricao()
	info.setTexto(texto)

func atualizaPalavraChave(palavra):
	palavrasChave.append(palavra)


func _on_texto_meta_clicked(meta):
	
	if(get_parent().selecionavel):
		for item in palavrasChave:
			if(("function"+str(item.id))==meta):
				disparaPopUp(item)
				return
