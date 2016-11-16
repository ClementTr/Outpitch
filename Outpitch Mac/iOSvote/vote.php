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

$trophyDiabyCandidate=$_POST[trophyDiabyCandidate];
$trophyDiabyCandidate = str_replace(' ', '', $trophyDiabyCandidate);

$trophyMOTMCandidate=$_POST[trophyMOTMCandidate];
$trophyMOTMCandidate = str_replace(' ', '', $trophyMOTMCandidate);

$trophyFOTMCandidate=$_POST[trophyFOTMCandidate];
$trophyFOTMCandidate = str_replace(' ', '', $trophyFOTMCandidate);

$trophyRonaldinhoCandidate=$_POST[trophyRonaldinhoCandidate];
$trophyRonaldinhoCandidate = str_replace(' ', '', $trophyRonaldinhoCandidate);

$trophyDejongCandidate=$_POST[trophyDejongCandidate];
$trophyDejongCandidate = str_replace(' ', '', $trophyDejongCandidate);


$reponse1 = $bdd->query(" SELECT * FROM Team WHERE Name = '$teamName' ");
while ($donnees = $reponse1->fetch())
{
	$idTeamData = $donnees ['ID_Team'];
}

$reponse2 = $bdd->query(" SELECT* FROM Link_Player_Team WHERE ID_Player = '$idPlayer' AND ID_Team = '$idTeamData' ");
$num2 = $reponse2->rowCount();
while ($donnees = $reponse2->fetch())
{
	$votedData = $donnees ['Voted'];
}


$reponseDiaby = $bdd->query(" SELECT * FROM Player WHERE Username = '$trophyDiabyCandidate' ");
while ($donnees = $reponseDiaby->fetch())
{
	$idDiabyCandidateData = $donnees ['ID_Player'];
}

$reponseMOTM = $bdd->query(" SELECT * FROM Player WHERE Username = '$trophyMOTMCandidate' ");
while ($donnees = $reponseMOTM->fetch())
{
	$idMOTMCandidateData = $donnees ['ID_Player'];
}

$reponseFOTM = $bdd->query(" SELECT * FROM Player WHERE Username = '$trophyFOTMCandidate' ");
while ($donnees = $reponseFOTM->fetch())
{
	$idFOTMCandidateData = $donnees ['ID_Player'];
}

$reponseRonaldinho = $bdd->query(" SELECT * FROM Player WHERE Username = '$trophyRonaldinhoCandidate' ");
while ($donnees = $reponseRonaldinho->fetch())
{
	$idRonaldinhoCandidateData = $donnees ['ID_Player'];
}

$reponseDejong = $bdd->query(" SELECT * FROM Player WHERE Username = '$trophyDejongCandidate' ");
while ($donnees = $reponseDejong->fetch())
{
	$idDejongCandidateData = $donnees ['ID_Player'];
}


$reponse4 = $bdd->query(" SELECT MAX(ID_Game) FROM Game WHERE ID_Team = '$idTeamData' ");
while ($donnees = $reponse4->fetch())
{
	$idGameData = $donnees ['MAX(ID_Game)'];
}

$reponsevoteDiaby = $bdd->query(" INSERT INTO Link_Vote(ID_Voter, ID_Candidate, ID_Team, ID_Trophy, ID_Game)
							VALUES('$idPlayer', '$idDiabyCandidateData', '$idTeamData', '1', '$idGameData')   
						");

$reponsevoteMOTM = $bdd->query(" INSERT INTO Link_Vote(ID_Voter, ID_Candidate, ID_Team, ID_Trophy, ID_Game)
							VALUES('$idPlayer', '$idMOTMCandidateData', '$idTeamData', '4', '$idGameData')   
						");

$reponsevoteFOTM = $bdd->query(" INSERT INTO Link_Vote(ID_Voter, ID_Candidate, ID_Team, ID_Trophy, ID_Game)
							VALUES('$idPlayer', '$idFOTMCandidateData', '$idTeamData', '5', '$idGameData')   
						");

$reponsevoteRonaldinho = $bdd->query(" INSERT INTO Link_Vote(ID_Voter, ID_Candidate, ID_Team, ID_Trophy, ID_Game)
							VALUES('$idPlayer', '$idRonaldinhoCandidateData', '$idTeamData', '3', '$idGameData')   
						");
						
$reponsevoteDejong = $bdd->query(" INSERT INTO Link_Vote(ID_Voter, ID_Candidate, ID_Team, ID_Trophy, ID_Game)
							VALUES('$idPlayer', '$idDejongCandidateData', '$idTeamData', '2', '$idGameData')   
						");
											

$reponse6 = $bdd->query("UPDATE Link_Player_Team SET Voted = '1' WHERE ID_Player = '$idPlayer' AND ID_Team = '$idTeamData' ");

$erreur = 1 ;
/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	
	"idTeamData":"'.$idTeamData.'",
	"votedData":"'.$votedData.'",
	"teamName":"'.$teamName.'"
	}';

   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();

?>