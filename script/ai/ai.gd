
var combate
var campo
var areaMao
var areaMiniatura
var areaZenys
var areaAtaque
var areaDefesa
var jogador
var superJogador

var clock=0
var contador=0

var criarListaAtaqueDefesa=false 
var listaDecidirAtaqueDefesa=[]
var listaCartasCampo=[]
var listaCartasCampoOponente=[]
var listaCartasAtacantes = null
var listaOrdemBloqueio =[]
var listaCartasBloqueio = []
var listaCartasBloqueioCarta = []
var necessidadeDeDefesa = 0
var antiNecessidadeDeDefesa = 0
var tempoPassado = 0

func adicionarInformacoes(jogador,combate):
	definirJogador(jogador)
	self.combate=combate
	self.campo=combate.get_node("controladorCampo")
	

func main(delta,listaInputs,fase):
	if(fase.jogador == superJogador):
		match fase.tipo:
			Constante.FASE_PRINCIPAL1:
				fasePrincipal1(delta,listaInputs)
			Constante.FASE_PRINCIPAL2:
				fasePrincipal2(delta,listaInputs)
	else:
		if(fase.tipo == Constante.FASE_BLOQUEIO):
			faseBloqueio(delta,listaInputs)

func fasePrincipal(delta):
	var retorno = false
	tempoPassado+=delta
	if (tempoPassado > 0.1):
		retorno = calcularCartaJogada(delta)
		tempoPassado = 0
	return retorno
	
func fasePrincipal1(delta,listaInputs):
	
	if(combate.etapaDaFase==0):
		criarListaAtaqueDefesa=true
		listaCartasAtacantes=null
	var retorno = false
	if(fasePrincipal(delta)):
		if criarListaAtaqueDefesa:
			criarListaAtaqueDefesa()
		else:
			if(listaCartasAtacantes == null):
				calcularPosicoesCartasAtaque()
				contador=0
			else:
				retorno = posicionarCartasAtaque(delta)
				
	if retorno:
		var ataque= verificaSeAtaca()
		var input
		if(combate.inputDoUsuario.size()<=0):
			if(ataque):
				input= Classes.InputUsuario.new(superJogador,Constante.INPUT_BTN_AZUL_ATAQUE)
			else:
				input= Classes.InputUsuario.new(superJogador,Constante.INPUT_BTN_VERMELHO)
			combate.adicionarInput(input)
		
		
func fasePrincipal2(delta,listaInputs):
	if(combate.etapaDaFase==0):
		listaCartasAtacantes = null
	if(fasePrincipal(delta)):
		if(combate.inputDoUsuario.size()<=0):
			var input= Classes.InputUsuario.new(superJogador,Constante.INPUT_BTN_VERMELHO)
			combate.adicionarInput(input)

func faseBloqueio(delta,listaInputs):
	if(definirBloqueadores(delta)):
		if(combate.inputDoUsuario.size()<=0):
			var input= Classes.InputUsuario.new(superJogador,Constante.INPUT_BTN_AZUL_BLOQUEIO)
			combate.adicionarInput(input)

func modoSelecao(selecao):
	if(selecao.listaRetorno.size()<selecao.numAlvos):
		var listaAlvosPossiveis=[]
		var oponente=combate.get_oponente(jogador)
		match(selecao.tipoDeSelecao):
			Constante.TIPO_SELECAO_CAMPO:
				listaAlvosPossiveis+=recebeCartasCampo(selecao)
				listaAlvosPossiveis+=campo.get_node("Personagem")
			Constante.TIPO_SELECAO_MONSTRO_CAMPO:
				listaAlvosPossiveis+=recebeCartasCampo(selecao)
			Constante.TIPO_SELECAO_MAO:
				for carta in oponente.listaMao:
					listaAlvosPossiveis.append(carta.obj)
			Constante.TIPO_SELECAO_AREA_FLUTUANTE:
				listaAlvosPossiveis+=selecao.listaCartas

func recebeCartasCampo(selecao):
	pass

func verificaSeAtaca():
	var contAtaque = campo.retornaCartasArea(areaAtaque).size()
	if(contAtaque>0):
		if((listaCartasBloqueio.size()<listaCartasAtacantes.size())or(listaCartasAtacantes.size()==6)):
			return true
		if((necessidadeDeDefesa - antiNecessidadeDeDefesa) < 0 ):
			return true
		if(listaCartasCampoOponente.size()<listaCartasAtacantes.size()):
			return true
		if(listaCartasCampoOponente.size()==0):
			return true
	return false

func debug():
	print("Contador :"+str(contador))
	print("CartasCampo :"+str(listaCartasCampo))
	print("CartasCampoOponente :"+str(listaCartasCampoOponente))
	print("CartasAtacantes :"+str(listaCartasAtacantes))
	print("CartasBloqueio :"+str(listaCartasBloqueio))
	#print(" :"+str())

func definirJogador(jogador):
	
	self.jogador = jogador.jogador
	superJogador=jogador
	jogador.jogador.ai=self
	areaMao = jogador.jogador.areaMao
	areaMiniatura=jogador.jogador.areaMiniatura
	areaZenys=jogador.jogador.areaZenys
	areaAtaque=jogador.jogador.areaAtaque
	areaDefesa=jogador.jogador.areaDefesa




func calcularCartaJogada(delta):
	var zeny = jogador.zeny
	var listaCartasPossiveis= receberCartasPossiveis(zeny)
	var retorno = true
	while((listaCartasPossiveis.size()>0)and(retorno)):
		var contAtaque = 0
		var contDefesa = 0
		contAtaque = campo.retornaCartasArea(areaAtaque).size()
		contDefesa = campo.retornaCartasArea(areaDefesa).size()
		
		if((contAtaque+contDefesa)<12):
			var numero = randi()%listaCartasPossiveis.size()
			var cartaJogar = listaCartasPossiveis[numero]
			if((cartaJogar.temPalavraChave(4))and(contAtaque==6)):
				if(!abrirEspacoArea("ataque")):
					listaCartasPossiveis.remove(listaCartasPossiveis.find(cartaJogar))
				retorno = !jogar(cartaJogar)
			else:
				retorno = !jogar(cartaJogar)
		else:
			listaCartasPossiveis = []
	return retorno
	
func receberCartasPossiveis(zeny):
	var lista = []
	for item in jogador.listaMao:
		if (item.custo <= zeny):
			lista.append(item)
	
	return lista
	
func abrirEspacoArea(areaNome):
	var area
	var areaVazia
	var espacoUm=null
	var espacoDois=null
	var cont =0
	var controlador=campo.get_node("ControladorCartas")
	
	match(areaNome):
		"ataque":
			area=areaAtaque
			areaVazia=areaDefesa
		"defesa":
			area=areaDefesa
			areaVazia=areaAtaque
	espacoUm=controlador.recebeAreaCartaMovel(area)
	espacoDois=controlador.recebeAreaVazia(areaVazia)
	if((espacoUm!=null)and(espacoDois!=null)):
		controlador.positionAreaCarta(espacoDois,espacoUm.carta)
		return true
	else:
		return false
	
func jogar(carta):
	var retorno = false
	var mao = areaMao.mao
	var passa = true
	if((carta.custo <= jogador.zeny)):
		if(carta.tipo == Constante.CARTA_MONSTRO):
			carta.revelada=true
			var controlador = campo.get_node("ControladorCartas")
			var cartaNova = controlador.criarMonstro(carta,jogador)
			
			if(cartaNova != null):
				#controlador.positionAreaCarta(areaRelevante,cartaNova)
				var lista = carta.listaPalavraChave
				for elemento in lista:
					if ((elemento.id == 4)and(carta.retornaPoder()>0)):
						for area in areaAtaque.get_children():
							if (passa and area.is_in_group(Constante.GRUPO_AREA_CARTA)):
								if(area.carta==null):
									passa=false
									controlador.positionAreaCarta(area,cartaNova)
						cartaNova.imovel=true
			
			mao.remove(mao.find(carta))
			areaMao.atualizaMao()
			carta.obj=cartaNova
			jogador.zeny -= carta.custo
			jogador.areaZenys.atualizarZeny()
			for palavra in carta.listaPalavraChave:
				palavra.aoJogar()
			campo.atualizaTodasCartas()
			retorno= true
	else:
		areaMao.atualizaMao()
		retorno= false
	
	return retorno

func criarListaAtaqueDefesa():
	antiNecessidadeDeDefesa = 0
	listaDecidirAtaqueDefesa = []
	listaCartasCampo = campo.retornaCartasArea(areaAtaque)+campo.retornaCartasArea(areaDefesa)
	for item in listaCartasCampo:
		var carta = item.carta
		var ataque = (carta.retornaPoder()*3) + (carta.retornaVidaTotal())
		var defesa = carta.danoRecebido * 2
		antiNecessidadeDeDefesa += carta.retornaPoder()*3  
		for palavra in carta.listaPalavraChave :
			ataque+= palavra.incentivoAtaqueDefesa
		listaDecidirAtaqueDefesa.append(ataque-defesa)
	criarListaAtaqueDefesa = false
	antiNecessidadeDeDefesa += jogador.personagem.danoRecebido * 2
	antiNecessidadeDeDefesa -= jogador.personagem.retornaVidaTotal() 
	defineNecessidadeDeDefesa()

func defineListaCartasCampoOponente():
	var oponenteAreaAtaque = combate.listaJogadores[0].areaAtaque
	var oponenteAreaDefesa = combate.listaJogadores[0].areaDefesa
	listaCartasCampoOponente = campo.retornaCartasArea(oponenteAreaAtaque)+campo.retornaCartasArea(oponenteAreaDefesa)

	
func defineNecessidadeDeDefesa():
	necessidadeDeDefesa = 0
	defineListaCartasCampoOponente()
	for item in listaCartasCampoOponente:
		var carta = item.carta
		necessidadeDeDefesa += (carta.retornaPoder()*3)
		#necessidadeDeDefesa -= carta.danoRecebido * 2
		
	necessidadeDeDefesa+= jogador.personagem.danoRecebido * 5
	necessidadeDeDefesa-= jogador.personagem.retornaVidaTotal() 


func listaXmaiores(x,lista):
	var listaNova = []
	var maior = [null,null]
	var limite = [null,null]
	for posi in x:
		maior = [null,null]
		for i in lista.size():
			var item = lista[i]
			if( (maior[0]==null)or(item>maior[0])):
				if((limite[0]==null)or (item<limite[0])):
					maior=[item,i]
				elif((item==limite[0]) and (i>limite[1])):
					maior=[item,i]
			elif(item==maior[0]):
				if(i<maior[1]):
					if((limite[1]==null)or(i>limite[1])):
						maior=[item,i]
		limite= maior
		listaNova.append(maior[1])
	return listaNova
	
func calcularPosicoesCartasAtaque():
	
	var numAtacantes = calcularNumeroAtacantes()
	var listaAtacantes = listaXmaiores(listaCartasCampo.size(),listaDecidirAtaqueDefesa)
	listaCartasAtacantes = []
	listaCartasBloqueio = []
	var x=0
	for c in listaCartasCampo.size():
		var carta = listaCartasCampo[listaAtacantes[c]]
		
		if(x<numAtacantes):
			if(!carta.carta.temPalavraChave(4)):
				listaCartasAtacantes.append(carta)
				x+=1
		else:
			if(!carta.carta.temPalavraChave(4)):
				listaCartasBloqueio.append(carta)
	
	
func posicionarCartasAtaque(delta):
	var retorno = false
	var posicoesValidas = calcularPosicoesValidas(areaAtaque)
	var posicoesValidasb = calcularPosicoesValidas(areaDefesa)
	var numAtaque = listaCartasAtacantes.size()
	
	if(contador < numAtaque):
		var carta = listaCartasAtacantes[contador]
		if(!carta.posicaoJogo.is_in_group(Constante.GRUPO_AREA_CARTA_ATAQUE)):
			for posicao in posicoesValidas:
				if(posicao.carta==null):
					campo.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
					return false
				elif(listaCartasAtacantes.count(posicao.carta)==0):
					if(!posicao.carta.carta.temPalavraChave(4)):
						campo.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
						return false
		contador +=1
	elif(contador < (numAtaque+listaCartasBloqueio.size())):
		var carta = listaCartasBloqueio[contador-numAtaque]
		var passa = true
		if(!carta.posicaoJogo.is_in_group(Constante.GRUPO_AREA_CARTA_DEFESA)):
			for posicao in posicoesValidasb:
				if(posicao.carta==null):
					campo.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
					return false
				elif(listaCartasBloqueio.count(posicao.carta)==0):
					if(!posicao.carta.carta.temPalavraChave(4)):
						campo.get_node('ControladorCartas').animacaoTrocaDeCartas(posicao,carta)
						return false
		contador +=1
	else:
		retorno = true
		contador = 0
	return retorno


func calcularNumeroAtacantes():
	var fator = necessidadeDeDefesa - antiNecessidadeDeDefesa
	var numAtacantes = 0
	if(fator>0):
		numAtacantes = listaCartasCampo.size() - listaCartasCampoOponente.size()
	elif(listaCartasCampoOponente.size()==0):
		numAtacantes = listaCartasCampo.size()
	else:
		numAtacantes = listaCartasCampo.size() - int(listaCartasCampoOponente.size()/2)
	if(numAtacantes>6):
		numAtacantes =6
	if(numAtacantes<=0):
		if(listaCartasCampoOponente.size()==0):
			numAtacantes = listaCartasCampo.size()
		else:
			numAtacantes=0
		
	return numAtacantes
	
func calcularPosicoesValidas(area):
	var lista = campo.retornaCartasArea(area,false)
	
	return lista
	


func definirBloqueadores(delta):
	if(contador>=6):
		return true
	if(contador==0):
		var listaCartasAtaqueOponente = campo.retornaCartasArea(combate.listaJogadores[0].areaAtaque,false)
		listaCartasBloqueio = campo.retornaCartasArea(areaDefesa,false)
		var tamanhoListaAD=listaDecidirAtaqueDefesa.size()
		var listaValores = listaXmaiores(tamanhoListaAD,listaDecidirAtaqueDefesa)
		listaOrdemBloqueio = defineOrdemAtaqueDefesa(listaCartasAtaqueOponente,listaCartasBloqueio)
		listaCartasBloqueioCarta=[]
		for elemento in listaCartasBloqueio:
			listaCartasBloqueioCarta.append(elemento.carta)
	if(combate.ativado):
		var item = listaOrdemBloqueio[contador]
		if item!=null:
			var cartaBloqueio = listaCartasBloqueioCarta[item]
			
			var areaBloqueio = listaCartasBloqueio[contador]
			
			campo.get_node("ControladorCartas").animacaoTrocaDeCartas(areaBloqueio,cartaBloqueio)
			
		contador+=1
	return (contador>=6)


func copiaListaOrdemForca(listaOld):
	var lista = listaOld.duplicate()
	var listaForca=[]
	var listaNova=[]
	var anterior = 0
	var aux
	for i in lista.size():
		var item = lista[i].carta
		var valor=0
		if(item!=null):
			valor = (item.carta.retornaVida()+(item.carta.retornaPoder()*5)+((item.carta.retornaDefesa()*item.carta.retornaDefesa()*5)+5))
		listaForca.append([valor,lista[i]])
	
	for i in listaForca.size():
		for x in listaForca.size():
			if(listaForca[x][0]<listaForca[i][0]):
				aux=listaForca[x]
				listaForca[x]=listaForca[i]
				listaForca[i]=aux
	for item in listaForca:
		listaNova.append(item[1])
	return listaNova
		
func defineOrdemAtaqueDefesa(listaAtk,listaBloc):
	var retorno = [null,null,null,null,null,null]
	var listaEscolhidos=[]
	#MELHORAR ORDENAÇÂO!
	var copiaListaAtk = copiaListaOrdemForca(listaAtk)
	var primeiro
	var melhor
	var escolhido=false
	for item in copiaListaAtk:
		var i = listaAtk.find(item) # Posicao na lista original
		if(item.carta!= null):
			escolhido=false
			primeiro=null
			melhor=null
			for x in listaBloc.size():
				if((listaBloc[i].carta!=null)and(listaBloc[i].carta.carta.temPalavraChave(4))):
					melhor = i
				elif(listaBloc[x].carta!=null):
					if(!listaBloc[x].carta.carta.temPalavraChave(4)):
						if(listaEscolhidos.find(x)==-1):
							if(primeiro==null):
								primeiro = x
							if(melhor==null):
								melhor=x
							elif(xMelhorQueYContraZ(listaBloc[x].carta,listaBloc[melhor].carta,item.carta)):
								melhor=x
			
			if(melhor!=null):
				retorno[i]=melhor
				listaEscolhidos.append(melhor)
			
	for x in retorno.size():
		if(retorno[x]!=null):
			if(retorno[retorno[x]]==x):
				retorno[x]=null
				
	return retorno

func xMelhorQueYContraZ(x,y,z):
	var retorno
	var pontosX = retornaPontosASobreB(x,z)
	var pontosY = retornaPontosASobreB(y,z)
	var pontosZX= retornaPontosASobreB(z,x)
	var pontosZY= retornaPontosASobreB(z,y)
	
	if((pontosZX>pontosX)and(pontosZY>pontosY)):
		retorno = (pontosX<pontosY)
	else:
		retorno = (pontosX>=pontosY)
	
	return retorno
		 
func retornaPontosASobreB(A,B):
	var pontos = 0
	var BDef=B.carta.retornaVida() + B.carta.retornaDefesa()
	if((A.carta.retornaVida()+A.carta.retornaDefesa())>B.carta.calcularPropriedadeBonus(B.carta.retornaPoder(),A.carta,A.carta.propriedade)):
		pontos += 100
	var ADano=A.carta.calcularPropriedadeBonus(A.carta.retornaPoder(),B.carta,B.carta.propriedade)
	var ADiferenca= Ferramentas.positivo(ADano-BDef)
	pontos-=ADiferenca *5
	if(ADiferenca==0):
		pontos+=120
	
	return pontos

func prepararLista(numSelecao,selecionador,tipoSelecao,obrigatorio=true,jogador=null,listaCartas=[]):
	var lista = recebeListaSelecao(numSelecao,selecionador,tipoSelecao,obrigatorio,jogador,listaCartas)
	var listaSelecionado = lista.duplicate()
	while(listaSelecionado.size()>numSelecao):
		var maior = null
		for x in listaSelecionado.size():
			if((maior==null)or(listaSelecionado[x].retornaVida()>listaSelecionado[maior].retornaVida())):
				maior=x
		listaSelecionado.remove(maior)
	
	var controlador = combate.get_node("ControladorSelecao")
	controlador.novaLista=listaSelecionado
	controlador.enviado=true
	controlador.listaCartas=[]
	controlador.selecionador=selecionador
	controlador.numSelecao = null
	controlador.ativado=true
		
func recebeListaSelecao(numSelecao,selecionador,tipoSelecao,obrigatorio=true,jogador=null,listaCartas=[]):
	var lista =[]
	match tipoSelecao:
		
		Constante.TIPO_SELECAO_MONSTRO_CAMPO:
			for item in combate.retornarTodasAsCartasEmCampo(jogador):
				lista.append(item.carta)
		Constante.TIPO_SELECAO_CAMPO:
			for item in combate.retornarTodasAsCartasEmCampo(jogador):
				lista.append(item.carta)
		Constante.TIPO_SELECAO_MAO:
			if(jogador != combate.jogador):
				lista+= combate.oponente.listaMao
			if(jogador != combate.oponente):
				lista+=combate.jogador.listaMao
		Constante.TIPO_SELECAO_AREA_FLUTUANTE:
			lista=listaCartas
			
	return lista
