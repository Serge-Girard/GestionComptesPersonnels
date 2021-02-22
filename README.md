# GestionComptesPersonnels
Ma version du programme : Gestion des comptes personnels

Présenté ici ma vision du programme présenté par Patrick Premartin https://github.com/DeveloppeurPascal/GestionComptesPersonnels

 - Une utilisation de TPageControl plutôt que plusieurs TForms.
 - Une utilisation de TListView plutôt que des TStringGrid  
 - Une double réponse au challenge posé par la structure de la table (Date texte sous la forme AAAAMMJJ et Sens écriture '+' ou '-')
   sans avoir à passer par des champs calculés : 
     1. Utilisation de la propriété customformat
     2. utilisation de fonction SQLite (voir PFonctionSQlite.dproj)
      
 En guise de cerises sur le gâteau 
 - Une liste avec tailles d'éléments variables (en réponse à la taille de la colonne libellé)
 - Une gestion de style (dark/light) chargés en ressource. Quelques astuces pour les couleurs de TPath utilisés lors du changement de style
 - Une gestion du clavier virtuel * en cours de réalisation.

En prévision
 - Passage de la liste des écritures en mode édition pour :
     - Pointer les écritures (case à cocher).
     - Supprimer des écritures (bouton Delete).
 
