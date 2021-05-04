

%components and their attributes are immutable
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

relation position: {name=='pion'} <-> {name='case'} || {reserve}  

%variables are syntactic sugar for an atomic component with a function value

function winner: -> {None, player_black, player_white}

function empty: {name==case} -> booleans

action place(p, c, j):
            if:
               active_player == j,
               position(p,reserve),
               p.color == j.color,
               not exists(q : q.name=='pion', position(q,c)  )
            

transition:
    if:
       last decision == place(p,c,j)  
    effect:
       set 

transition: (j : name=='player')
            if:
               active_player == j,
            effect:
               decision:
                   place(p : name=='pion', c : name=='case', j)