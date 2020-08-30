extends Node2D

var ativado = true
var zoom = false
var selecionavel = false
var carta
var escondido = false
var posicaoRaiz = Vector2(0,0)
var novaLista = []



func _ready():
	add_to_group(Constante.GRUPO_CARTA)	
	setZoom(false)

func preparaCarta(carta = self.carta):
	desenhaAtributos()
	
func golpear(carta):
	pass
	
func desenhaAtributos():
	pass
	
func verificaVida():
	print("NÂO IMPLEMENTADO NA CARTA GENERICA")

func exibirCartas():
	var raiz = get_node("/root/main/Combate/")
	raiz.pausar(3)
	var listaItens = [carta]
	var lista = raiz.get_node("listaExibicaoCartas")
	listaItens += carta.listaCartasRelacionadas
	lista.definirListaCartas(listaItens)

func transformar(idNovaCarta):
	var combate = get_node("/root/main/Combate/")
	
	if(ativado):
		var cartaVelha= carta
		var novaCarta =ControlaDados.carregaCartaPorID(idNovaCarta,cartaVelha.dono)
		cartaVelha.migraValor(novaCarta)
		preparaCarta(novaCarta)
		
		for palavra in carta.listaPalavraChave:
			if(palavra.id!=5):
				palavra.aoJogar()
		
	return true
	
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


func aoSairDeJogo(combate):
	var listaDono = carta.listaEfeitoSairJogo+carta.dono.listaAoSairDeJogo
	if(combate.resolveHabilidades(listaDono,carta.dono.listaAoMorrer)):
		return true
	return false
