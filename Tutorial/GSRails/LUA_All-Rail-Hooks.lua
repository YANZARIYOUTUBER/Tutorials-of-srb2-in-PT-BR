--[[
_______________________________________________________________________________________________________

                              Hooks de Início de Grind
  Esses hooks são executados uma vez, logo ANTES de você começar a grindar, ou logo DEPOIS de começar.
  GS.grinding ou p.powers[pw_carry]==3888 são boas formas de detectar se você está grindando.
_______________________________________________________________________________________________________

-- Executado assim que você se conecta a um trilho durante a colisão inicial, mas ainda não está grindando.
-- Melhor usado para manipular momentum ou ângulo relativo ao trilho.
-- Se retornar true, a colisão com o trilho será ignorada.
SKIN["PreAttach"] = function(p, s, GS, rail)

end

-- Executado no primeiro frame de grind, quando tudo já foi configurado.
-- Use para aplicar habilidades iniciais, efeitos ou cancelar atributos indesejados.
SKIN["StartGrind"] = function(p, s, GS, rail)

end

__________________________________________________________________________

                             Pensamentos Principais
Esses hooks são executados a cada frame. O GrindThinker só executa quando estiver grindando.
   ORDEM = PlayerThink > PreGrindThinker > GrindThinker > FinalThinker
__________________________________________________________________________

-- Executado antes de tudo (exceto PreThinkFrames), independente de estar em trilho ou não.
-- Se retornar true, sobrescreve tudo.
-- Use com cautela e apenas se tiver experiência.
-- Obs: "rail" nem sempre é válido aqui.
SKIN["PlayerThink"] = function(p, s, GS, rail)

end	

-- Executado antes do comportamento de grind iniciar. Aqui, "rail" e "GS" sempre são válidos.
-- Ideal para fazer ajustes rápidos ou editar dados de input e do botão de trilho.
SKIN["PreGrindThinker"] = function(p, s, GS, rail)

end

-- Executado a cada frame SOMENTE enquanto estiver grindando, DEPOIS do comportamento de grind.
-- Bom para habilidades como "impulso no trilho".
-- Se causar problema visual, tente usar FinalThinker.
-- Obs: "rail" nem sempre é válido aqui.
SKIN["GrindThinker"] = function(p, s, GS, rail)

end

-- É como um "PlayerThink", mas executado em PostThinkFrame. Executa mesmo sem estar grindando.
-- Ideal para overlays visuais ou última palavra na lógica.
SKIN["FinalThinker"] = function(p, s, GS)

end 

________________________________________________________________________

                   Hooks executados ao sair de um trilho
________________________________________________________________________

-- Afeta o jogador ANTES de sair do trilho por qualquer método.
-- Se retornar true, sobrescreve totalmente a saída. Use com cautela.
SKIN["PreExit"] = function(p,s,GS, rail, METHOD)

end

-- Executado logo DEPOIS de ser lançado de um trilho, mas antes do PostExit.
-- Útil para modificar a física do lançamento.
-- METHOD pode ser: "sidehop" (pulo lateral), "jump" (pulo manual), ou outro (fim do trilho, dano, etc).
-- SLOPEFLING é o momentum vertical de rampa, se houver.
SKIN["PostFling"] = function(p,s,GS,rail, METHOD, SLOPEFLING)

end

-- Executado por último, depois de sair do trilho.
-- Explicações do PostFling também se aplicam aqui.
SKIN["PostExit"] = function(p, s, GS, rail, METHOD, SLOPEFLING, JUMPRAMP)

end

___________________________________________________________________________

                             Hooks de Animação
                 Influenciam as animações ao grindar
___________________________________________________________________________

-- Executado logo após entrar no estado de "pendurado" durante PlayerThinker.
-- Não é chamado no PostThinkFrame. Use GS.forcesprite e GS.animcall para evitar sobrescrita.
-- Ou use FinalThinker e verifique S_PLAY_RIDE e GS.grinding.
SKIN["CustomHangAnim"] = function(p, s, GS, rail)	

end	

-- Define animações personalizadas, chamado após GrindThinker.
-- Retornar true: força PostThinkFrame e cancela outras animações.
-- Retornar false: vai pro PostThinkFrame, mas deixa as animações padrão antes.
-- ANIMCALL pode ser "sideflip", "flipanim", "force", "forcebutnoskip" ou número.
SKIN["CustomAnim"] = function(p, s, GS, rail, POSTTHINK, ANIMCALL)

end

___________________________________________________________________________

                        Hooks de Habilidades do Jogador
Executados uma vez quando um movimento específico é feito durante o grind
___________________________________________________________________________

-- Executado ao tentar fazer um "Twist Drive" (salto rodado estilo Sonic Heroes).
-- Se retornar true, cancela esse salto padrão.
SKIN["TwistDrive"] = function(p, s, GS, rail)

end

-- Executado antes de pular do trilho.
-- RAMPJUMP pode ser true (rampa estilo SA2) ou "frontiers" (sem resistência no ar).
-- Retornar true: sobrescreve todo comportamento de pulo.
-- "customramp": sobrescreve apenas pulos de rampa SA2.
-- "norampjump": força pulo normal mesmo em rampas.
SKIN["CustomJump"] = function(p, s, GS, rail, RAMPJUMP)

end

-- Executado antes de um pulo lateral do trilho.
-- SIDEJUMP: -1 (esquerda) ou 1 (direita).
-- Retornar true: cancela comportamento padrão.
-- "nostretch": sem efeitos de esticamento.
-- "hanghop": ativa GS.hanghop com valor definido.
SKIN["CustomSideHop"] = function(p, s, GS, rail, SIDEJUMP, RAMPJUMP)

end

-- Executado quando o jogador tenta sair do trilho usando o botão Custom3.
-- Retornar true: sobrescreve o comportamento padrão de sair.
SKIN["CustomDislodge"] = function(p, s, GS,rail)

end

___________________________________________________________________________

                                MISC
                Coisas muito específicas
___________________________________________________________________________

-- Executado quando seu personagem está gerando "speedtrail".
-- Permite personalizar como os rastros de velocidade se comportam.
-- Retornar true: impede criação do speedtrail.
-- Variáveis `nil` usam padrão.
-- É avançado. Veja o LUA_ADVENTURESONIC como exemplo.
SKIN["SpeedTrailVariables"] = function(p, s, GS)

end
]]
