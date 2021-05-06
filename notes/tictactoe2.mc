components: repeat 3 \j -> repeat 3 \i -> {name = 'case', x = i, y=0}
           [{name = 'case', x = i, y = j} for i in (0..2) for j in (0..2)]

components [ {name <- 'case', x <- 0, y <- 0}
           , {name <- 'case', x <- 0, y <- 1}
           , {name <- 'case', x <- 0, y <- 2}
           , {name <- 'case', x <- 1, y <- 0}
           ]

component: {name <- 'case', x <- 1, y <- 0}
component: name <- 'case', x <- 2, y <- 0
component: name <- 'case', x <- 0, y <- 1
component: name <- 'case', x <- 1, y <- 1
component: name <- 'case', x <- 2, y <- 1
component: name <- 'case', x <- 0, y <- 2
component: name <- 'case', x <- 1, y <- 2
component: name <- 'case', x <- 2, y <- 2

component: name <- 'pion', color <- 'white'
component: name <- 'pion', color <- 'white'
component: name <- 'pion', color <- 'white'
component: name <- 'pion', color <- 'white'
component: name <- 'pion', color <- 'black'
component: name <- 'pion', color <- 'white'
component: name <- 'pion', color <- 'white'

component reserve: {}

component player_black: {name = 'player', color = 'black'}
component player_white: {name = 'player', color = 'white'}


variable turn_counter: int
turn_counter <- 0

-- j'aime pas trop le || pour union mais ça peut aller
relation position: {name='pion'} <-> {name='case'} || {reserve}  
                   [ (  ,  ), ( , ), (, )]
                   maFonctionRelation

trios: ...(liste des triplets de cases de lignes, colonnes, diagonales)


-- j'aime pas trop la syntaxe  j.color if j : name='player' mais je ne sais pas quoi proposer de mieux
function winner: -> {None, player_black, player_white}
                |-> j.color if j : name='player' | isEmpty ({ C in Trios | monocolor(C,j) }) 

function monocolor: {name='case'}, {'name'=players} -> booleans
                    C            , j                |-> size({c in C | c.color==j.color})==3


function empty: {name=case} -> booleans
                          c |-> exists p in {name=='pion'} | position(p,c) 

-- peut-être utliser des && au lieu des ,
action jouer(p, c, j):
            when:
               j in active_players,
               position(p,reserve),
               p.color == j.color,
               isEmpty ({ q : {q.name=='pion'} | position(q,c) })


transition:
    when:
       phase == 1
       last decision == jouer(p,c,j)  
    effect:
       turn_counter <- turn_counter + 1
       unset position(p,reserve)
       set position(p,c)
       phase <- 2

-- j'ai pas regardé ici
transition: (j : name=='player')
            when:
               phase == 2,
               active_player == j,
            effect:
               phase == 1
               decision:
                   jouer(p : name=='pion', c : name=='case'un, j)