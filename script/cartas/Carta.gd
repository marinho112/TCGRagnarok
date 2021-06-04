extends Node2D

var ativado = true
var zoom = false
var selecionavel = false
var carta
var escondido = false
var posicaoRaiz = Vector2(0,0)
var novaLista = []
var time = 0
var frame = 0
var verificadorTipo=Constante.OBJ_CARTA

func _ready():
	add_to_group(Constante.GRUPO_CARTA)	
	setZoom(false)
	
	
func _process(delta):
	animacaoBrilho(delta)
	
func defineBrilho(val):
	$brilho.set_visible(val)

func animacaoBrilho(delta):
	if($brilho.is_visible()):
		if(time>0.1):
			time=0
			$brilho.set_frame(frame)
			var rot = $brilho.get_rotation_degrees()
			if(rot>=270):
				$brilho.set_rotation_degrees(rot+90)
			else:
				$brilho.set_rotation_degrees(0)
				frame+=1
				if(frame>1):
					frame=0
		else:
			time+=delta


func preparaCarta(carta = self.carta):
	desenhaAtributos()
	
func golpear(carta):
	pass
	
func desenhaAtributos():
	pass

func morre(algoz):	
	get_parent().resolveHabilidades(carta.dono.listaAoMorrer,algoz.dono.listaAoMatar)
	
func verificaVida(algoz):
	print("NÂO IMPLEMENTADO NA CARTA GENERICA")

func exibirCartas():
	var raiz = get_node("/root/main/ControladorDeTurnos/")
	raiz.pausar(3)
	var listaItens = [carta]
	var lista = raiz.get_node("controladorCampo/listaExibicaoCartas")
	listaItens += carta.listaCartasRelacionadas
	lista.definirListaCartas(listaItens)

func transformar(idNovaCarta):
	var combate = get_node("/root/main/ControladorDeTurnos/")
	
	if(ativado):
		var cartaVelha= carta
		var novaCarta =ControlaDados.carregaCartaPorID(idNovaCarta,cartaVelha.dono)
		cartaVelha.migraValor(novaCarta)
		preparaCarta(novaCarta)
		print(cartaVelha.dono.retornaListasEfeito().size())
		for lista in cartaVelha.dono.retornaListasEfeito():
			for efeito in lista:
				if cartaVelha == efeito.pai:
					efeito.listaZonas.push_front(Constante.GRUPO_CARTA_MORTA)
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

func terminar():
	var novaCarta=ControlaDados.carregaCartaPorID(carta.id,carta.dono)
	carta.dono.listaPilhaDescarte.append(novaCarta)
	queue_free()
func aoSairDeJogo(combate):
	var listaDono = carta.listaEfeitoSairJogo+carta.dono.listaAoSairDeJogo
	#if(combate.resolveHabilidades(listaDono,carta.dono.listaAoMorrer)):
	return true
	#return false
