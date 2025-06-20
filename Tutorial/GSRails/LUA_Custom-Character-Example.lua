-- Primeiro, certifique-se de que esta tabela existe, CASO ainda não exista.
if GS_RAILS_SKINS==nil rawset(_G,"GS_RAILS_SKINS",{}) end

-- Em seguida, adicione o nome do seu skin à tabela de skins. No exemplo, vamos criar um Knuckles do vanilla overpower.
GS_RAILS_SKINS["knuckles"] = {}

-- Depois, crie esta variável local SKIN, garantindo que todos os hooks apontem automaticamente para seu personagem.
-- Isso torna a configuração inteira muito menos confusa.
local SKIN = GS_RAILS_SKINS["knuckles"]

-- O mais importante é o hook "S_SKIN". Você pode dar muitos traços especiais ao seu personagem com facilidade aqui.
-- Certifique-se de usar vírgulas e letras maiúsculas corretamente. Lua é MUITO exigente com isso!
-- Não adicione o nome do personagem aqui. Todos os hooks abaixo já apontam para seu personagem por causa da variável local SKIN.
SKIN["S_SKIN"] = {
MAXSPEED = 500, -- Knuckles deixa o Sonic achar que é o mais rápido só por humildade mesmo.

AUTOBALANCE = true, -- O conceito de balanceamento teme Knuckles.
EMERGENCYDROP = false, -- Knuckles É a emergência.
AIRDRAG = 0, -- Resistência do ar? Que conceito IDIOTA...

SIDEHOP = 60, -- Pisque e você perde!
SIDEFLIP = SPR2_SPNG, -- É claro que o Knuckles dá mortal lateral. Ele é estiloso assim.
SIDEHOPARC = 60,
SIDEHOPTIME = 8,

CROUCHBUTTON = BT_SPIN|BT_CUSTOM1|BT_CUSTOM2|BT_CUSTOM3|BT_TOSSFLAG, -- Todo botão é Focus Grind porque sim.
TWISTBUTTON = BT_SPIN, -- Mas apenas SPIN é Twist Drive por... razões.
HEROESTWIST = 70, -- Esse homem GIRA até a vitória além da velocidade do Thok.
ACCELSPEED = 120, -- Nada impede esse homem de acelerar por pura força de vontade.
ACCELCAP = 500, -- Ele pode acelerar até a velocidade máxima ridícula porque sim.

STARTMODIFIER = 50, -- A física quântica multiplica o momentum de Knuckles em 50% ao aterrissar.
STARTSPEEDCONDITION = 1, -- Mesmo 1 unidade de velocidade já ativa a multiplicação sem fim.

FORCESPRITE = SPR2_WAIT, -- Rindo do perigo.
FORCEHANGSPRITE = SPR2_DEAD, -- Knuckles odeia hangrails.
WALLCLINGSPRITE = SPR2_SIGN, -- Isso é um sinal? (Lista de sprites: bit.ly/GSrailsprites) 

NOFUNALLOWED = true, -- Diversão é para perdedores. Knuckles é um chad.
}

--══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
-- Agora que fizemos o S_SKIN, isso já é suficiente para a maioria dos mods. Mas digamos que queremos um comportamento mais específico.
-- Adicionei o que chamo de "rail hooks" — funções chamadas dentro do mod Grind Rails em momentos específicos.
-- Se seu personagem tiver um desses hooks, você pode fazer comportamentos especiais acontecerem nesses intervalos.
-- Os hooks só ficam ativos quando p.mo.GSgrind existe, ou seja, depois que o jogador grindou pela primeira vez.
-- Isso economiza MUITO desempenho.

-- Vamos corrigir um problema comum que a maioria dos mods tem: o followitem não se sincroniza com o personagem. Tipo as calças do Mario, a jumpball do Modern,
-- os chifres ou caudas dos personagens... você entendeu. Para esses casos, adicionei um hook "FinalThinker" que 
-- sempre é executado DEPOIS de TUDO no código do grind. Usar ele te dá a última palavra, independente de tudo.
-- Cada hook fornece informações diferentes, como os hooks normais. Por isso chamo de "rail hook". Neste caso:
-- p = player
-- s = player.mo
-- GS = player.mo.GSgrind
-- Para saber qual info cada hook fornece, veja o arquivo Rail-Hook-Explanations. Por agora, vamos fazer um FinalThinker!
SKIN["FinalThinker"] = function(p, s, GS)
	if GS.grinding -- Sincronizar o objeto seguidor do Knuckles sempre que ele estiver grindando...
	or GS.leftrail -- ...ou acabou de sair de um trilho.
	or GS.JumpRamp -- ...ou está fazendo um truque de rampa SA2
	or GS.failroll -- ...ou está numa posição de falha
	or GS.railswitching -- ...ou está trocando de trilho!
		local THING = p.followmobj -- Esse é nosso objeto seguidor. Código inútil pro Knuckles, mas serve de exemplo.
		if THING and THING.valid
			if (s.frame & FF_VERTICALFLIP) -- Vira quando eu virar!
				THING.frame = $|FF_VERTICALFLIP
			else
				THING.frame = $ & ~FF_VERTICALFLIP
			end
			THING.rollangle = s.rollangle -- Copia meu rollangle!
			THING.mirrored = s.mirrored -- Copia minha propriedade mirrored.
			THING.spritexoffset,THING.spriteyoffset = s.spritexoffset,s.spriteyoffset -- Offsets e escala de sprites, sincroniza!
			THING.spritexscale, THING.spriteyscale = s.spritexscale,s.spriteyscale	
			THING.angle = p.drawangle -- Copia meu drawangle, claro.
			P_MoveOrigin(THING, s.x, s.y, s.z) -- Agora vá até minha posição!
		end
	end
end

-- Você quer desabilitar algo quando começar a grindar? O hook "StartGrind" é ideal, mas
-- o "PreAttach" permite desativar algo até antes da colisão com o trilho. Vamos usá-lo!
SKIN["PreAttach"] = function(p, s, GS, rail)
	if (p.pflags & PF_GLIDING)
		return true -- Retornar true cancela a colisão com o trilho! Nesse caso, Knuckles pode planar ATRAVÉS dos trilhos!
	elseif not (p.powers[pw_extralife])
		P_GivePlayerRings(p, 10) -- Knuckles se revitaliza toda vez que toca um trilho!
		P_GivePlayerLives(p, 1)
		p.powers[pw_extralife] = 99
		P_RestoreMusic(p)
	end
end

-- Outro caso comum: garantir que o personagem recupere habilidades após sair de um trilho.
-- O hook "PostExit" serve exatamente pra isso!
SKIN["PostExit"] = function(p, s, GS, rail, METHOD, SLOPEFLING, JUMPRAMP)
	p.secondjump = 0
	p.powers[pw_sneakers] = 699 -- Knuckles recebe sneakers SEMPRE que sai de um trilho!
	p.powers[pw_invulnerability] = 699 -- Knuckles fica invencível sempre que sai de um trilho!
	P_RestoreMusic(p) -- Com certeza a música constante NUNCA vai irritar.
	p.pflags = $|PF_JUMPDOWN & ~(PF_THOKKED|PF_GLIDING)
end

-- Vamos adicionar um hook que modifica o pulo normal do Knuckles a partir do grindrail. Existe a função "CustomJump", vamos usá-la!
SKIN["CustomJump"] = function(p, s, GS, rail, SIDEJUMP)
	p.pflags = $|PF_JUMPDOWN & ~(PF_GLIDING|PF_THOKKED)
	if GS_RAILS.GrindState(s, "hang") return end
	GS.forcesprite = SPR2_LAND
	if GS.railspeed and (abs(GS.railspeed) < 60*s.scale)
		GS.railspeed = ($*7/6) -- Ganhar um pouco de velocidade nos pulos normais.
	end
end

-- Vamos adicionar um hook que modifica o sidehop do Knuckles. Existe a função "CustomSideHop", então vamos usar!
SKIN["CustomSideHop"] = function(p, s, GS,rail, SIDEJUMP)
	p.pflags = $|PF_JUMPDOWN & ~(PF_GLIDING|PF_THOKKED)
	if GS_RAILS.GrindState(s, "hang") return end
	GS.forcesprite = SPR2_LAND
end

-- Neste ponto, você já entendeu a ideia. Cada hook está descrito no outro arquivo de texto.
-- Como alternativa, veja LUA_ADVENTURESONIC no arquivo L_GSGrindRails.pk3 para ver todos os hooks mais atualizados!
