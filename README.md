# GestionComptesPersonnels
Ma version du programme : Gestion des comptes personnels

Présenté ici ma vision du programme présenté par Patrick Premartin https://github.com/DeveloppeurPascal/GestionComptesPersonnels

 - Une utilisation de TPageControl plutôt que plusieurs TForms.
 - Une utilisation de TListView plutôt que des TStringGrid  
 - Une double réponse au challenge posé par la structure de la table (Date texte sous la forme AAAAMMJJ et Sens écriture '+' ou '-')
   sans avoir à passer par des champs calculés : 
      a) utilisation de la propriété customformat
      b) utilisation de fonction SQLite (voir PFonctionSQlite.dproj)
      
 En guise de cerises sur le gâteau 
 - Une liste avec tailles d'éléments variables (en réponse à la taille de la colonne libellé)
 - Une gestion de style (dark/light) chargés en ressource.
 - Une gestion du clavier virtuel * en cours de réalisation.
 
