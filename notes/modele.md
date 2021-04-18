# Modèles mathématiques pour le niveau "prog" du GDL

## Modèle général de jeu à information partielle

On commence par donner un modèle abstrait général pour les jeux stochastiques finis multi-joueurs à information partielle et actions simultanées (ou non). Ce modèle sera ensuite affiné pour être plus proche des jeux de plateau dans la description. Le but étant que la description d'un jeu dans le GDL s'inscrive naturellement dans ces modèles.

 Pour définir un tel jeu on se donne les éléments suivants, où les différents ensembles sont supposés disjoints :

* $J$ un ensemble fini non vide dont les éléments sont appelés *joueurs*. On note $r$ un joueur supplémentaire, le joueur *random*, avec $r \not\in J$.

* $\Sigma$ un ensemble fini non vide de *signaux*

* $S$ un ensemble fini non vide d'*états*

* $A$ un ensemble fini non vides d'*actions*

* $s_0 \in S$ un *état initial* 

*  $S_f \subset S$ un sous-ensemble non vide d'*états finals*

* $sc : S_f \rightarrow \R^J$ une *fonction de score* (on suppose que chaque joueur veut le maximiser)

* pour tout $s \in S_f \setminus S$, on dispose

  * pour chaque joueur $j \in J \cup \{r\}$, d'un ensemble d'actions $A(s,j) \subset A$ qui sont les *actions disponibles pour le joueur $j$* en $s$ 

  * d'une distribution de probabilité $\mu(s)$ sur $A(s,r)$

  * d'une fonction de transition 

    $$\tau : S \times \Pi_{j \in J \cup \{r\}} A(s,j) \rightarrow S \times \Sigma^J$$
    
    qui à un état et un profil d'actions associe un nouvel état et un signal par joueur.

Le flot du jeu est le suivant :

* état courant $s \leftarrow s_0$

* temps $ t \leftarrow 0$

* tant que $s \not\in S_f$ répéter :

  * chaque joueur $j \in J$ est informé du contenu de l'ensemble $A(s,j)$ et choisit simultanément avec les autres une action disponible $a_j \in A(s,j)$ en se basant uniquement sur $A(s,j)$ et les signaux reçus aux tours précédents $\sigma_0(j), \sigma_1(j), \cdots, \sigma_{t-1}(j)$

  * on détermine indépendamment de tout le reste une action aléatoire $a_r \in A(s,r)$ selon la probabilité $\mu(s)$ 

  * le nouvel état courant et les signaux envoyés au joueurs sont déterminées par la transition $\tau$:

    $$ s, (\sigma_t(j))_{j \in J} \leftarrow \tau(s, (a_j)_{j \in J \cup \{r\}} )$$

  * $t \leftarrow t+1$

* les scores $sc(j)$ sont déterminés pour chaque $j \in J$

### Remarques

* Si jamais tous les joueurs ne sont pas actifs en $s$, ou s'il n'y a pas de hasard, il suffit de donner une seule action aux joueurs concernés, et de même pour une transition "automatique" qui serait indépendante du choix des joueurs (*e.g.* remettre à jour certains compteurs en fin de manche).
* On suppose ici que les règles du jeu (donc tous les ensembles et fonctions qui déterminent le jeu) sont connus des joueurs (information complète). La mise en place du jeu qui peut être modélisée comme un ensemble d'actions stochastiques en début de jeu peut par contre introduire de l'incertitude.
* Si le jeu est à information parfaite, il suffit que le signal envoyé à chaque joueur contienne la liste des actions de chaque joueur (y compris du joueur random).
* Dans sa généralité, ce modèle peut inclure le fait qu'un joueur ne se souvienne pas de ses propres actions (mémoire imparfaite).
* Le choix de faire du hasard un joueur comme un autre est seulement un moyen de réduire les notations en utilisant les analogies entre joueur random ou non
* A partir du moment où l'information est partielle on pourrait modéliser la simultanéité avec des actions séquentielles mais les actions simultanées sont tellement courantes qu'il nous semble opportun de les inclure dans le modèle

## Modèle plus proche du jeu de plateau.

### Etats du jeu

L'ensemble des états du jeu encode entièrement le point où en est le flot du jeu ; c'est par exemple l'ensemble des informations sur la partie qui sont stockées à un moment précis sur le serveur de BGA pour pouvoir continuer le jeu. Pour un jeu de plateau on peut distinguer deux types d'information pour un état :

*  Les informations sur le matériel, pions, jetons, plateau, emplacements, ainsi que leur positions, orientations, etc. On peut supposer que les phases et tours de jeu et autres variables de ce type dont la valeur doit être conservée font partie de cet ensemble car ces valeurs pourraient être matérialisées par des pions. 
* Les informations liées à la visibilité dont dispose chaque joueur sur ces composants et sur les actions adverses (on supposera qu'un joueur voit ses propres actions -- mais pas forcément l'intégralité de leurs paramètres).

### Etat matériel 

L'état matériel du jeu est représenté par un ensemble $C$ de composants dont les éléments sont des symboles atomiques - cet ensemble reste constant pour la durée du jeu et contient tous les éléments nécessaires. Ces composants sont liés entre eux par des relations (unaires c'est à dire des ensembles, binaires, etc) qui vont varier au cours du temps et l'ensemble de ces relations est noté R. C'est la valeur des relations dans R à un instant donné qui encode l'état matériel du jeu. On peut également utiliser directement des ensembles, produits d'ensembles et fonctions à la place des relations.

A ces composants  matériels peuvent s'ajouter des composants symboliques, comme un ensemble fini d'entiers de 1 à N pour garder certaines valeurs ou des points cardinaux pour décrire les orientations des pions.

Les relations qui composent R sont typiquement :

*  certaines relations statiques qui décrivent l'adjacence d'emplacements sur le plateau de jeu
* des relations binaires de position (pion sur case)

On utilise une relation particulière dite *relation d'attribution* notée "point" qui permet de structurer les composants entre eux. Par exemple, on peut avoir trois composants 

*macarte, macarte.recto, macarte.recto.symbole, macarte.recto.couleur*

Formellement on a la relation . entre les composants 

("macarte") . ("macarte.couleur")

### Visibilité

Les éléments cachés à un joueur pendant une partie de jeux de plateau sont essentiellement de deux types :

* sur l'état du jeu, certains composants ont des attributs visibles et d'autres sont cachés. On considèrera le cas général mais la plupart du temps la visibilité est soit totale (attribut visible de tous les joueurs), privée (un seul joueur peut voir l'attribut, e.g. une main de cartes) ou nulle (personne ne voit l'attribut, e.g. pioche).

  On aura donc pour chaque joueur à chaque instant un ensemble qui décrit les composants visibles et ceux qui sont cachés. 

* Pour simplifier, une relation $R(c_1,c_2,\dots,c_n)$ est visible par un joueur si chacun des composants $c_i$ est visible. Exemples d'application :

  * le joueur A a une carte face cachée dans sa main. Le joueur B voit *main_de_A*,  *la_carte*,  *la_carte.verso* ainsi que la relation *Position(la_carte, main_de_A)* mais *la_carte.recto* est  caché
  * le joueur A place un pion sur un emplacement derrière un paravent. On peut poser pour B que *le_pion* est visible mais que l'emplacement est caché, ainsi B ne voit pas la position précise du pion. Le joueur B a pu auparavant voir une action de déplacement du pion derrière le paravent.

* On peut utiliser le même principe pour la visibilité des actions. Exemples :

  * Le joueur A déplace un pion dont la face est cachée depuis une case visible jusqu'à case cachée derrière un paravent. On décompose ceci en deux actions :
    * *deplacement(pion,paravent)* ici l'action est visible car les composants sont visibles (même si *pion.recto* est non visible, *pion* l'est)
    * *deplacement(pion,case)* et la case étant cachée l'action n'est pas visible des autres qui ne savent même pas qu'il s'agit d'un déplacement (si nécessaire ajouter une action de communication).
  * Le joueur A joue une carte cachée de sa main  et la place sur la table. L'action se déroule en deux temps
    * *deplacement(carte,table)* est visible car carte est visible c'est *carte.recto* qui ne l'est pas
    * ensuite *carte.recto*  est *révélé* et devient visible de tous.

### Modèle

On reprend les notations du modèle précédent mais on va spécifier les états, signaux  et actions.

On se donne :

* $J$ un ensemble fini non vide dont les éléments sont appelés *joueurs*. On note $r$ un joueur supplémentaire, le joueur *random*, avec $r \not\in J$.
* $\cal C$ est un ensemble fini de composants dont les éléments sont des symboles atomiques. 
* un ensemble fini $\cal R$ de symboles de relations avec une arité $ari_r$ pour chaque symbole.  On note pour simplifier également $\cal R$ l'ensemble des profils (n-uplets) de relations sur $\cal C$ qui satisfont à ce schéma.
* un profil de relations initial $R_0 \in \cal R$
* un ensemble de profils de relations final $\cal R_f \subset \cal R$

Un *état du jeu* est la donnée d'un ensemble $R \in \cal R$ de relations sur $\cal C$ ainsi que d'un ensemble de visibilité $V_j \subset \cal C$ pour chaque $j \in J$.

Flot du jeu.

* temps $ t \leftarrow 0$

* initialiser $R \leftarrow R_0$

* pour chaque joueur $i \in J$, la visibilité de $i$ est totale soit $V_i = C$

* tant que $R \not\in \cal R_f$ répéter :

  * on détermine l'ensemble $act(R)$ l'ensemble des joueurs actifs en $s$

  * chaque joueur $j \in act(R)$ est informé du contenu de l'ensemble $A(R,j)$ et choisit simultanément avec les autres une action disponible $a_j \in A(R,j)$ en se basant uniquement sur $A(R,j)$ et les signaux reçus aux tours précédents $\sigma_0(j), \sigma_1(j), \cdots, \sigma_{t-1}(j)$

  * si $r \in act(R)$, on détermine indépendamment de tout le reste une action aléatoire $a_r \in A(R,r)$ selon la probabilité $\mu(R)$ 

  * pour chaque joueur $j \in J$, on prépare un signal constitué de :

    * sa propre action  $a_j$
    * un nuplet $(i,a_i,c_1, \dots,c_p)$ pour chaque joueur $i \neq j$, où $c_1, \dots, c_p$ sont les paramètres de l'action $a_i$ , à la condition que tous ces paramètres soient dans $V_j$

  * le nouvel état courant des relations et les visibilités sont déterminées par la transition $\tau$:

     $$R, (V_j)_{j \in J} \leftarrow \tau(R, (a_j)_{j \in J \cup \{r\}} )$$

  * chaque joueur $j \in J$ reçoit le signal préparé ci-dessus, auquel on ajoute l'ensemble des relations entre composants visibles pour les nouvelles valeurs de $R$ et $V_j$ 

  * $t \leftarrow t+1$

* les scores $sc(j)$ sont déterminés pour chaque $j \in J$