<?php

/* Mise en format JSON et non plus php. */
header ("Content-type: application/json");

/* Commencer par tester la connexion. */
try
{
	$bdd = new PDO('mysql:host=localhost;dbname=Outpitch;charset=utf8', 'root', 'root');
}
catch(Exception $e)
{
	die('Erreur : '.$e->getMessage());
}



/* Récupérer les données "pseudo" et "mdp" rentrées dans index.html. */

$idPlayer=$_POST[idPlayer];
$idPlayer = str_replace(' ', '', $idPlayer);
$picture=$_POST[picture];
$picture = str_replace(' ', '', $picture);


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" UPDATE Player SET Picture = '$picture' WHERE ID_Player = '$idPlayer' ");


$erreur = 1;

/* Format JSON. */
echo '{  
	"erreur":'.$erreur.',
	 
	"idPlayer":"'.$idPlayer.'",
	"pictureData":"'.$picture.'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();

?>