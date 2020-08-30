extends Node

#GRUPOS

const GRUPO_MOUSE="grupo_mouse"
const GRUPO_CARTA="grupo_carta"
const GRUPO_CARTA_MONSTRO="grupo_carta_monstro"
const GRUPO_CARTA_REDUZIDA ="grupo_carta_reduzida"
const GRUPO_AREA_CARTA="area_carta"
const GRUPO_AREA_CARTA_ATAQUE="area_carta_ataque"
const GRUPO_AREA_CARTA_DEFESA="area_carta_defesa"
const GRUPO_AREA_MAO="grupo_area_mao"
const GRUPO_AREA_MAO_OPONENTE = "grupo_area_mao_oponente"
const GRUPO_AREA_CAMPO="grupo_area_campo"
const GRUPO_CARTA_EM_CAMPO = "carta_em_campo"
const GRUPO_CARTA_NA_MAO= "carta_na_mao"
const GRUPO_CARTA_NA_MAO_OPONENTE= "carta_na_mao_oponente"
const GRUPO_ANIMACAO = "animacao"

#Constantes de Tipo de Carta

const CARTA_PERSONAGEM=0
const CARTA_MONSTRO=1
const CARTA_ITEM=2
const CARTA_HABILIDADE=3
const CARTA_EFEITO=4

#CONSTANTES DE RACA

const RACA_HUMANOIDE = 0  
const RACA_AMORFO=1
const RACA_BRUTO=2
const RACA_PLANTA=3
const RACA_INSCETO=4
const RACA_PEIXE=5
const RACA_DEMONIO=6
const RACA_ANJO=7
const RACA_DRAGAO=8
const RACA_MORTOVIVO=9

#CONSTANTE SUB-RACA

const SUB_RACA_HUMANO = "00"
const SUB_RACA_ORC = "01"
const SUB_RACA_GOBLIN = "02"
const SUB_RACA_KOBOLD = "03"
const SUB_RACA_ARMADURA = "04"
const SUB_RACA_ROBO = "05"
const SUB_RACA_PORING = "10"
const SUB_RACA_BODE = "20"
const SUB_RACA_AVE = "21"
const SUB_RACA_RAPOSA = "22"
const SUB_RACA_PLANTA_CARNIVORA = "30"
const SUB_RACA_COGUMELO = "31"
const SUB_RACA_CELENTERADO = "32"
const SUB_RACA_DIABINHO = "60"
const SUB_RACA_ZUMBI = "90"
const SUB_RACA_ESQUELETO = "91"
const SUB_RACA_FANTASMA = "92"

func obterSubRaca(texto):
	return int(texto.right(1))
	
#CONSTANTE PROPRIEDADES

const PROPRIEDADE_NEUTRO=0
const PROPRIEDADE_AGUA=1
const PROPRIEDADE_TERRA=2
const PROPRIEDADE_FOGO=3
const PROPRIEDADE_VENTO=4
const PROPRIEDADE_VENENO=5
const PROPRIEDADE_SAGRADO=6
const PROPRIEDADE_SOMBRIO=7
const PROPRIEDADE_FANTASMA=8
const PROPRIEDADE_MORTOVIVO=9

#CONSTANTE SUB_TIPO ITENS

const SUB_TIPO_ITEM_UTILIDADE=0
const SUB_TIPO_ITEM_CHAPEU= 0 
const SUB_TIPO_ITEM_ARMADURA=1
const SUB_TIPO_ITEM_ESCUDO=2
const SUB_TIPO_ITEM_CAPA=3
const SUB_TIPO_ITEM_CALCADOS=4
const SUB_TIPO_ITEM_ACESSORIO=5
const SUB_TIPO_ITEM_ADAGA=10
const SUB_TIPO_ITEM_ESPADA=11
const SUB_TIPO_ITEM_LANCA=12
const SUB_TIPO_ITEM_MACA=13
const SUB_TIPO_ITEM_MACHADO=14
const SUB_TIPO_ITEM_CAJADO=15
const SUB_TIPO_ITEM_ARCO=16
const SUB_TIPO_ITEM_SOQUEIRA=17
const SUB_TIPO_ITEM_INSTRUMENTO=18
const SUB_TIPO_ITEM_CHICOTE=19
const SUB_TIPO_ITEM_LIVRO=20
const SUB_TIPO_ITEM_KATAR=21
const SUB_TIPO_ITEM_SHURIKEN=22
const SUB_TIPO_ITEM_PISTOLA=23
const SUB_TIPO_ITEM_RIFLE=24
const SUB_TIPO_ITEM_METRALHADORA=25
const SUB_TIPO_ITEM_ESCOPETA=26
const SUB_TIPO_ITEM_LANCAGRANADA=27

#Efeitos
const EFEITO_CONTADOR= 9999999
const EFEITO_ATIVADOR_DONO=9999998
const EFEITO_XY=9999997
const EFEITO_ATIVADOR_DANO=9999996
