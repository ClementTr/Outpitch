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



/* Récupérer les données "teamName"  index.html. */
$teamName=$_POST[teamName];
$teamName = str_replace(' ', '', $teamName);

$idPlayer=$_POST[idPlayer];
$idPlayer = str_replace(' ', '', $idPlayer);

$matchDate=$_POST[matchDate];
$matchDate = str_replace(' ', '', $matchDate);

$goalsUs=$_POST[goalsUs];
$goalsUs = str_replace(' ', '', $goalsUs);

$goalsTheme=$_POST[goalsTheme];
$goalsTheme = str_replace(' ', '', $goalsTheme);

$opponent=$_POST[opponent];
$opponent = str_replace(' ', '', $opponent);

$timeInsert=$_POST[timeInsert];


$reponse1 = $bdd->query(" SELECT* FROM Team WHERE Name = '$teamName' ");
$num1 = $reponse1->rowCount();
while ($donnees = $reponse1->fetch())
{
	$idTeam = $donnees ['ID_Team'];
	$timeData = $donnees ['Time'];
}


$reponse2 = $bdd->query(' INSERT INTO Game(ID_Team, Date, Goals_For, Goals_Against, Opponent) 
						Values("'.$idTeam.'", "'.$matchDate.'", "'.$goalsUs.'", "'.$goalsTheme.'", "'.$opponent.'") ');


$reponse3 = $bdd->query(" UPDATE Team SET Time = '$timeInsert' WHERE Name = '$teamName' ");

$reponseVoting = $bdd->query(" UPDATE Team SET Voting = '1' WHERE Name = '$teamName' ");


$erreur = 1;

/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	
	"teamnameData":"'.$teamName.'",
	"dateData":"'.$matchDate.'",
	"timeData":"'.$timeInsert.'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();

?>