extends Area2D

var ativado = true
var zoom
var carta
var visual 
var fundo ="fundo"
var miniatura = false
var posicaoRaiz = Vector2(0,0)

# Called when the node enters the scene tree for the first time.

	
func _ready():
	add_to_group(Constante.GRUPO_CARTA)
	setZoom(false)
	


func setZoom(zoom):
	self.zoom=zoom
	if(zoom):
		scale = Vector2(1.5,1.5)
		$PalavraChaveObjeto.scale=Vector2(1,1)
	else:
		if(visual!=null):
			visual.visual=null
			visual.ativado=true
			self.queue_free()
		scale = Vector2(0.8,0.8)
		$PalavraChaveObjeto.scale=Vector2(1.2,1.2)
		
func preparaCarta(carta = carta):
	self.carta=carta
	desenhaAtributos()
	desenharPropriedade()
	carregaImagem()
	desenhaPalavrasChave()

func desenhaAtributos():
	$nome.set_text(Ferramentas.receberTexto("cartas",carta.nome))
	$lblcusto.set_text(str(carta.custo))
	$lblpoder.set_text(str(carta.poder))
	$lbldefesa.set_text(str(carta.defesa))
	$vida.set_text(str(carta.vida))
	
	desenhaAtributosComplementares()
	
func desenhaAtributosComplementares():
	$raca.set_text(Ferramentas.receberTexto("racas",carta.raca))
	$subRaca.set_text(Ferramentas.receberTexto("subRacas",carta.raca,Constante.obterSubRaca(carta.subRaca)))


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
	for palavra in carta.listaPalavraChave:
		
		if primeiro:
			$PalavraChaveObjeto.set_visible(true)
			$PalavraChaveObjeto/texto.bbcode_enabled = true
			primeiro=false
		else:
			texto += ", "
			tamanho+=2
		
		$PalavraChaveObjeto.atualizaPalavraChave(palavra)
		var url = '[url=function'+str(palavra.id)+']'
		var nome = palavra.recebeNome()
		url += nome
		tamanho+= nome.length()
		url+='[/url]'
		texto += url
		
	$PalavraChaveObjeto/texto.bbcode_text= texto
	
	
	var position = $PalavraChaveObjeto.get_position()
		
	tamanho *= 9.3
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
