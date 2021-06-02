extends Node2D

var animacoes = []
var atualizarAoTermino=false

func retornaAnimacaoAtual():
	return animacoes[0]
	
func removeAnimacaoDoTopo():
	var undead= animacoes[0]
	undead.queue_free()
	animacoes.remove(0)

func adicionarAnimacao(animacao):
	animacoes.append(animacao)

func adicionarAnimacaoSequencia(animacao,posi):
	animacoes.insert(posi,animacao)
	
func executaAnimacoes(delta):
	if(animacoes.size()>0):
		animacoes[0].executa(delta)
		if(animacoes[0].executado):
			removeAnimacaoDoTopo()
		return false
	else:
		return true
