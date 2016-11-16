1.  Téléchargez MAMP : https://www.mamp.info/en/downloads/ (la version gratuite grise est amplement suffisante)
2.  Ouvrez MAMP (et pas MAMP PRO)
3.  Cliquez sur ‘Démarrer les serveurs’
4.  Cliquez sur ‘Ouvrir la page WebStart’
5.  Vous êtes sur votre localhost avec votre navigateur par défaut. Cliquez sur outils puis phpMyAdmin
6.  Dans phpMyAdmin :       
	   a) cliquez sur Nouvelle base de données 
	   b) Nom de la base de données : ‘Outpitch’ 
	   c) Interclassement : latin1_general_ci -> créer
	   d) cliquez sur SQL
	   e) copier coller le text de 'BDD.txt' puis cliquez sur exécuter
7.  Mettez le dossier Outpitch (le dossier doit bien s’appeler ‘Outpitch’) dans ‘Applications/MAMP/htdocs/’
8.  Dans le dossier Outpitch, lancez ‘Outpitch.xcodeproj’ (Assurez vous d’avoir la dernière version de Xcode)
9.  Dans Xcode, cliquez sur Outpitch, en haut à gauche (show the project navigator)
10.  Cliquez sur ‘General’ (project and target list)
11. Cliquez sur le ‘+’ de Embedded Binaries puis sélectionnez ‘Add Other…’
12. Sélectionnez le fichier ‘Charts.xcodeproj’ (ios-charts-master/Charts)
13. Cliquez de nouveau sur le ‘+’ de Embedded Binaries
14. Dans ‘Outpitch/Charts.xcodeproj/Products’ sélectionnez ‘Charts.frameworkiOS’ et cliquez sur ‘Add’
15. Ouvrez MAMP (gris) et cliquez sur ‘démarrez les serveurs’ si vous l’avez fermé entre temps
16. Build l’application (cmd+B) xcode Outpitch (cela peut prendre quelques secondes)
17. En haut à gauche, à côté du bouton ‘play’ et ‘stop’ précisez que vous voulez compiler sur un ‘iPhone 5s’
18. Run l’application (cmd+R) xcode Outpitch
19. Si la taille de la fenêtre du simulateur n’est pas adaptée, n’hésité pas à la redimensionner dans Simulator (Window / Scale) 