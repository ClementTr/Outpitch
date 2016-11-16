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
$teamName=$_POST[teamName];
$teamName = str_replace(' ', '', $teamName);


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Team WHERE Name = '$teamName' ");
while ($donnees = $reponse1->fetch())
{
	$idteamData = $donnees ['ID_Team'];
	$timeData = $donnees ['Time'];
	$leagueData = $donnees ['League'];
	$abbreviationData = $donnees ['Abbreviation'];
	$colorData = $donnees ['Color'];
}

$reponse2 = $bdd->query(" SELECT* FROM Link_Player_Team WHERE ID_Team = '$idteamData' AND ID_Player = '$idPlayer' ");
while ($donnees = $reponse2->fetch())
{
	$votedData = $donnees ['Voted'];
}

$reponseEverybody = $bdd->query(" SELECT COUNT(Voted) FROM Link_Player_Team WHERE ID_Team = '$idteamData' ");
while ($donnees = $reponseEverybody->fetch())
{
	$Everybody = $donnees ['COUNT(Voted)'];
}

$reponseGuysWhoVoted = $bdd->query(" SELECT COUNT(Voted) FROM Link_Player_Team 
									WHERE ID_Team = '$idteamData' AND Voted = 1
									");
while ($donnees = $reponseGuysWhoVoted->fetch())
{
	$GuysWhoVoted = $donnees ['COUNT(Voted)'];
}



if($GuysWhoVoted == $Everybody){
	$EverybodyVoted = "1";
	$reponseVoting = $bdd->query(" UPDATE Team SET Voting = '0' WHERE ID_Team = '$idteamData' ");
}else{
	$EverybodyVoted = "0";
}

if($colorData=="Red"){
	$emblem = "Red_Emblem.png";
	
}else if($colorData=="Blue"){
	$emblem = "Blue_Emblem.png";
	
}else if($colorData=="Azure"){
	$emblem = "Azure_Emblem.png";
	
}else if($colorData=="Black"){
	$emblem = "Black_Emblem.png";
	
}else if($colorData=="Green"){
	$emblem = "Green_Emblem.png";
	
}else if($colorData=="Yellow"){
	$emblem = "Yellow_Emblem.png";
	
}else if($colorData=="White"){
	$emblem = "White_Emblem.png";
}

$erreur = 1;

/* Format JSON. */
echo '{  
	"erreur":'.$erreur.',
	 
	"votedData":"'.$votedData.'",
	"leagueData":"'.$leagueData.'",
	"abbreviationData":"'.$abbreviationData.'",
	"colorData":"'.$colorData.'",
	"emblemData":"'.$emblem.'",
	"votedData":"'.$votedData.'",
	"Everybody":"'.$Everybody.'",
	"GuysWhoVoted":"'.$GuysWhoVoted.'",
	"EverybodyVoted":"'.$EverybodyVoted.'",
	"timeData":"'.$timeData.'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();
$reponse4->closeCursor();
$reponse5->closeCursor();

?>