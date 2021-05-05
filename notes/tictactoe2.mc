component reserve: {}

component player_black {name = 'player', color = 'black'}
component player_white: {name = 'player', color = 'white'}

variable turn_counter: int
turn_counter <- 0

-- j'aime pas trop le || pour union mais ça peut aller
relation position: {name='pion'} <-> {name='case'} || {reserve}  

Constant Trios: ...(liste des triplets de cases de lignes, colonnes, diagonales)

-- j'aime pas trop la syntaxe  j.color if j : name='player' mais je ne sais pas quoi proposer de mieux
function winner: -> {None, player_black, player_white}
                |-> j.color if j : name='player' | isEmpty ({ C in Trios | monocolor(C,j) }) 

function monocolor: {name='case'}, {'name'=players} -> booleans
                    C            , j                |-> size({c in C | c.color==j.color})==3


function empty: {name=case} -> booleans
                          c |-> empty({ p in {name=='pion'} | position(p,c) }) 

-- peut-être utliser des && au lieu des ,
action jouer(p, c, j):
            when:
               active_player == j,
               position(p,reserve),
               p.color == j.color,
               isEmpty ({ q : {q.name=='pion'} | position(q,c) })
            

transition:
    when:
       last decision == jouer(p,c,j)  
    effect:
       turn_counter <- turn_counter + 1
       unset position(p,reserve)
       set position(p,c)

-- j'ai pas regardé ici
transition: (j : name=='player')
            when:
               active_player == j,
            effect:
               decision:
                   jouer(p : name=='pion', c : name=='case'un, j)position(p,reserve)
                   set position(p,c)