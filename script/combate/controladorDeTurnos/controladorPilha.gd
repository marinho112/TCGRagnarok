extends Node2D

var pilha = []

func retornaTopoDaPilha():
	return pilha[0]
	
func removeTopoDaPilha():
	pilha.remove(0)
	
func adicionarTopoDaPilha(item):
	pilha.push_front(item)
	
func adicionarFinalDaPilha(item):
	pilha.append(item)
	
func resolvePilha(delta):
	if(pilha.size()>0):
		if(!pilha[0].executado):
			pilha[0].executa(delta)
			if(pilha[0].executado):
				removeTopoDaPilha()
		else:
			removeTopoDaPilha()
		return false
	else:
		return true
