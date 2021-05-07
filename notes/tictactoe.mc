

component: name <- 'case', x <- 0, y <- 0
component: name <- 'case', x <- 1, y <- 0
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

component reserve:

component player_black: name <- 'player', color <- 'black'
component player_white: name <- 'player', color <- 'white'

variable turn_counter: int
turn_counter <- 0

relation position: {name=='pion'} <-> {name='case'} || {reserve}  

Constant Trios: ...(liste des triplets de cases de lignes, colonnes, diagonales)


function winner: -> {None, player_black, player_white}
                |-> j.color if j : name=='player' | exists(C in Trios | monocolor(C,j)) 

function monocolor: {{name=='case'}}, {'name'==players} -> booleans
                    C               , j                |-> count(c in C | c.color==j.color)==3


function empty: {name==case} -> booleans
                          c |-> not exists(p : name=='pion' | position(p,c)) 

action jouer(p, c, j):
            if:
               active_player == j,
               position(p,reserve),
               p.color == j.color,
               not exists(q : q.name=='pion', position(q,c)  )
            

transition:
    if:
       last decision == jouer(p,c,j)  
    effect:
       turn_counter <- turn_counter + 1
       unset position(p,reserve)
       set position(p,c)

transition: (j : name=='player')
            if:
               active_player == j,
            effect:
               decision:
                   jouer(p : name=='pion', c : name=='case'un, j)position(p,reserve)
                   set position(p,c)