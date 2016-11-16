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


$reponse1 = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$idPlayer'");
$num1 = $reponse1->rowCount();
while ($donnees = $reponse1->fetch())
{
	$teamnumberData = $donnees ['Team_Number'];
}


$reponse2 = $bdd->query(" SELECT* FROM Team WHERE Name = '$teamName' ");
$num2 = $reponse2->rowCount();
while ($donnees = $reponse2->fetch())
{
	$idTeamData = $donnees ['ID_Team'];
}

if($num2 == 1){
	$erreur = 1;
}


/* Créer une requête associée à la base de données. */
$reponse3 = $bdd->query(" DELETE FROM Link_Player_Team WHERE ID_Player = '$idPlayer' AND ID_Team = '$idTeamData' ");

$reponse4 = $bdd->query(" SELECT COUNT(ID_Player) FROM Link_Player_Team WHERE ID_Player = '$idPlayer' ");
	while ($donnees = $reponse4->fetch())
	{
		$teamnumberData = $donnees ['COUNT(ID_Player)'];
	}


$reponse5 = $bdd->query(" SELECT* 
						FROM Team t 
						INNER JOIN Link_Player_Team l 
						ON t.ID_Team = l.ID_Team 
						WHERE l.ID_Player = '$idPlayer' ");
$num5 = $reponse5->rowCount();
$i = 1;
while ($donnees = $reponse5->fetch())
{
	$teamData[$i] = $donnees ['Name'];
	$i = $i+1;
}


/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	
	"teamnameData":"'.$teamName.'",
	"teamnumberData":"'.$teamnumberData.'",
	"team1":"'.$teamData[1].'",
	"team2":"'.$teamData[2].'",
	"team3":"'.$teamData[3].'",
	"team4":"'.$teamData[4].'",
	"team5":"'.$teamData[5].'",
	"team6":"'.$teamData[6].'",
	"team7":"'.$teamData[7].'",
	"team8":"'.$teamData[8].'",
	"team9":"'.$teamData[9].'",
	"team10":"'.$teamData[10].'",
	"team11":"'.$teamData[11].'",
	"team12":"'.$teamData[12].'",
	"team13":"'.$teamData[13].'",
	"team14":"'.$teamData[14].'",
	"team15":"'.$teamData[15].'",
	"team16":"'.$teamData[16].'",
	"team17":"'.$teamData[17].'",
	"team18":"'.$teamData[18].'",
	"team19":"'.$teamData[19].'",
	"team20":"'.$teamData[20].'",
	"team21":"'.$teamData[21].'",
	"team22":"'.$teamData[22].'",
	"team23":"'.$teamData[23].'",
	"team24":"'.$teamData[24].'",
	"team25":"'.$teamData[25].'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();

?>