extends Node2D

var ativado = true
var zoom = false
var selecionavel = false
var carta
var escondido = false
var posicaoRaiz = Vector2(0,0)



func _ready():
	add_to_group(Constante.GRUPO_CARTA)	
	setZoom(false)


func exibirCartas():
	var raiz = get_node("/root/main/Combate/")
	raiz.pausar(3)
	var listaItens = [carta]
	var lista = raiz.get_node("listaExibicaoCartas")
	listaItens += carta.listaCartasRelacionadas
	lista.definirListaCartas(listaItens)

	
func setZoom(zoom):
	self.zoom=zoom
	var raiz = get_node("/root/main/Combate/")
	if(zoom): 
		scale = Vector2(1.5,1.5)
		$PalavraChaveObjeto.scale=Vector2(1,1)
		set_z_index(100)
	else:
		set_z_index(0)
		scale = Vector2(0.8,0.8)
		$PalavraChaveObjeto.scale=Vector2(1.2,1.2)
