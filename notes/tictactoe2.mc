components: concat (repeat 3 \j -> repeat 3 \i -> {name = 'case', x = i, y=0})

components: [{name = 'case', x = i, y = j} for i in (0..2) for j in (0..2)]

components: [ {name <- 'case', x <- 0, y <- 0}  ]

components: grille 8 8 "case"

components [ {case, x = 0, y = 0}
           , {case, x = 0, y = 1}
           , {case, x <- 0, y <- 2}
           , {case, x <- 1, y <- 0}
           ]

component: {name <- 'case', x <- 1, y <- 0}
component: name <- 'case', x <- 2, y <- 0
component: name <- 'case', x <- 0, y <- 1
component: name <- 'case', x <- 1, y <- 1
component: name <- 'case', x <- 2, y <- 1
component: name <- 'case', x <- 0, y <- 2
component: name <- 'case', x <- 1, y <- 2
component: name <- 'case', x <- 2, y <- 2

[component pion: [{color <- white}] * 3

(component: {pion: color <- 'white'}) * 3

components: replicate 3 {pion: color <- white}

component: pion: color <- 'white'
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

relation position: (pion, case + reserve)
relation position: ({name=pion}, {name=case} + reserve)
relation position: ({name=pion, color='black'}, {name=case} + reserve)

position <- { (p, reserve) for p in {pion} }
                   [(  ,  ), ( , ), (, )]
                   maFonctionRelation 3 3
         += element ou ensemble
         -= element ou ensemble

         (
         += element
         ++= ensemble
         )

trios: ...(liste des triplets de cases de lignes, colonnes, diagonales)


-- j'aime pas trop la syntaxe  j.color if j : name='player' mais je ne sais pas quoi proposer de mieux
function winner: -> None + player
                |-> j.color if j : name='player' | isEmpty ({ C in Trios | monocolor(C,j) }) 

function monocolor: powerset case, players -> boolean
function monocolor: {{name=case}}, players -> boolean
function monocolor: {case}, players -> boolean
                    C            , p                |-> size({c in C | c.color==p.color})==3
                                                    |-> size {c in C | c.color==p.color} ==3

function empty: case -> boolean
function empty: {name='case'} -> boolean
function empty: {name='case', color='black'} -> boolean
function empty: ({name='case', color='black'}) -> boolean
                     c |-> not exists p in pion | position(p,c)
                     c |-> isEmpty {p in pion | position(p,c)}
                     c |-> {p in pion | position(p,c)} == emptyset

f: N -> N
  x |-> x * x

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