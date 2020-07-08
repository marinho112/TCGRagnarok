

func calculaDanoCombate(obj1,obj2,bonus=0):
	var dano = (obj1.dano+bonus) - obj2.defesa
	if(dano<0):
		dano=0
	return dano


func combate(obj1,obj2):
	dano(obj2,calculaDanoCombate(obj1,obj2))
	dano(obj1,calculaDanoCombate(obj2,obj1))


func dano(obj,val):
	obj.dano+=val
