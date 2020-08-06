extends Node

func _ready():
	randomize()

func carregaCartaAleatoria():
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/carta.data",File.READ)
	var rand = randi()%100
	var conteudo
	var idTexto
	var passa
	var carta
	var cont = 0
	if not erro:
		while(true):
			if(cont>rand):
				rand = cont-rand
				cont = 0
			idTexto = String(rand-cont)
			arquivo.seek(0)
			while(!arquivo.eof_reached()):
				conteudo = arquivo.get_line()
				if(conteudo.length( ) >2):
					var textLen = idTexto.length()
					if((conteudo[0]!="/")and(conteudo[1]!="/")):
						cont+=1
						if((conteudo[textLen]==",")):
							passa=true
							for letra in textLen:
								if(idTexto[letra] != conteudo[letra]):
									passa=false
									letra = idTexto.length()
							if passa:
								arquivo.close()
								carta = separaStringCarta(conteudo)
								recebePalavrasChave(carta)
								return carta
	
	arquivo.close()
	return -1
	
	
func carregaCartaPorID(id):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/carta.data",File.READ)
	var conteudo
	var idTexto = String(id)
	var passa
	var carta
	
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			if(conteudo.length( ) >2):
				var textLen = idTexto.length()
				if((conteudo[0]!="/")and(conteudo[1]!="/")and(conteudo[textLen]==",")):
					passa=true
					for letra in textLen:
						if(idTexto[letra] != conteudo[letra]):
							passa=false
							letra = idTexto.length()
					if passa:
						arquivo.close()
						carta = separaStringCarta(conteudo)
						recebePalavrasChave(carta)
						return carta
	else:
		print("ERRO!!")
	arquivo.close()
	return -1
	
	
func separaStringCarta(string):
		
	var dividido = string.split(",")
	var carta
	
	match int(dividido[2]):
		
		#Constante.CARTA_PERSONAGEM:
		#	carta = ClassesCartas.personagem.new()
		Constante.CARTA_MONSTRO:
			carta = ClassesCartas.monstro.new()
			completaCartaMonstro(dividido[6],carta)
		Constante.CARTA_ITEM:
			carta = ClassesCartas.item.new()
		Constante.CARTA_HABILIDADE:
			carta = ClassesCartas.habilidade.new()
		Constante.CARTA_EFEITO:
			carta = ClassesCartas.efeito.new()
	
	
	carta.id = int(dividido[0])
	carta.nome= int(dividido[1])
	carta.custo= int(dividido[3])
	carta.edicao= int(dividido[4])
	carta.raridade= int(dividido[5])
	carta.imagem = dividido[7]
	var vector = Vector2(dividido[8],dividido[9])
	carta.posicaoImagem = vector
	carta.descricao = int(dividido[10])
	
	return carta

func carregaPersonagemPorID(id):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/cartaPersonagem.data",File.READ)
	var conteudo
	var idTexto = String(id)
	var passa
	var carta
	
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			if(conteudo.length( ) >2):
				var textLen = idTexto.length()
				if((conteudo[0]!="/")and(conteudo[1]!="/")and(conteudo[textLen]==",")):
					passa=true
					for letra in textLen:
						if(idTexto[letra] != conteudo[letra]):
							passa=false
							letra = idTexto.length()
					if passa:
						arquivo.close()
						carta = separaStringPersonagem(conteudo)
						#recebePalavrasChave(carta)
						return carta
	else:
		print("ERRO!!")
	arquivo.close()
	return -1
	
	
func separaStringPersonagem(string):
		
	var dividido = string.split(",")
	var personagem
	
	personagem = ClassesCartas.personagem.new()
	
	
	
	personagem.id = int(dividido[0])
	personagem.nome= int(dividido[1])
	personagem.vida= int(dividido[2])
	personagem.poder= int(dividido[3])
	personagem.defesa= int(dividido[4])
	personagem.imagem = dividido[5]
	var vector = Vector2(dividido[6],dividido[7])
	personagem.posicaoImagem = vector
	personagem.descricao = int(dividido[8])
	
	
	personagem.custo= 0
	personagem.edicao= 0
	personagem.raridade= 0
	personagem.propriedade = Constante.PROPRIEDADE_NEUTRO
	personagem.nivelPropriedade = 1
	personagem.raca= Constante.RACA_HUMANOIDE
	personagem.subRaca = Constante.SUB_RACA_HUMANO
	
	
	return personagem

func completaCartaMonstro(id,carta):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/cartaMonstro.data",File.READ)
	var conteudo
	var idTexto = id
	var passa
	
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			var textLen = idTexto.length()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")and(conteudo[textLen]==",")):
					passa=true
					for letra in textLen:
						if(idTexto[letra] != conteudo[letra]):
							passa=false
							letra = idTexto.length()
					if passa:
						arquivo.close()
						var dividido = conteudo.split(",")
						carta.propriedade= int(dividido[2])
						carta.nivelPropriedade = int(dividido[3])
						carta.vida= int(dividido[4])
						carta.poder = int(dividido[5])
						carta.defesa= int(dividido[6]) 
						carta.raca=int(dividido[7])
						carta.subRaca= (dividido[8])
						recebeHabilidades(id,carta)
						return true
	else:
		print("ERRO!!")
	arquivo.close()
	return false

func recebePalavrasChave(carta):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/carta_has_palavraChave.data",File.READ)
	var conteudo
	var idTexto = String(carta.id)
	var passa
	var lista = []
	
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			var textLen = idTexto.length()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")and(conteudo[textLen]==",")):
					passa=true
					for letra in textLen:
						if(idTexto[letra] != conteudo[letra]):
							passa=false
							letra = idTexto.length()
						if (passa and (letra == (idTexto.length()-1))):
							var conteudo2 = conteudo.split(",")
							lista.append(PalavrasChave.getPalavraChave(int(conteudo2[1]),int(conteudo2[2]),carta,int(conteudo2[3])))
		arquivo.close()
		carta.listaPalavraChave = lista
					
	else:
		print("ERRO!!")
	arquivo.close()
	return -1

func recebeHabilidades(id,carta):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/monstro_has_Habilidade.data",File.READ)
	var conteudo
	var idTexto = str(id)
	var passa
	var lista = []
	
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			var textLen = idTexto.length()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")and(conteudo[textLen]==",")):
					passa=true
					for letra in textLen:
						if(idTexto[letra] != conteudo[letra]):
							passa=false
							letra = idTexto.length()
						if (passa and (letra == (idTexto.length()-1))):
							var conteudo2 = conteudo.split(",")
							lista.append(conteudo2)
		arquivo.close()
		carta.listaHabilidades = lista
		var listaCartasAdicionar = []
		for item in lista:
			var novo = carregaCartaPorID(int(item[1]))
			novo.revelada = true
			listaCartasAdicionar.append(novo)
		carta.listaCartasRelacionadas += listaCartasAdicionar
	else:
		print("ERRO!!")
	arquivo.close()
	return -1

func recebePalavrasPorEfeito(efeito):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://db/cartas/efeito_has_palavraChave.data",File.READ)
	var conteudo
	var idTexto = String(efeito.id)
	var passa
	var lista = []
	
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			
			conteudo = arquivo.get_line()
			var textLen = idTexto.length()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")and(conteudo[textLen]==",")):
					passa=true
					for letra in idTexto.length():
						if(idTexto[letra] != conteudo[letra]):
							passa=false
							letra = idTexto.length()
						if (passa and (letra == (idTexto.length()-1))):
							var conteudo2 = conteudo.split(",")
							lista.append(PalavrasChave.getPalavraChave(int(conteudo2[1]),int(conteudo2[2]),efeito.pai,int(conteudo2[3])))
		arquivo.close()
		efeito.listaPalavras = lista
					
	else:
		print("ERRO!!")
	arquivo.close()
	return -1
