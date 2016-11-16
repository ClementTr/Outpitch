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


$pseudo=$_POST[pseudo];
$pseudo = str_replace(' ', '', $pseudo);
$nation=$_POST[nation];
$nation = str_replace(' ', '', $nation);
$club=$_POST[club];
$club = str_replace(' ', '', $club);
$position=$_POST[position];
$position = str_replace(' ', '', $position);


$reponse1 = $bdd->query(" SELECT Link FROM Nation WHERE Name ='$nation' ");
while ($donnees = $reponse1->fetch())
{
	$nationlinkData = $donnees ['Link'];
}


$reponse2 = $bdd->query(" SELECT Link FROM Club WHERE Name ='$club' ");
while ($donnees = $reponse2->fetch())
{
	$clublinkData = $donnees ['Link'];
}



$reponse3 = $bdd->query(" SELECT* FROM Player WHERE Username ='$pseudo' ");
$num = $reponse3->rowCount();
while ($donnees = $reponse3->fetch())
{
	$idData = $donnees ['ID_Player'];
}

$reponse4 = $bdd->query(" SELECT COUNT(ID_Player) FROM Link_Player_Team WHERE ID_Player = '$idPlayer' ");
	while ($donnees = $reponse4->fetch())
	{
		$teamnumberData = $donnees ['COUNT(ID_Player)'];
	}

if($num!=1)
{
	// Pas pseudo unique
	$erreur=0;
}
else
{
	$erreur=1;
	$bdd->exec('UPDATE Player SET Nation = "'.$nation.'", 
								Club = "'.$club.'", 
								Position = "'.$position.'" WHERE Username = "'.$pseudo.'"');
}

/*if($erreur==1)
{
	$bdd->exec('UPDATE Player SET Nation = "'.$nation.'", 
								Club = "'.$club.'", 
								Position = "'.$position.'" WHERE Username = "'.$pseudo.'"');
}*/


$reponse4 = $bdd->query(" INSERT INTO Stats(ID_Player) VALUES ($idData) ");

$goalsData=0;
$assistsData=0;
$preassistsData=0;
$penaltiesData=0;
$yellowcardData=0;
$redcardData=0;
$pictureData="Jack.png";


/* Format JSON. */
echo '{  
		"erreur":'.$erreur.',
		"idData":"'.$idData.'",
		"pictureData":"'.$pictureData.'",  
		"pseudoData":"'.$pseudo.'", 
		"positionData":"'.$position.'",
		"clubData":"'.$club.'", 
		"nationData":"'.$nation.'", 
		"nationlinkData":"'.$nationlinkData.'", 
		"clublinkData":"'.$clublinkData.'",
		"goalsData":"'.$goalsData.'",
		"assistsData":"'.$assistsData.'",
		"preassistsData":"'.$preassistsData.'",
		"penaltiesData":"'.$penaltiesData.'",
		"yellowcardData":"'.$yellowcardData.'",
		"redcardData":"'.$redcardData.'" ,
		"teamnumberData":"'.$teamnumberData.'" 
		}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();
$reponse4->closeCursor();


?>