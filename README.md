# GestionComptesPersonnels
Ma version du programme : Gestion des comptes personnels

Présenté ici ma vision du programme présenté par Patrick Premartin https://github.com/DeveloppeurPascal/GestionComptesPersonnels

 - Une utilisation de TPageControl plutôt que plusieurs TForms.
 - Une utilisation de TListView plutôt que des TStringGrid  
 - Une double réponse au challenge posé par la structure de la table (Date texte sous la forme AAAAMMJJ et Sens écriture '+' ou '-')
   sans avoir à passer par des champs calculés : 
     - Utilisation de la propriété customformat.
     - Utilisation de fonction SQLite (voir PFonctionSQlite.dproj).
      
 ## En guise de cerises sur le gâteau 
 - Une liste avec tailles d'éléments variables (en réponse à la taille de la colonne libellé)
 - Une gestion de style (dark/light) chargés en ressource. Quelques astuces pour les couleurs de TPath utilisés lors du changement de style
 - Une gestion du clavier virtuel * en cours de réalisation.
 
 ![Capture](https://user-images.githubusercontent.com/51124639/108681611-a63db600-74ef-11eb-8dd0-9ad6b75f8dd6.PNG)
 
 ![Capture_1](https://user-images.githubusercontent.com/51124639/108682007-10eef180-74f0-11eb-836b-6a6b4a2e6b7e.PNG)


## En prévision
 - Passage de la liste des écritures en mode édition pour :
     - Pointer les écritures (case à cocher).
     - Supprimer des écritures (bouton Delete).
 
