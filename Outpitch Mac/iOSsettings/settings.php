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

$teamName=$_POST[teamName];
$teamName = str_replace(' ', '', $teamName);
$league=$_POST[league];
$league = str_replace(' ', '', $league);
$password=$_POST[mdp];
$password = str_replace(' ', '', $password);
$abbreviation=$_POST[abbreviation];
$abbreviation = str_replace(' ', '', $abbreviation);
$colorData=$_POST[colorData];
$colorData = str_replace(' ', '', $colorData);


$reponse1 = $bdd->query(" UPDATE Team SET Password = '$password', League = '$league', Abbreviation = '$abbreviation', Color = '$colorData' 
							WHERE Name ='$teamName' 
						");
$num = $reponse1->rowCount();
$erreur = 1;



echo '{  
	"erreur":'.$erreur.', 
	
	"abbreviationData":"'.$abbreviation.'",
	"nameData":"'.$teamName.'",
	"colorData":"'.$colorData.'",
	"leagueData":"'.$league.'"
	}';




   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();

?>