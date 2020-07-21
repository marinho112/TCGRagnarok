extends Node2D

#listas

var listaTimes =[]
var listaJogadores =[]


var cursorMouse 


func _ready():
	cursorMouse= get_parent().get_node("Mouse")
	

func retornaListaAreas(jogador,tipo):
	var alvo
	match jogador:
		1:
			match tipo:
				1:
					alvo=$Container/Jogador1Ataque
				2:
					alvo=$Container/Jogador1Defesa
		2:
			match tipo:
				1:
					alvo=$Container/Jogador2Ataque
				2:
					alvo=$Container/Jogador2Defesa
	
	var lista = []
	for item in alvo.get_children():
		if item.is_in_group(Constante.GRUPO_AREA_CARTA):
			lista.append(item)
	
	return lista
