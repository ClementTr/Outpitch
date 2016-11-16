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


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Team WHERE Name = '$teamName' ");
while ($donnees = $reponse1->fetch())
{
	$idTeamData = $donnees ['ID_Team'];
}

$reponse2 = $bdd->query(" SELECT ID_Game FROM Game WHERE ID_Team = '$idTeamData' ORDER BY ID_Game DESC ");
$i = 0;
while($donnees = $reponse2->fetch())
{
	$lastgame[$i] = $donnees ['ID_Game'];
	$lastgame[$i] = str_replace(' ', '', $lastgame[$i]);
	$i = $i + 1;
}

	####################################################  LAST GAME  ######################################################
	/* DIABY */
	$reponseWinnerDiaby = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$lastgame[0]' AND ID_Team = '$idTeamData' AND ID_Trophy = '1'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numDiaby = $reponseWinnerDiaby->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerDiaby->fetch())
	{
		$LastWinnerDiaby[$i] = $donnees ['ID_Candidate'];
		$LastWinnerDiaby[$i] = str_replace(' ', '', $LastWinnerDiaby[$i]);
		$egaliteLastDiaby[$i] = $donnees ['sumVote'];
		$i = $i+1;
	}
	if($numDiaby == 0){
		$erreur = 0;
	}
	if($egaliteLastDiaby[0] == $egaliteLastDiaby[1]){
		$LastWinnerDiaby[0]="draw";
		$LastWinnerDiaby[1]="draw";
	}

	
	####################################################################################################################################
	/* MOTM */
	$reponseWinnerMOTM = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$lastgame[0]' AND ID_Team = '$idTeamData' AND ID_Trophy = '4'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numMOTM= $reponseWinnerMOTM->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerMOTM->fetch())
	{
		$LastWinnerMOTM[$i] = $donnees ['ID_Candidate'];
		$egaliteMOTM[$i] = $donnees ['sumVote'];
		$LastWinnerMOTM[$i] = str_replace(' ', '', $LastWinnerMOTM[$i]);
		$i = $i+1;
	}
	if($numMOTM == 0){
		$erreur = 0;
	}
	
	if($egaliteMOTM[0] == $egaliteMOTM[1]){
		$LastWinnerMOTM[0]="draw";
		$LastWinnerMOTM[1]="draw";
	}


	####################################################################################################################################
	/* FOTM */
	$reponseWinnerFOTM = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$lastgame[0]' AND ID_Team = '$idTeamData' AND ID_Trophy = '5'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numFOTM = $reponseWinnerFOTM->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerFOTM->fetch())
	{
		$LastWinnerFOTM[$i] = $donnees ['ID_Candidate'];
		$egaliteFOTM[$i] = $donnees ['sumVote'];
		$LastWinnerFOTM[$i] = str_replace(' ', '', $LastWinnerFOTM[$i]);
		$i = $i+1;
	}
	if($numFOTM == 0){
		$erreur = 0;
	}
	if($egaliteFOTM[0] == $egaliteFOTM[1]){
		$LastWinnerFOTM[0]="draw";
		$LastWinnerFOTM[1]="draw";
	}
	

	####################################################################################################################################
	/* Ronaldinho */
	$reponseWinnerRonaldinho = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$lastgame[0]' AND ID_Team = '$idTeamData' AND ID_Trophy = '3'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numRonalinho = $reponseWinnerRonaldinho->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerRonaldinho->fetch())
	{
		$LastWinnerRonaldinho[$i] = $donnees ['ID_Candidate'];
		$egaliteRonaldinho[$i] = $donnees ['sumVote'];
		$LastWinnerRonaldinho[$i] = str_replace(' ', '', $LastWinnerRonaldinho[$i]);
		$i = $i+1;
	}
	if($numRonalinho == 0){
		$erreur = 0;
	}
	if($egaliteRonaldinho[0] == $egaliteRonaldinho[1]){
		$LastWinnerRonaldinho[0]="draw";
		$LastWinnerRonaldinho[1]="draw";
	}
	
	####################################################################################################################################
	/* Dejong */
	$reponseWinnerDejong = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$lastgame[0]' AND ID_Team = '$idTeamData' AND ID_Trophy = '2'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numDejong = $reponseWinnerDejong->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerDejong->fetch())
	{
		$LastWinnerDejong[$i] = $donnees ['ID_Candidate'];
		$egaliteDejong[$i] = $donnees ['sumVote'];
		$LastWinnerDejong[$i] = str_replace(' ', '', $LastWinnerDejong[$i]);
		$i = $i+1;
	}
	if($numDejong == 0){
		$erreur = 0;
	}
	if($egaliteDejong[0] == $egaliteDejong[1]){
		$LastWinnerDejong[0]="draw";
		$LastWinnerDejong[1]="draw";
	}



	



$reponse3 = $bdd->query(" SELECT* FROM Game WHERE ID_Game = '$lastgame[1]' ");
while ($donnees = $reponse3->fetch())
{
	$penultimateOpponent = $donnees ['Opponent'];
	$penultimateDate = $donnees ['Date'];
	$penultimateGoalsfor = $donnees ['Goals_For'];
	$penultimateGoalsagainst = $donnees ['Goals_Against'];
}

$reponse4 = $bdd->query(" SELECT* FROM Game WHERE ID_Game = '$lastgame[0]' ");
while ($donnees = $reponse4->fetch())
{
	$lastOpponent = $donnees ['Opponent'];
	$lastDate = $donnees ['Date'];
	$lastGoalsfor = $donnees ['Goals_For'];
	$lastGoalsagainst = $donnees ['Goals_Against'];
}



if($LastWinnerDiaby[0] != "draw")
{
	$reponseLastDiaby = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$LastWinnerDiaby[0]' ");
	while ($donnees = $reponseLastDiaby->fetch())
	{
		$LastDiabyUsername = $donnees ['Username'];
	}
}else{
	$LastDiabyUsername = "draw" ;
}
$LastDiabyUsername = str_replace(' ', '', $LastDiabyUsername);




if($LastWinnerRonaldinho[0] != "draw")
{
	$reponseWinnerRonaldinho = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$LastWinnerRonaldinho[0]' ");
	while ($donnees = $reponseWinnerRonaldinho->fetch())
	{
		$LastRonaldinhoUsername = $donnees ['Username'];
		$LastRonaldinhoUsername = str_replace(' ', '', $LastRonaldinhoUsername);
	}
}else{
	$LastRonaldinhoUsername = "draw" ;
}
$LastRonaldinhoUsername = str_replace(' ', '', $LastRonaldinhoUsername);



if($LastWinnerDejong[0] != "draw")
{
	$reponseWinnerDejong = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$LastWinnerDejong[0]' ");
	while ($donnees = $reponseWinnerDejong->fetch())
	{
		$LastDejongUsername = $donnees ['Username'];
		$LastDejongUsername = str_replace(' ', '', $LastDejongUsername);
	}
}else{
	$LastDejongUsername = "draw" ;
}
$LastDejongUsername = str_replace(' ', '', $LastDejongUsername);



if($LastWinnerMOTM[0] != "draw")
{
	$reponseLastMOTM = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$LastWinnerMOTM[0]' ");
	while ($donnees = $reponseLastMOTM->fetch())
	{
		$LastMOTMUsername = $donnees ['Username'];
		$LastMOTMUsername = str_replace(' ', '', $LastMOTMUsername);
	}
}else{
	$LastMOTMUsername = "draw" ;
}
$LastMOTMUsername = str_replace(' ', '', $LastMOTMUsername);




if($LastWinnerFOTM[0] != "draw")
{
	$reponseLastFOTM = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$LastWinnerFOTM[0]' ");
	while ($donnees = $reponseLastFOTM->fetch())
	{
		$LastFOTMUsername = $donnees ['Username'];
		$LastFOTMUsername = str_replace(' ', '', $LastFOTMUsername);
	}
}else{
	$LastFOTMUsername = "draw" ;
}
$LastFOTMUsername = str_replace(' ', '', $LastFOTMUsername);




$reponseVoting = $bdd->query(" SELECT* FROM Team WHERE ID_Team = '$idTeamData' ");
while ($donnees = $reponseVoting->fetch())
	{
		$Voting = $donnees ['Voting'];
		$Voting = str_replace(' ', '', $Voting);
	}

$erreur = 1 ;

/* Format JSON. */
echo '{  
	"erreur":'.$erreur.',
	"Voting":'.$Voting.',
	
	"LastWinnerDiaby":"'.$LastDiabyUsername.'",
	"LastWinnerRonaldinho":"'.$LastRonaldinhoUsername.'",
	"LastWinnerDejong":"'.$LastDejongUsername.'",
	"LastWinnerMOTM":"'.$LastMOTMUsername.'",
	"LastWinnerFOTM":"'.$LastFOTMUsername.'",
	
	"lastOpponent":"'.$lastOpponent.'",
	"penultimateOpponent":"'.$penultimateOpponent.'",
	"lastDate":"'.$lastDate.'",
	"penultimateDate":"'.$penultimateDate.'",
	"lastGoalsfor":"'.$lastGoalsfor.'",
	"penultimateGoalsfor":"'.$penultimateGoalsfor.'",
	"lastGoalsagainst":"'.$lastGoalsagainst.'",
	"penultimateGoalsagainst":"'.$penultimateGoalsagainst.'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();

?>