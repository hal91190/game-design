components: concat (repeat 3 \j -> repeat 3 \i -> {name = 'case', x = i, y=0})

components: [{name = 'case', x = i, y = j} for i in (0..2) for j in (0..2)]

components: [{name <- 'case', x <- 0, y <- 0}]

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




transition t12: (j : name=='player')
            when:
               active_player == j,
            effect:
               1. (decisionphase12.3) decision:
               2.    (p,c) <- jouer(p : name=='pion', c : name=='case'un, j)
               3. (decision_effets) turn_counter <- turn_counter + 1
                  3.after
               4. ..
               5 ... 

se décomposerait en
                   
transition t1:
    when:
       
       last decision == jouer(p,c,j)  
    effect:
      turn_counter <- turn_counter + 1

transition t2:
   when:
      t1.after
   effect:
       unset position(p,reserve)
       
transition t3:
   when:
      t2.after
   effect:
      set position(p,c)
      phase <- 2



flow: 
   t1
   t2
   t3


repeat :
   turn J1
   turn J2

liste :  nil, cons, head, tail
ensemble :  in,  add, pop, fromlist, tolist,  size, emptyset, isEmpty
entier: + - * / mod == <

{ c    for c in case if c.x < 2 }
-- on peut vérifier que tous les c in case ont l'attribut x à la compilation

deplacementfou fou case =
    let casefou = position fou  -- car position est une relation fonctionnelle
    let x1, y1, x2, y2 = ....
         between x1 y1 x2 y2 |> \x3 y3 -> emtpyCase x3 y3

let ... in ...
if ... then ... else ...




if c.name == case then
   calcul avec c.x
else
   ...

case c.name of
   case -> calcul avec c.x
   _ -> ...

if c has x && c has y then
   calcul avec x et y
else
   