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
$timeAction=$_POST[timeAction];
$timeAction = str_replace(' ', '', $timeAction);
$timeInsert=$_POST[timeInsert];
//$timeInsert = str_replace(' ', '', $timeInsert);


$erreur = 1 ;

$reponse1 = $bdd->query(" SELECT* FROM Team WHERE Name = '$teamName' ");
$num1 = $reponse1->rowCount();
while ($donnees = $reponse1->fetch())
{
	$timeData = $donnees ['Time'];
	$idTeamData = $donnees ['ID_Team'];
}

$reponse2 = $bdd->query(" SELECT* FROM Link_Player_Team WHERE ID_Player = '$idPlayer' AND ID_Team = '$idTeamData' ");
$num2 = $reponse2->rowCount();
while ($donnees = $reponse2->fetch())
{
	$votedData = $donnees ['Voted'];
}


if($timeAction == "1"){
	$reponse3 = $bdd->query(" SELECT MAX(ID_Game) FROM Link_Vote WHERE ID_Team = '$idTeamData' ");
	while ($donnees = $reponse3->fetch())
	{
		$maxidgameData = $donnees ['MAX(ID_Game)'];
	}



	####################################################################################################################################
	/* DIABY */
	$reponseWinnerDiaby = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$maxidgameData' AND ID_Team = '$idTeamData' AND ID_Trophy = '1'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numDiaby = $reponseWinnerDiaby->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerDiaby->fetch())
	{
		$winnerDiaby[$i] = $donnees ['ID_Candidate'];
		$winnerDiaby[$i] = str_replace(' ', '', $winnerDiaby[$i]);
		$egaliteDiaby[$i] = $donnees ['sumVote'];
		$i = $i+1;
	}if($egaliteDiaby[0] != $egaliteDiaby[1]){
		$reponseSetDiaby = $bdd->query(" UPDATE Player SET Diaby_Trophy = Diaby_Trophy + 1 WHERE ID_Player = '$winnerDiaby[0]' ");
	}else{
		$winnerDiaby[0]="egalite";
		$winnerDiaby[1]="egalite";
	}

	
	####################################################################################################################################
	/* MOTM */
	$reponseWinnerMOTM = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$maxidgameData' AND ID_Team = '$idTeamData' AND ID_Trophy = '4'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numMOTM= $reponseWinnerMOTM->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerMOTM->fetch())
	{
		$winnerMOTM[$i] = $donnees ['ID_Candidate'];
		$egaliteMOTM[$i] = $donnees ['sumVote'];
		$winnerMOTM[$i] = str_replace(' ', '', $winnerMOTM[$i]);
		$i = $i+1;
	}if($egaliteMOTM[0] != $egaliteMOTM[1]){
		$reponseSetMOTM = $bdd->query(" UPDATE Player SET ManOfTheMatch = ManOfTheMatch + 1 WHERE ID_Player = '$winnerMOTM[0]' ");
	}else{
		$winnerMOTM[0]="egalite";
		$winnerMOTM[1]="egalite";
	}


	####################################################################################################################################
	/* FOTM */
	$reponseWinnerFOTM = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$maxidgameData' AND ID_Team = '$idTeamData' AND ID_Trophy = '5'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numFOTM = $reponseWinnerFOTM->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerFOTM->fetch())
	{
		$winnerFOTM[$i] = $donnees ['ID_Candidate'];
		$egaliteFOTM[$i] = $donnees ['sumVote'];
		$winnerFOTM[$i] = str_replace(' ', '', $winnerFOTM[$i]);
		$i = $i+1;
	}if($egaliteFOTM[0] != $egaliteFOTM[1]){
		$reponseSetFOTM = $bdd->query(" UPDATE Player SET FailOfTheMatch = FailOfTheMatch + 1 WHERE ID_Player = '$winnerFOTM[0]' ");
	}else{
		$winnerFOTM[0]="egalite";
		$winnerFOTM[1]="egalite";
	}
	

	####################################################################################################################################
	/* Ronaldinho */
	$reponseWinnerRonaldinho = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$maxidgameData' AND ID_Team = '$idTeamData' AND ID_Trophy = '3'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numRonalinho = $reponseWinnerRonaldinho->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerRonaldinho->fetch())
	{
		$winnerRonaldinho[$i] = $donnees ['ID_Candidate'];
		$egaliteRonaldinho[$i] = $donnees ['sumVote'];
		$winnerRonaldinho[$i] = str_replace(' ', '', $winnerRonaldinho[$i]);
		$i = $i+1;
	}if($egaliteRonaldinho[0] != $egaliteRonaldinho[1]){
		$reponseSetRonaldinho = $bdd->query(" UPDATE Player SET Ronaldinho_Trophy = Ronaldinho_Trophy + 1 WHERE ID_Player = '$winnerRonaldinho[0]' ");
	}else{
		$winnerRonaldinho[0]="egalite";
		$winnerRonaldinho[1]="egalite";
	}
	
	####################################################################################################################################
	/* Dejong */
	$reponseWinnerDejong = $bdd->query(" SELECT COUNT(ID_Candidate) AS sumVote, ID_Candidate 
								FROM Link_Vote 
								WHERE ID_Game = '$maxidgameData' AND ID_Team = '$idTeamData' AND ID_Trophy = '2'
								GROUP BY ID_Candidate 
								ORDER BY sumVote DESC
							");
	$numDejong = $reponseWinnerDejong->rowCount();
	$i = 0;
	while ($donnees = $reponseWinnerDejong->fetch())
	{
		$winnerDejong[$i] = $donnees ['ID_Candidate'];
		$egaliteDejong[$i] = $donnees ['sumVote'];
		$winnerDejong[$i] = str_replace(' ', '', $winnerDejong[$i]);
		$i = $i+1;
	}if($egaliteDejong[0] != $egaliteDejong[1]){
		$reponseSetDejong = $bdd->query(" UPDATE Player SET Dejong_Trophy = Dejong_Trophy + 1 WHERE ID_Player = '$winnerDejong[0]' ");
	}else{
		$winnerDejong[0]="egalite";
		$winnerDejong[1]="egalite";
	}
	
	
	####################################################################################################################################

	$reponse4 = $bdd->query(" UPDATE Link_Player_Team SET Voted = '0' WHERE ID_Team = '$idTeamData' ");
	
	$reponse5 = $bdd->query(" UPDATE Team SET Time = 'OFF' WHERE Name = '$teamName' ");
	
	$reponse6 = $bdd->query("UPDATE Link_Player_Team SET Voted = '0' WHERE ID_Player = '$idPlayer' AND ID_Team = '$idTeamData' ");
}


$reponseAllNumber = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$idPlayer' ");
while ($donnees = $reponseAllNumber->fetch())
{
	$numberMOTMData = $donnees ['ManOfTheMatch'];
	$numberDiabyData = $donnees ['Diaby_Trophy'];
	$numberFOTMData = $donnees ['FailOfTheMatch'];
	$numberRonaldinhoData = $donnees ['Ronaldinho_Trophy'];
	$numberDejongData = $donnees ['Dejong_Trophy'];
}
	
	

if($timeAction == "2"){
	$reponse6 = $bdd->query(" UPDATE Team SET Time = '$timeInsert' WHERE Name = '$teamName' ");
}

/*$reponseEverybody = $bdd->query(" SELECT COUNT(Voted) FROM Link_Player_Team WHERE ID_Team = '$idTeamData' ");
while ($donnees = $reponseEverybody->fetch())
{
	$Everybody = $donnees ['COUNT(Voted)'];
}

$reponseGuysWhoVoted = $bdd->query(" SELECT COUNT(Voted) FROM Link_Player_Team 
									WHERE ID_Team = '$idTeamData' AND Voted = 1
									");
while ($donnees = $reponseGuysWhoVoted->fetch())
{
	$GuysWhoVoted = $donnees ['COUNT(Voted)'];
}

if($GuysWhoVoted == $Everybody){
	$timeData = "everybodydidit";
}*/

/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	
	"maxidgameData":"'.$maxidgameData.'",
	"numberDiaby":"'.$numberDiabyData.'",
	"numberMOTM":"'.$numberMOTMData.'",
	"numberFOTM":"'.$numberFOTMData.'",
	"numberRonaldinho":"'.$numberRonaldinhoData.'",
	"numberDejong":"'.$numberDejongData.'",
	"timeAction":"'.$timeAction.'",
	"winnerDiaby":"'.$winnerDiaby[0].'",
	"secondDiaby":"'.$winnerDiaby[1].'",
	"winnerMOTM":"'.$winnerMOTM[0].'",
	"secondMOTM":"'.$winnerMOTM[1].'",
	"winnerFOTM":"'.$winnerFOTM[0].'",
	"secondFOTM":"'.$winnerFOTM[1].'",
	"winnerRonaldinho":"'.$winnerRonaldinho[0].'",
	"secondRonaldinho":"'.$winnerRonaldinho[1].'",
	"winnerDejong":"'.$winnerDejong[0].'",
	"secondDejong":"'.$winnerDejong[1].'",
	"idTeamData":"'.$idTeamData.'",
	"timeData":"'.$timeData.'",
	"teamnameData":"'.$teamName.'",
	"votedData":"'.$votedData.'"
	}';
	

   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();
$reponse4->closeCursor();
$reponse5->closeCursor();
$reponse6->closeCursor();

?>