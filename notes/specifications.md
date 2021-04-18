# Spécifications et notes pour un GDL

## Objectif 
Développer un langage de description de jeux (GDL) ayant les spécifications suivantes :

1.  le GDL permet de décrire les règles de tous les jeux de plateaux "modernes" qui sont basés uniquement sur du hasard et des décisions, à actions simultanées ou séquentielles, information cachée ou non. Sont exclus ici les jeux reposant sur des compétences techniques ou physiques, des associations d'idées, le langage ou des connaissances (pictionnary, mysterium, trivial pursuit,  boxe thaï ...). Sont inclus les jeux abstraits, de stratégie, de cartes, eurogames ou ameritrash, jeux adversariaux ou collaboratifs, jeux avec traîtres cachés.
2.  l'objectif principal du langage est de permettre le développement et l'équilibrage de jeux de plateau (*game design*) tout en restant accessible dans ses fonctions principales à un designer ayant des compétences en programmation peu avancées.


## Fonctionnalités
En vrac, à voir si certaines sont irréalisables ou contradictoires

* lien avec une interface graphique de sorte à pouvoir tester des prototypes de jeux directement
* gestion des priorités entre règles, des exceptions. Ajouter une règle qui contredit une autre règle peut se faire en fin de fichier de description sans changer le début.
* plus généralement un fichier de description est "en vrac" et n'a pas un ordre de lecture précis de précédence, comme un livret de règles en général
* propriétés de haut niveau (librairies) permettant les mutations aléatoires pour générer des jeux par algorithmes génétiques (?) 

## Couches de description

* La couche composants, la plus basse du GDL, décrit les composants et les actions qui peuvent y être appliquées. Elle décrit donc l'ensemble des états du jeu et les façons de passer d'un état à l'autre, et les conditions d'arrêt.

* La couche joueurs, décrit quels joueurs entreprennent les actions. Il s'agit juste d'attribuer à chaque action appliquée une signature. Il est possible dans un état de jeu d'avoir des actions disponibles uniquement pour un joueur, ou pour plusieurs joueurs : il s'agit dans ce cas d'une action conjointe ou coopérative, ou bien d'actions simultanées. Dans le second cas la signature de l'action attribue des joueurs différents à différentes sous-actions de l'action "produit" en cours. Il est également possible de considérer une action simultanée concurrente de façon séquentielle.

  Cette couche décrit aussi quels sont les objectifs de chaque joueur, les classement et conditions de victoire en fin de jeu.

* Couche arbitre. Un joueur particulier toujours présent est le joueur "nature". Les actions qui ne sont pas signées lui sont automatiquement attribuées. Si le joueur nature dispose de plusieurs actions pouvant être effectuées, alors cette couche doit décrire un moyen de décider entre les actions (typiquement une loi de probabilité).

* La couche d'information. Cette couche décrit quels éléments d'information sont disponibles pour quels joueurs. Cela peut être certaines relations (eg carte face cachée ) aussi bien que certaines actions (placer un pion face cachée de son choix sur une case).


## Niveaux
* au niveau le plus haut (le niveau librairie), l'utilisateur dispose du GDL accompagné de librairies ou modules permettant d'utiliser des composants ou règles standards (ex : plateau en grille rectangulaire, deck de cartes, notions de tour de jeux et de phases, etc). Ces librairies sont rédigées dans le langage lui-même au niveau basique
* au niveau basique, le langage permet une description ensembliste et relationnelle des composants et relations qui forment les états du jeu ainsi que les actions qui peuvent s'y appliquer
* afin de décrire les conditions ou fonctions/algos à appliquer on peut disposer de sous-langages dont la portée est locale à la condition ou la fonction. par ex :
  * un langage logique type premier ordre sur les composants et relations du jeu (e.g. "il existe un pion noir qui est voisin d'une case blanche")
  * un langage de type procédural pour écrire les conditions ou fonctions de type algorithmique, difficilement exprimables avec la logique ci-dessus ou pour lesquels une implémentation guidée est nécessaire (e.g. notions de connexité). Ce langage peut être laissé libre tout en précisant le type d'entrées sorties des fonctions ou conditions, ça peut être le langage d'implémentation du GDL (par ex python) tant qu'il s'agit d'un langage Turing complet.

* Le sucre syntactique permet d'écrire par des phrases structurées des propriétés habituellement notées mathématiquement. Par exemple *move(a.x, z)* pourrait être noté *move x of a to z* et *y = truc(a,b)* pourrait être noté *y is a truc with a and b*. 

## Concepts

* Les **composants** du jeu sont les **éléments** et **relations ** qui permettent de décrire un **état** du jeu. 

* Les **éléments** de jeu sont en nombre fini. Ils sont caractérisés par un **type** qui est une chaîne de caractère et est invariable, eg : pion cavalier, carte de rencontre, jeton production, etc. La sémantique du type est que deux éléments de même type devraient avoir des propriétés communes sans forcément être indiscernables. Le type sert à spécifier des ensembles de base pour les variables des actions/ conditions comme

  *pour tout pion cavalier x : action bouger x de ....*

  Il devrait être possible de définir de nouveaux types par opérations ensemblistes sur les types présents, ou bien (?) d'associer plusieurs types à un élément comme

  *carte-C23  de type : carte ennemi, carte de rencontre, carte*

  ici donnés par ordre d'inclusion

* Les **relations** sont de type relations mathématiques et portent sur les éléments de jeu au premier ordre. Ces relations peuvent varier au cours du jeu et c'est la donnée de toutes les relations à un instant donné qui caractérise un **état** de jeu.  Les éléments et relations caractérisent donc tout ce qu'il y a à savoir à un instant donné pour déterminer les actions disponibles : quelle est la phase courante, le joueur actif, etc. Certains composants peuvent donc correspondre à des principes de jeu parfois non matérialisés mais qui pourraient l'être (par un pion, une échelle etc).

  On peut distinguer des relations unaires comme *Inclinée(c)* qui pourrait aussi se noter *c.inclinée = True*, des relations binaires *adjacents(x,y)* éventuellement fonctionnelles *x.successeur = y*.  Des relations de plus grande arité peuvent être nécessaires comme *alignés(x,y,z)*. 

* Les **actions** sont les transitions qui permettent de passer d'un état de jeu à un autre état. Une action dispose de **paramètres** qui sont des éléments spécifiés par leur type, de **conditions** exprimés dans la logique sur les éléments/relations, et d'un **effet** qui va changer les relations et donc l'état du jeu.
* Les **assertions** sont des conditions qui doivent être vérifiées dans chaque état de jeu et limitent donc la portée des actions e.g. *deux pions blancs ne peuvent jamais être voisins*. Les assertions s'ajoutent donc comme condition pour chaque  action mais sont à vérifier sur l'état final de l'action et non sur l'état de départ.

On peut ajouter d'autres structures de base si nécessaire.

* un **ensemble** est une collection dynamique de composants
* un **ensemble ordonné** 
* un graphe non orienté, orienté etc

L'important est que l'on puisse toujours écrire des conditions et actions dans une logique sur ce langage plus riche et qu'elles soient implémentables automatiquement.

## Librairies

Le langage de bas niveau des éléments/relations est utilisé pour décrire des objets de plus haut niveau qui implémentent des concepts courants (ou ludèmes) de jeu de plateau. Les objets de ces librairies sont néanmoins accessibles dans le code et modifiables par un système d'**héritage**. 

**Exemple : l'objet de librairie deck de cartes**

On veut définir un objet *deck* ayant les fonctionnalités suivantes :

* action *placer_sur* : place une carte sur le deck
* action *placer_sous*
* action *mélanger* : étant donné un ordre total applique la transformation sur les cartes (l'ordre est déterminé par la couche arbitre)
* action *piocher* 

Et des paramètres de la couche informationnelle comme le fait que les cartes du deck sont visibles ou secretes, etc.










