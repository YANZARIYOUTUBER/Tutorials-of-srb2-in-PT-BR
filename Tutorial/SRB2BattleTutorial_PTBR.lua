/* Olá, CobaltBW aqui.
Este é um script de ação tutorial que ensinará como criar os movimentos especiais de um personagem para usar com o BattleMod.
Para ajudar a explicar o processo, adicionarei vários comentários detalhando como tudo funciona e o que precisamos fazer para que nosso script funcione corretamente.

Uma visão geral rápida do que você precisará:
variável local no nível superior
Um gancho ThinkFrame
Verificação "se CBW_Battle"
Uma função para seu script de ação, armazenada local ou globalmente
Um personagem que usará a função, definido por meio de CBW_Battle.SkinVars[<yourskinname>]

Você também pode habilitar 'battledebug 10' no console, pois está testando as habilidades do seu personagem.
Isso exibirá variáveis relacionadas à batalha e à ação em tempo real para ajudá-lo a solucionar quaisquer problemas que possa encontrar ao longo do caminho.

Vamos começar! */

-- Primeiro, é importante que acompanhemos se o BattleMod foi carregado para que possamos dizer ao jogo quando criar nossa função.
-- Para fazer isso, vamos começar criando uma variável local.
local ScriptLoaded = false

-- Agora vamos colocar o resto do nosso código dentro do ThinkFrame...
addHook("ThinkFrame", function()
    -- ... para que possamos verificar cada quadro para ver se o script já foi carregado.
    if not(ScriptLoaded)
        and CBW_Battle -- CBW_Battle é a tabela mestra para todas as funções do BattleMod. Tentar executar nossos scripts sem o Battle carregado resultará em um erro lua, então temos que verificar antes de tentar executar o resto do código.
        then
        ScriptLoaded = true -- Inverta isso para true para que não tentemos executar esse código mais de uma vez.
        local B = CBW_Battle -- Apenas por conveniência, vamos encurtar esta tabela; isso tornará a escrita das funções um pouco menos complicada.

        -- Agora vamos criar nossa ação.
        local RingBarrage = function(mo, doaction)
            /* Notas sobre funções de ação
            As funções de ação seguem o formato de (mo, doaction).
            mo é o objeto do jogador que está executando a ação.
            doaction é o estado em que o jogador está tentando executar uma ação ou não, dependendo das entradas de teclas atuais.
            0 = nenhum botão pressionado
            1 = o botão foi pressionado e a ação pode ser executada
            2 = o botão está sendo pressionado e a ação pode ser executada
            -1 = o jogador está tentando executar uma ação, mas não consegue devido a uma das seguintes condições:
                - O jogador está saindo do nível
                - A ação do jogador está em cooldown
                - O personagem do jogador está com dor
                - Os controles do jogador foram desativados
                - O jogador "não é o IT" no modo tag
                - O jogador tem a bandeira em CTF ou o cristal em Diamond in the Rough
            */
            local player = mo.player

            -- Agora, para algumas definições:
            player.actiontext    = "Ring Barrage"  -- Este é o texto do HUD que aparece ao lado do ícone do anel vermelho.
            player.actionrings   = 10              -- Esta é a quantidade de anéis que sua ação custa e também será exibida no HUD se definida acima de 0.
            player.action2text   = nil             -- Se definido, será exibido abaixo da primeira string, ao lado do ícone de bandeira.
            player.action2rings  = 0               -- Valor exibido ao lado de action2text, se aplicável. Não usado por padrão, mas ainda disponível no HUD.
            -- Observe que essas variáveis são redefinidas em cada quadro para nil ou 0.

            if not (B.CanDoAction(player)) -- CBW_Battle.CanDoAction retornará true/false se as ações forem permitidas com base em certas condições externas.
                -- Observe que essa função não é tão abrangente quanto as condições verificadas por doaction, então você ainda precisará verificar doaction para garantir que a ação do jogador não esteja, por exemplo, em cooldown, antes de gastar anéis.
                player.actionstate = 0 -- Estado de ação padrão
                return
            end

            -- Vamos definir o comportamento para o estado neutro da ação
            if player.actionstate == 0 -- actionstate pode ser usado para determinar a fase do ataque de um personagem.
                -- Neste caso, verificamos 0 porque é o estado "neutro". (Sempre que o estado de ação for maior que 0, o texto do HUD será destacado em amarelo.)
                -- Neste ponto, vamos ver se o jogador está apertando o botão de ação
                if doaction == 1 -- A tecla de ação foi pressionada e podemos executar
                    player.actionstate = 1 -- Isso nos leva ao próximo estado de ação
                    player.actiontime  = 0 -- Isso pode ser usado para acompanhar o tempo em um determinado estado. Ao contrário do que o nome sugere, essa variável NÃO incrementa nem decrementa automaticamente, então você precisará ajustar manualmente se quiser usá-la como temporizador.
                    B.PayRings(player)   -- Gasta a quantidade de anéis e reproduz o efeito sonoro anti-anel.
                    S_StartSound(mo, sfx_s3k3c)
                end
            end

            if player.actionstate == 1 -- Este estado servirá como nosso atraso de inicialização
                player.actiontime = $ + 1 -- Incrementa este valor para acompanhar quanto tempo estamos neste estado.

                -- Interrompe nosso impulso
                P_InstaThrust(mo, mo.angle, 0)
                P_SetObjectMomZ(mo, P_MobjFlip(mo) * mo.scale, 0)
                -- Fazemos girar
                player.pflags = ($ | PF_SPINNING) & ~PF_JUMPED
                mo.state = S_PLAY_ROLL
                P_SpawnThokMobj(player) -- Apenas um pouco de estética

                if player.actiontime == 20 then -- Define o tempo até o próximo estado
                    player.actionstate = 2
                    player.actiontime  = 0
                end
            end

            if player.actionstate == 2 -- Neste estado, nosso personagem está executando sua ação.
                player.actiontime = $ + 1
                -- Criando nosso fluxo de projéteis
                if player.actiontime % 3 == 0 -- Essa condição será verdadeira a cada quatro tics
                    P_SPMAngle(mo, MT_REDRING, mo.angle, 0)
                end

                -- Aplicar um pouco de recuo
                P_SetObjectMomZ(mo, P_MobjFlip(mo) * mo.scale * 2, 0)
                P_InstaThrust(mo, mo.angle + ANGLE_180, mo.scale * 6)
                B.ApplyCooldown(player, TICRATE * 2) -- Tempo de espera antes que o jogador possa usar essa ação novamente. Se usado sem anéis, o tempo de espera é duplicado.
                mo.state = S_PLAY_FALL
                player.pflags  = $ & ~PF_SPINNING
                player.drawangle = mo.angle

                -- Redefinir estado do jogador
                if player.actiontime == 20 then
                    player.actionstate = 0
                end
            end

        end -- Fim da função de ação.

        -- Vamos supor que queremos que nosso personagem seja mais resistente a ataques enquanto seu movimento estiver em uso.
        local PriorityFunc = function(player)
            if player.actionstate == 1 then
                B.SetPriority(player, 1, 3, nil, 1, 3, "midair charge spin")
                /* Argumentos
                    1: Propriedades do jogador a modificar
                    2: Prioridade de ataque. Prioridades mais altas perfuram defesas inimigas mais fortes.
                    3: Prioridade de defesa. Prioridades mais altas resistem a ataques inimigos.
                    4: Condição de prioridade "especial". Se retornar verdadeiro, usa os argumentos 5 e 6 para determinar prioridades neste quadro.
                       Funções devem ser registradas via CBW_Battle.AddPriorityFunction(nomeString, função)
                       O argumento #4 deve referir-se ao nomeString fornecido. Não use a função diretamente como argumento.
                    5: Ataque especial, se a condição #4 retornar verdadeiro.
                    6: Defesa especial, se a condição #4 retornar verdadeiro.
                    7: Texto de ataque para exibir no console quando um oponente levar dano em colisão player-to-player
                       (ex: "O giro de carga no ar de Sonic atingiu Knuckles")
                */
                -- Neste caso, o jogador terá prioridade de ataque 1 e defesa 3 enquanto actionstate for 1.
            end
        end

        -- Funções de exaustão podem limitar a duração de certas ações que causariam desequilíbrio em Battle, sem alterar a experiência a menos que o Battle esteja carregado.
        -- Neste exemplo, vamos limitar a carga de spindash do Sonic a 5 segundos.
        -- O Battle cuidará do sfx de exaustão e do piscar de cor, então basta decrementar player.exhaustmeter de FRACUNIT a 0.
        --    ~Krabs
        local ExhaustFunc = function(player)
            if player.pflags & PF_STARTDASH then
                local maxtime = 5 * TICRATE
                player.exhaustmeter = max(0, $ - FRACUNIT / maxtime)
                if player.exhaustmeter <= 0 then
                    player.pflags   = $ & ~(PF_STARTDASH | PF_SPINNING)
                    player.mo.state = S_PLAY_STND
                end
                return true -- Retornar true impede que o medidor de exaustão seja recarregado ao tocar no chão.
            end
            return false
        end

        -- Funções de colisão permitem comportamentos especiais em colisões de jogadores.
        -- Para este exemplo, faremos com que o estado de rolamento do Sonic reproduza um efeito sonoro e ignore a física de colisão padrão se ele colidir com um inimigo sem causar dano.
        -- O código de colisão não é fácil de trabalhar, mas outro exemplo pode ser visto no script de Fang (Lua\3-Functions\3-Player\Special Moves\Lib_ActCombatRoll.lua).
        -- Esse script também demonstra utilidade de precollide e postcollide.
        --    ~Krabs
        local CollideFunc = function(n1, n2, plr, mo, atk, def, weight, hurt, pain, ground, angle, thrust, thrust2, collisiontype)
            -- Há muitos argumentos aqui, desculpe...
            -- n1: número de id do jogador 1
            -- n2: número de id do jogador 2
            -- plr: armazena jogadores em plr[n1] e plr[n2]
            -- mo: armazena mobjs em mo[n1] e mo[n2]
            -- atk: armazena atk em atk[n1] e atk[n2]
            -- def: armazena def em def[n1] e def[n2]
            -- weight: armazena weight em weight[n1] e weight[n2]
            -- hurt: indica quem foi ferido pela colisão
            --   0: ninguém foi ferido
            --   1: o jogador t foi ferido pelo jogador s
            --  -1: o jogador s foi ferido pelo jogador t
            --   2: ambos foram feridos
            -- pain: armazena booleanos em pain[n1] e pain[n2] se estiverem em dor
            -- ground: armazena booleanos em ground[n1] e ground[n2] se estiverem no chão sólido
            -- angle: armazena o ângulo de colisão em angle[n1] e angle[n2]
            -- thrust: armazena impulso de colisão em thrust[n1] e thrust[n2]
            -- thrust2: armazena thrust2 de colisão em thrust2[n1] e thrust2[n2]
            -- collisiontype: armazena o tipo de colisão
            --   0 = Sem interação
            --   1 = Bate
            --   3 = Código de dano total

            if not (plr[n1] and plr[n1].valid and plr[n1].playerstate == PST_LIVE)
               or not mo[n1].health
               or mo[n1].state ~= S_PLAY_ROLL
               or pain[n1]
                return false
            end

            if (hurt ~= 1 and n1 == 1) or (hurt ~= -1 and n1 == 2) then
                S_StartSound(mo[n1], sfx_lose)
                return true -- Certifica-se de que o outro jogador não tenha sido danificado
            end
        end

        -- Agora vamos atribuir essas funções ao personagem:
        CBW_Battle.SkinVars["sonic"] = {
            special           = RingBarrage,
            func_priority_ext = PriorityFunc,
            func_exhaust      = ExhaustFunc,
            func_collide      = CollideFunc
        }

        /* Todos os especiais dos seis personagens originais também podem ser atribuídos a personagens personalizados. As funções para eles são:
            Sonic:        CBW_Battle.Action.SuperSpinJump
            Tails:        CBW_Battle.Action.RoboMissile
            Knuckles:     CBW_Battle.Action.Dig
            Amy:          CBW_Battle.Action.PikoSpin
            Fang:         CBW_Battle.Action.BombThrow
            Metal Sonic:  CBW_Battle.Action.EnergyAttack
        */
    end
end)
