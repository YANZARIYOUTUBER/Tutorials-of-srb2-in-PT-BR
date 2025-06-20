/*
Abaixo estão todas as variáveis que você pode manipular no hook S_SKIN, copiadas e coladas (sem querer perder tempo) diretamente do skin "Default".
Isso pode não estar permanentemente atualizado, então confira o lump LUA_CUSTOMCHARS dentro de L_GSGrindRails.pk3 para ter certeza!

Este não é o S_SKIN “usual” — veja o exemplo em Custom‑Character‑Example para entender como funciona!
_______________________________________________________________________________________________________

JUMP = true,               -- Você pode pular dos trilhos com o botão de pulo!
JUMPBOOST = true,          -- Ganha um pequeno impulso ao pular dos trilhos? (até certo limite)
AIRDRAG = 44,              -- Tempo de arraste no ar (airdrag) após sair do trilho, em tics. (35 tics = 1 segundo)

SIDEHOP = 36,              -- Define a velocidade do salto lateral. Se for 0, você não pode fazer sidehop!
SIDEHOPARC = 0,           -- Se não for 0, cria um arco vertical no sidehop, como nos jogos modernos.
SIDEFLIP = nil,           -- Quer um sideflip ao estilo moderno? Indique aqui o sprite a usar! (recomendo SPR2_SPNG)
SIDEHOPTIME = 9,          -- Quantos tics seu sidehop permanece ativo. Saltos lentos podem precisar de mais tempo.

_______________________________________________________________________________________________________

EMERGENCYDROP = true,      -- Se true, você pode apertar CUSTOM3 para cair da plataforma de trilhos (grind) imediatamente.
CROUCH = true,             -- Se true, possibilita o "Focus Grind" segurando SPIN, ganhando mais impulso em declives, mas com menos equilíbrio.
CROUCHBUTTON = BT_SPIN,    -- Botão para o Focus Grind. Você pode combinar com BT_CUSTOM1 usando o operador '|'.
AUTOBALANCE = false,       -- Se true, você mantém equilíbrio automático nos trilhos, quase não caindo.
SLOPEPHYSICS = true,       -- Se false, ignora totalmente a física do trilho com inclinação.
MUSTBALANCE = false,       -- Sempre exige equilíbrio manual, mesmo em trilhos — risco de queda a qualquer momento (como em SA2).

_______________________________________________________________________________________________________

SLOPEMULT = 0,             -- Modifica o impulso em declives: 10 = +10%, -20 = -20%.
LAUNCHPOWER = 0,           -- Modifica a altura do lançamento vertical em trilhos: 10 = +10%, -20 = -20%.
STARTMODIFIER = 0,         -- Modifica a velocidade ao entrar no trilho: 10 = +10%, -20 = -20%.
STARTSPEEDCONDITION = 0,   -- Velocidade mínima exigida para aplicar STARTMODIFIER. Se 0, assume 30.

_______________________________________________________________________________________________________

HEROESTWIST = 15,          -- Potência do "Twist Drive", diminuindo com o tempo. 1 é só visual, 0 desativa o Twist Drive!
TWISTBUTTON = 0,           -- Botão para o Twist Drive. Se 0, usa o mesmo do agachamento (CROUCHBUTTON).
ACCELSPEED = 0,            -- Se não for 0, permite acelerar forçadamente nos trilhos segurando para frente. (ex: Tails)
ACCELCAP = 48,             -- Velocidade máx. para o ACCELSPEED. Padrão = 48.
AUTODASHMODE = 72,         -- Velocidade mínima no grind para ativar dash automaticamente (se tem SF_DASHMODE).

MINSPEED = 0,              -- Velocidade mínima de grind. Se >0, o personagem nunca reverte.
MAXSPEED = 180,            -- Limite máximo de velocidade no grind. Se 0, sem limite.
_______________________________________________________________________________________________________

-- ATENÇÃO: Para ver os sprites do sprite2, consulte: bit.ly/GSrailsprites

FORCESPRITE = nil,         -- Força um sprite2 durante o grind, ignorando SPR2_GRND e sprites padrão.
FORCEHANGSPRITE = nil,    -- Força um sprite2 quando estiver em hangrails (SPR2_RIDE é o padrão).
WALLCLINGSPRITE = nil,    -- Sprite2 usado ao preparar pulo de parede. Caso nil, o jogo escolhe automaticamente.
NOWINDLINES = false,      -- Se true, não cria linhas de vento ao correr nos trilhos.
NOSIDEHOPGFX = 0,         -- 1 = apenas ghosts de sidehop; 2 = apenas linhas de velocidade; 3 = nenhum dos dois.
AUTOVERTICALAIM = true,   -- Se false, mira vertical não é ajustada automaticamente durante grind (loops/câmera lateral são exceções).
NOFUNALLOWED = false,     -- Se true, o personagem não pode usar poses de tonto ao jogar bandeira (TOSS FLAG).

Isso é tudo!
O que você não definir, será igual ao padrão acima.
Por fim, certifique-se de usar vírgulas e maiúsculas corretamente — o Lua é MUITO exigente nisso!
*/
