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
$pseudo=$_POST[pseudo];
$pseudo = str_replace(' ', '', $pseudo);


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Player WHERE Username = '$pseudo' ");
while ($donnees = $reponse1->fetch())
{
	$idData = $donnees ['ID_Player'];
	$nationData = $donnees ['Nation'];
	$clubData = $donnees ['Club'];
}

$num = $reponse1->rowCount();
//echo $num;
if($num!=1)
{
	$erreur=0;
}
else
{
	$erreur=1;

}

$reponse2 = $bdd->query(" SELECT Link FROM Nation WHERE Name ='$nationData' ");
while ($donnees = $reponse2->fetch())
{
	$nationlinkData = $donnees ['Link'];
}


$reponse3 = $bdd->query(" SELECT Link FROM Club WHERE Name ='$clubData' ");
while ($donnees = $reponse3->fetch())
{
	$clublinkData = $donnees ['Link'];
}

$reponse4 = $bdd->query(" SELECT* 
						FROM Player
						WHERE ID_Player = '$idData' 
						");
while ($donnees = $reponse4->fetch())
{
	$pseudoData = $donnees ['Username'];
	$passwordData = $donnees['Password'];
	$firstnameData = $donnees ['Firstname'];
	$lastnameData = $donnees['Lastname'];
	$ageData = $donnees['Age'];
	$mailData = $donnees ['Mail'];
	$positionData = $donnees ['Position'];
	$teamnumberData = $donnees ['Team_Number'];
	$numberMOTMData = $donnees ['ManOfTheMatch'];
	$numberDiabyData = $donnees ['Diaby_Trophy'];
	$numberFOTMData = $donnees ['FailOfTheMatch'];
	$numberRonaldinhoData = $donnees ['Ronaldinho_Trophy'];
	$numberDejongData = $donnees ['Dejong_Trophy'];
}


$reponse5 = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Pre_Assists), SUM(Penalties), SUM(Yellow_Card), SUM(Red_Card) 
						FROM Stats 
						WHERE ID_Player = '$idData' 
						");
while ($donnees = $reponse5->fetch())
{
	$goalsData = $donnees ['SUM(Goals)'];
	$assistsData = $donnees['SUM(Assists)'];
	$preassistsData = $donnees ['SUM(Pre_Assists)'];
	$penaltiesData = $donnees['SUM(Penalties)'];
	$yellowcardData = $donnees['SUM(Yellow_Card)'];
	$redcardData = $donnees ['SUM(Red_Card)'];
}


$reponse6 = $bdd->query(" SELECT* 
						FROM Team t 
						INNER JOIN Link_Player_Team l 
						ON t.ID_Team = l.ID_Team 
						WHERE l.ID_Player = '$idData' ");
	$num6 = $reponse6->rowCount();
	$i = 1;
	while ($donnees = $reponse6->fetch())
	{
		$teamData[$i] = $donnees ['Name'];
		$i = $i+1;
	}
	
	
$reponseJanuary = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
						FROM Stats
						WHERE ID_Player = '$idData' AND Date BETWEEN '20160101' AND '20160131' ");
while ($donnees = $reponseJanuary->fetch())
{
	$goalssum2016Data[1] = $donnees['SUM(Goals)'];
	$assistssum2016Data[1] = $donnees['SUM(Assists)'];
}

$reponseFebruary = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
						FROM Stats
						WHERE ID_Player = '$idData' AND Date BETWEEN '20160201' AND '20160231' ");
while ($donnees = $reponseFebruary->fetch())
{
	$goalssum2016Data[2] = $donnees['SUM(Goals)'];
	$assistssum2016Data[2] = $donnees['SUM(Assists)'];
}

$reponseMarch = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
						FROM Stats
						WHERE ID_Player = '$idData' AND Date BETWEEN '20160301' AND '20160331' ");
while ($donnees = $reponseMarch->fetch())
{
	$goalssum2016Data[3] = $donnees['SUM(Goals)'];
	$assistssum2016Data[3] = $donnees['SUM(Assists)'];
}

$reponseApril = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20160401' AND '20160431' ");
while ($donnees = $reponseApril->fetch())
{
        $goalssum2016Data[4] = $donnees['SUM(Goals)'];
        $assistssum2016Data[4] = $donnees['SUM(Assists)'];
}

$reponseMay = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20160501' AND '20160531' ");
while ($donnees = $reponseMay->fetch())
{
        $goalssum2016Data[5] = $donnees['SUM(Goals)'];
        $assistssum2016Data[5] = $donnees['SUM(Assists)'];
}

$reponseJune = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20160601' AND '20160631' ");
while ($donnees = $reponseJune->fetch())
{
        $goalssum2016Data[6] = $donnees['SUM(Goals)'];
        $assistssum2016Data[6] = $donnees['SUM(Assists)'];
}

$reponseJuly = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20160701' AND '20160731' ");
while ($donnees = $reponseJuly->fetch())
{
        $goalssum2016Data[7] = $donnees['SUM(Goals)'];
        $assistssum2016Data[7] = $donnees['SUM(Assists)'];
}
$reponseAugust = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20160801' AND '20160831' ");
while ($donnees = $reponseAugust->fetch())
{
        $goalssum2016Data[8] = $donnees['SUM(Goals)'];
        $assistssum2016Data[8] = $donnees['SUM(Assists)'];
}

$reponseSeptember = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20160901' AND '20160931' ");
while ($donnees = $reponseSeptember->fetch())
{
        $goalssum2016Data[9] = $donnees['SUM(Goals)'];
        $assistssum2016Data[9] = $donnees['SUM(Assists)'];
}

$reponseOctober = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20161001' AND '20161031' ");
while ($donnees = $reponseOctober->fetch())
{
        $goalssum2016Data[10] = $donnees['SUM(Goals)'];
        $assistssum2016Data[10] = $donnees['SUM(Assists)'];
}

$reponseNovember = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20161101' AND '20161131' ");
while ($donnees = $reponseNovember->fetch())
{
        $goalssum2016Data[11] = $donnees['SUM(Goals)'];
        $assistssum2016Data[11] = $donnees['SUM(Assists)'];
}

$reponseDecember = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
                        			FROM Stats
                        			WHERE ID_Player = '$idData' AND Date BETWEEN '20161201' AND '20161231' ");
while ($donnees = $reponseDecember->fetch())
{
        $goalssum2016Data[12] = $donnees['SUM(Goals)'];
        $assistssum2016Data[12] = $donnees['SUM(Assists)'];
}
   


/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	"num":'.$num.',
	
	"pseudoData":"'.$pseudo.'",
	"firstnameData":"'.$firstnameData.'", 
	"lastnameData":"'.$lastnameData.'", 
	"ageData":"'.$ageData.'", 
	"mailData":"'.$mailData.'",
	"positionData":"'.$positionData.'", 
	"nationlinkData":"'.$nationlinkData.'", 
	"clublinkData":"'.$clublinkData.'", 
	"nationData":"'.$nationData.'", 
	"clubData":"'.$clubData.'",
	"goalsData":"'.$goalsData.'",
	"assistsData":"'.$assistsData.'",
	"preassistsData":"'.$preassistsData.'",
	"penaltiesData":"'.$penaltiesData.'",
	"yellowcardData":"'.$yellowcardData.'",
	"teamnumberData":"'.$teamnumberData.'",
	"redcardData":"'.$redcardData.'",
	"numberDiaby":"'.$numberDiabyData.'",
	"numberMOTM":"'.$numberMOTMData.'",
	"numberFOTM":"'.$numberFOTMData.'",
	"numberRonaldinho":"'.$numberRonaldinhoData.'",
	"numberDejong":"'.$numberDejongData.'",
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
	"team25":"'.$teamData[25].'",
	"goalsSum2016_1":"'.$goalssum2016Data[1].'",
	"goalsSum2016_2":"'.$goalssum2016Data[2].'",
	"goalsSum2016_3":"'.$goalssum2016Data[3].'",
	"goalsSum2016_4":"'.$goalssum2016Data[4].'",
	"goalsSum2016_5":"'.$goalssum2016Data[5].'",
	"goalsSum2016_6":"'.$goalssum2016Data[6].'",
	"goalsSum2016_7":"'.$goalssum2016Data[7].'",
	"goalsSum2016_8":"'.$goalssum2016Data[8].'",
	"goalsSum2016_9":"'.$goalssum2016Data[9].'",
	"goalsSum2016_10":"'.$goalssum2016Data[10].'",
	"goalsSum2016_11":"'.$goalssum2016Data[11].'",
	"goalsSum2016_12":"'.$goalssum2016Data[12].'",
	"assistsSum2016_1":"'.$assistssum2016Data[1].'",
	"assistsSum2016_2":"'.$assistssum2016Data[2].'",
	"assistsSum2016_3":"'.$assistssum2016Data[3].'",
	"assistsSum2016_4":"'.$assistssum2016Data[4].'",
	"assistsSum2016_5":"'.$assistssum2016Data[5].'",
	"assistsSum2016_6":"'.$assistssum2016Data[6].'",
	"assistsSum2016_7":"'.$assistssum2016Data[7].'",
	"assistsSum2016_8":"'.$assistssum2016Data[8].'",
	"assistsSum2016_9":"'.$assistssum2016Data[9].'",
	"assistsSum2016_10":"'.$assistssum2016Data[10].'",
	"assistsSum2016_11":"'.$assistssum2016Data[11].'",
	"assistsSum2016_12":"'.$assistssum2016Data[12].'"

	}';

   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();
$reponse4->closeCursor();
$reponse5->closeCursor();
$reponse6->closeCursor();

?>