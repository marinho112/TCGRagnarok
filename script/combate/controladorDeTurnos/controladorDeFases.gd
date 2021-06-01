extends Node2D

var jogadorAtual=0
var faseAtual=0
var rodadaAtual=0
var maiorTurno=0
var incrementoJogador=1
var listaJogadores = []
var inicioDoJogo

func _init():
	inicioDoJogo=Fases.inicioDoJogo.new()

func turnosTotais():
	return 0
	
func passaDeFase():
	faseAtual+=1
	if(faseAtual>=retornaJogador().listaFases.size()):
		faseAtual=0
		jogadorAtual+=incrementoJogador
		if(incrementoJogador>1):
			incrementoJogador=1
		if(jogadorAtual >= listaJogadores.size()):
			jogadorAtual=jogadorAtual-listaJogadores.size()
			rodadaAtual+=1
		retornaJogador().turnoAtual+=1
		if(retornaJogador().turnoAtual>maiorTurno):
			maiorTurno=retornaJogador().turnoAtual
			
func retornarFaseAtual():
	if(inicioDoJogo==null):
		return retornaJogador().listaFases[faseAtual]
	else:
		return inicioDoJogo
	
func selecionarFase(novaFase):
	if(novaFase<retornaJogador().listaFases.size()):
		faseAtual=novaFase
		get_parent().etapaDaFase=0
		
func selecionaJogador(novoJogador):
	if(novoJogador<listaJogadores.size()):
		faseAtual=retornaJogador().listaFases.size()-1
		if(novoJogador>jogadorAtual):
			incrementoJogador=jogadorAtual-novoJogador
		else:
			incrementoJogador=listaJogadores.size()-jogadorAtual+novoJogador
			
func proximoJogador():
	if(jogadorAtual+1<listaJogadores.size()):
		selecionaJogador(jogadorAtual+1)
	else:
		selecionaJogador(0)
	
func definirJogadores(novaListaJogadores):
	listaJogadores=[]
	for jogador in novaListaJogadores :
		var novoJogador= Classes.fasesJogador.new()
		novoJogador.jogador=jogador
		listaJogadores.append(novoJogador)
		if(inicioDoJogo.jogador==null):
			inicioDoJogo.jogador=novoJogador

func retornaJogador():
	return listaJogadores[jogadorAtual]
