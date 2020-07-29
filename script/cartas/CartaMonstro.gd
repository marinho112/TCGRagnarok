extends "res://script/cartas/Carta.gd"

var fundo ="fundo"
var miniatura = false

	
func _ready():
	add_to_group(Constante.GRUPO_CARTA_MONSTRO)	
	
	


func preparaCarta(carta = carta):
	self.carta=carta
	desenhaAtributos()
	desenharPropriedade()
	carregaImagem()
	desenhaPalavrasChave()
	desenharHabilidades()

func desenhaAtributos():
	$nome.set_text(Ferramentas.receberTexto("cartas",carta.nome))
	$lblcusto.set_text(str(carta.custo))
	$lblpoder.set_text(str(carta.poder))
	$lbldefesa.set_text(str(carta.defesa))
	$vida.set_text(str(carta.vida))
	
	desenhaAtributosComplementares()
	
func desenhaAtributosComplementares():
	$raca.set_text(Ferramentas.receberTexto("racas",carta.raca))
	$subRaca.set_text(Ferramentas.receberTexto("subRacas",int(carta.subRaca[0]),Constante.obterSubRaca(carta.subRaca)))


func desenharPropriedade(complemento = ""):
	
	var cor
	var fraco
	var forte
	
	match carta.propriedade:
		
		Constante.PROPRIEDADE_NEUTRO:
			cor="Cinza"
			fraco="Branco"
			forte= null
		Constante.PROPRIEDADE_AGUA:
			cor="Azul"
			fraco="Verde"
			forte="Vermelho"
		Constante.PROPRIEDADE_FANTASMA:
			cor="Branco"
			fraco="Branco"
			forte="Cinza"
		Constante.PROPRIEDADE_FOGO:
			cor="Vermelho"
			fraco="Azul"
			forte="Marrom"
		Constante.PROPRIEDADE_MORTOVIVO:
			cor="Amarelo"
			fraco="Rosa"
			forte="Roxo"
		Constante.PROPRIEDADE_SAGRADO:
			cor="Rosa"
			fraco="Preto"
			forte="Banco"
		Constante.PROPRIEDADE_SOMBRIO:
			cor="Preto"
			fraco="Rosa"
			forte="Amarelo"
		Constante.PROPRIEDADE_TERRA:
			cor="Marrom"
			fraco="Vermelho"
			forte="Verde"
		Constante.PROPRIEDADE_VENENO:
			cor="Roxo"
			fraco=null
			forte="Preto"
		Constante.PROPIREDADE_VENTO:
			cor="Verde"
			fraco="Marrom"
			forte="Azul"
	
	$borda.set_texture(load("res://sprites/cartas/monstros/bordas/"+cor+complemento+".png"))
	var textura = "res://sprites/cartas/monstros/propriedade/"+cor+".png"
	$circuloPropriedade.set_texture(load(textura))
	$circuloPropriedade2.set_texture(load(textura))
	$circuloPropriedade3.set_texture(load(textura))
	$circuloPropriedade4.set_texture(load(textura))
	$circuloPropriedade2.set_visible(carta.nivelPropriedade>1)
	$circuloPropriedade3.set_visible(carta.nivelPropriedade>2)
	$circuloPropriedade4.set_visible(carta.nivelPropriedade>3)
	
	defineFraqueseResistencia(fraco,forte)
	
func defineFraqueseResistencia(fraco,forte):
	$circuloFraqueza.set_visible(fraco!=null)
	if (fraco!=null):
		$circuloFraqueza.set_texture(load("res://sprites/cartas/monstros/propriedade/"+fraco+".png"))
	
	$circuloResistencia.set_visible(forte!=null)
	if (forte!=null):
		$circuloResistencia.set_texture(load("res://sprites/cartas/monstros/propriedade/"+forte+".png"))

func carregaImagem():
	var propriedade
	
	match carta.propriedade:
		
		Constante.PROPRIEDADE_NEUTRO:
			propriedade = "neutro"
		Constante.PROPRIEDADE_AGUA:
			propriedade = "agua"
		Constante.PROPRIEDADE_FANTASMA:
			propriedade = "fantasma"
		Constante.PROPRIEDADE_FOGO:
			propriedade = "fogo"
		Constante.PROPRIEDADE_MORTOVIVO:
			propriedade = "mortoVivo"
		Constante.PROPRIEDADE_SAGRADO:
			propriedade = "sagrado"
		Constante.PROPRIEDADE_SOMBRIO:
			propriedade = "sombrio"
		Constante.PROPRIEDADE_TERRA:
			propriedade = "terra"
		Constante.PROPRIEDADE_VENENO:
			propriedade = "veneno"
		Constante.PROPIREDADE_VENTO:
			propriedade = "vento"

	var imagem = load("res://sprites/cartas/monstros/"+propriedade+"/fundo/"+str(carta.imagem)+".png")
	get_node(fundo).set_texture(imagem)

func desenhaPalavrasChave():
	
	var primeiro = true
	var texto = ""
	var tamanho = 0
	var novaScala=Vector2(1,1)
	var palavrasRepetidas = []
	for palavra in carta.listaPalavraChave:
		var vai = true
		for item in palavrasRepetidas:
			if (item == palavra.id):
				vai=false
		if vai:	
			if primeiro:
				$PalavraChaveObjeto.set_visible(true)
				$PalavraChaveObjeto/texto.bbcode_enabled = true
				primeiro=false
			else:
				texto += ", "
				tamanho+=2
			
			palavrasRepetidas.append(palavra.id)
			var url = '[url=function'+str(palavra.id)+']'
			var nome = palavra.recebeNome()
			url += nome
			tamanho+= nome.length()
			url+='[/url]'
			texto += url
		$PalavraChaveObjeto.atualizaPalavraChave(palavra)
	$PalavraChaveObjeto/texto.bbcode_text= texto
	
	
	var position = $PalavraChaveObjeto.get_position()
		
	tamanho *= 10
	if tamanho < 220:
		novaScala.x = tamanho/220.0
		
		
		
		
	var linhas = int(tamanho/220) +1
	position.y += 25 * (4-linhas) 
	novaScala.y*= (0.25 * linhas) 
		
	$PalavraChaveObjeto.set_position(position)
	$PalavraChaveObjeto/Sprite.set_scale($PalavraChaveObjeto/Sprite.get_scale()*novaScala)
	$PalavraChaveObjeto/Sprite.set_position($PalavraChaveObjeto/Sprite.get_position()*novaScala)
	
func converter(val = null):
	var novo = ControladorCartas.criarCartaMonstro(carta,get_parent(),get_global_position(),miniatura)
	if(val!=null):
		val=novo
	queue_free()

func desenharHabilidades():
	$Habilidade2/borda.set_texture(load("res://sprites/cartas/monstros/bordas/bordaHabilidade2.png"))
	$Habilidade.set_visible(false)
	$Habilidade2.set_visible(false)
	var tamanho = carta.listaHabilidades.size()
	for habilidade in carta.listaHabilidades:
		if (tamanho == 1):
			$Habilidade.set_visible(true)
			var cartaHabilidade
			for item in carta.listaCartasRelacionadas:
				if (item.id == int(habilidade[1])):
					cartaHabilidade = item
			$Habilidade/ScrollContainer/nomeHabilidade.set_text(Ferramentas.receberTexto("cartas",cartaHabilidade.nome))
			var valor = habilidade[2]
			$Habilidade/custoHabilidade.set_text(valor)
		else: 
			$Habilidade2.set_visible(true)
			$Habilidade2/ScrollContainer/nomeHabilidade.set_text(Ferramentas.receberTexto("cartas",int(habilidade[1])))
			var valor = habilidade[2]
			$Habilidade2/custoHabilidade.set_text(valor)
			tamanho = 1
