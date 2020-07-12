extends Node2D

var carta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func preparaCarta(carta = carta):
	self.carta=carta
	desenhaAtributos()
	desenharPropriedade()
	carregaImagem()

func desenhaAtributos():
	$nome.set_text(Ferramentas.receberTexto("cartas",carta.nome))
	$raca.set_text(Ferramentas.receberTexto("racas",carta.raca))
	$subRaca.set_text(Ferramentas.receberTexto("subRacas",carta.raca,Constante.obterSubRaca(carta.subRaca)))
	
	$lblcusto.set_text(str(carta.custo))
	$lblpoder.set_text(str(carta.poder))
	$lbldefesa.set_text(str(carta.defesa))
	$vida.set_text(str(carta.vida))

func desenharPropriedade():
	
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

	$borda.set_texture(load("res://sprites/cartas/monstros/bordas/"+cor+".png"))
	var textura = "res://sprites/cartas/monstros/propriedade/"+cor+".png"
	$circuloPropriedade.set_texture(load(textura))
	$circuloPropriedade2.set_texture(load(textura))
	$circuloPropriedade3.set_texture(load(textura))
	$circuloPropriedade4.set_texture(load(textura))
	$circuloPropriedade2.set_visible(carta.nivelPropriedade>1)
	$circuloPropriedade3.set_visible(carta.nivelPropriedade>2)
	$circuloPropriedade4.set_visible(carta.nivelPropriedade>3)
	
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
	$fundo.set_texture(imagem)
