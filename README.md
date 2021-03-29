# Game Design

## Articles
* [Articles sur le game design](https://beyondthebox.fr/articles/) chez "Beyond the Box"
* Une équipe de google teste un jeu de cartes type magic par IA pour équilibrer https://ai.googleblog.com/2021/03/leveraging-machine-learning-for-game.html

## YouTube
* [Game Developers Conference](https://www.youtube.com/c/Gdconf/featured)
  * [A Course About Game Balance](https://youtu.be/tR-9oXiytsk) : [Ian Schreiber](https://gamedesignconcepts.wordpress.com/2009/03/31/what-is-game-design-concepts/), un prof qui présente le syllabus de son cours sur l'équilibrage de jeux
  * [Designing Race for the Galaxy: Making a Strategic Card Game](https://youtu.be/JcyyeAww2wc) : le design de [Race for the Galaxy](https://boardgamegeek.com/boardgame/28143/race-galaxy), par son créateur [Tom Lehmann](https://boardgamegeek.com/boardgamedesigner/150/thomas-lehmann)
  * [Magic: the Gathering: Twenty Years, Twenty Lessons Learned](https://youtu.be/QHHg99hwQGY) : une présentation par le lead designer [Mark Rosewater](https://en.wikipedia.org/wiki/Mark_Rosewater) de [Magic The Gathering](https://boardgamegeek.com/boardgame/463/magic-gathering)

## Librairies/Plateformes
* [boardgame.io](https://github.com/boardgameio/boardgame.io) moteur pour créer des jeux tour par tour en JavaScript (à voir si c'est pertinent)
* [Board Game Arena](https://boardgamearena.com/welcome) est une plateforme web permettant de jouer à des jeux de société. L'ensemble des règles du jeu peut y être implémenté.
  * [Board Game Arena Studio](https://en.doc.boardgamearena.com/Studio) permet d'implémenter le jeu ([guidelines](https://en.doc.boardgamearena.com/BGA_Studio_Guidelines)). Les langages utilisés sont PHP, SQL, HTML/CSS et Javascript ([framework Dojo](https://dojo.io/)).
* [Tabletopia](https://tabletopia.com/) est un moteur 3D pour implémenter des jeux. Il permet de reproduire le matériel du jeu et de le manipuler.
  * [Documentation sur la création de jeux](https://help.tabletopia.com/knowledge-base/how-to-make-your-game-prototype-on-tabletopia/).
* [Tabletop Simulator](https://www.tabletopsimulator.com/) est un moteur 3D pour implémenter des jeux. Il permet de reproduire le matériel du jeu et de le manipuler. Les règles du jeu ne sont pas implémentée. Seuls quelques scripts permettent de simplifier les actions de base du jeu (mise en place, …).
  * La conception du jeu se déroule au sein de l'outil en créant les différents objets du jeu grâce à l'interface graphique ([guides](https://steamcommunity.com/app/286160/guides/?searchText=&browsefilter=trend&browsesort=creationorder&requiredtags%5B0%5D=Modding+or+Configuration&requiredtags%5B1%5D=-1&p=2), [documentation technique sur les objets manipulables](https://kb.tabletopsimulator.com/custom-content/about-custom-objects/)).
  * L'automatisation de certaines actions peut ensuite être réalisée à l'aide de [scripts Lua](https://api.tabletopsimulator.com/).
* [Vassal](http://www.vassalengine.org/) est un moteur pour implémenter des jeux (plateau ou cartes).
  * [Code source (Java)](https://github.com/vassalengine/vassal).
  * [Guide](http://www.vassalengine.org/mediawiki/images/b/b0/Vassal_3.1_designerguide.pdf) pour la conception de module pour Vassal. La conception d'un module ne nécessite pas forcément de savoir programmer en Java.
* [XMage](http://xmage.de/) permet de jouer à Magic contre un joueur humain ou une IA et implémente la quasi-totalité des règles des différentes cartes.
  * [Code source](https://github.com/magefree/mage)
  * Les [Text-changing effect](https://mtg.fandom.com/wiki/Text-changing_effect) semblent difficiles à implémenter.
