extends Area2D

var ativado = true
var zoom = false
var selecionavel = false
var carta
var pai
var escondido = false
var posicaoRaiz = Vector2(0,0)
var novaLista = []
var timeBrilho = 0
var frame = 0
var verificadorTipo=Constante.OBJ_CARTA

func _ready():
	add_to_group(Constante.GRUPO_CARTA)
	setZoom(false)
	pai=get_node("/root/main/ControladorDeTurnos/")
	
func _process(delta):
	animacaoBrilho(delta)
	
func defineBrilho(val):
	if($brilho!=null):
		$brilho.set_visible(val)

func animacaoBrilho(delta):
	if($brilho!=null):
		if($brilho.is_visible()):
			if(timeBrilho>0.2):
				timeBrilho=0
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
				timeBrilho+=delta

func preparaCartaEspecificoInicio():
	pass
	
func preparaCartaEspecifico():
	pass

func desenhaAtributos():
	
	$nome.set_text(carta.recebeNome())
	if($lblcusto!= null):
		$lblcusto.set_text(str(carta.custo))

func preparaCarta(carta = self.carta):
	self.carta=carta
	preparaCartaEspecificoInicio()
	desenhaAtributos()
	preparaCartaEspecifico()
	
func golpear(carta):
	pass
	

func morre(algoz):
	var listaCarta =carta.listaAoMorrer
	var listaCartaGlobal =carta.dono.listaAoMorrerGlobal
	var listaAlgoz =algoz.listaAoMatar
	var listaAlgozGlobal =algoz.dono.listaAoMatarGlobal
	get_parent().resolveHabilidades([listaCarta,listaCartaGlobal,listaAlgoz,listaAlgozGlobal])
	
func verificaVida(algoz):
	print("NÂO IMPLEMENTADO NA CARTA GENERICA")

func exibirCartas():
	
	pai.pausar(3)
	var listaItens = [carta]
	var lista = pai.get_node("controladorCampo/listaExibicaoCartas")
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
		if($PalavraChaveObjeto!=null):
			$PalavraChaveObjeto.scale=Vector2(1,1)
		set_z_index(100)
	else:
		set_z_index(0)
		scale = Vector2(0.8,0.8)
		if($PalavraChaveObjeto!=null):
			$PalavraChaveObjeto.scale=Vector2(1.2,1.2)

func terminar():
	var novaCarta=ControlaDados.carregaCartaPorID(carta.id,carta.dono)
	carta.dono.listaPilhaDescarte.append(novaCarta)
	queue_free()
	
func aoSairDeJogo(combate):
	return true
