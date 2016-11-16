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

$goalsinData=$_POST[goals];
$goalsinData = str_replace(' ', '', $goalsinData);

$assistsinData=$_POST[assists];
$assistsinData = str_replace(' ', '', $assistsinData);

$penaltiesinData=$_POST[penalties];
$penaltiesinData = str_replace(' ', '', $penaltiesinData);

$preassistsinData=$_POST[preassists];
$preassistsinData = str_replace(' ', '', $preassistsinData);

$yellowcardinData=$_POST[yellowcard];
$yellowcardinData = str_replace(' ', '', $yellowcardinData);

$redcardinData=$_POST[redcard];
$redcardinData = str_replace(' ', '', $redcardinData);

$dateinData=$_POST[datematch];
$dateinData = str_replace(' ', '', $dateinData);

$idData=$_POST[idPlayer];
$idData = str_replace(' ', '', $idData);



$erreur=1;
$reponse1 = $bdd->query(" INSERT INTO Stats (Goals, Assists, Penalties, Pre_Assists, Yellow_Card, Red_Card, ID_Player, Date) 
							VALUES ('$goalsinData', '$assistsinData', '$penaltiesinData', '$preassistsinData', '$yellowcardinData', '$redcardinData', '$idData', STR_TO_DATE('$dateinData', '%m-%d-%Y') ) 
							" );


$reponse2 = $bdd->query(" SELECT SUM(Goals), SUM(Assists), SUM(Penalties), SUM(Pre_Assists), SUM(Yellow_Card), SUM(Red_Card)
						FROM Stats
						WHERE ID_Player = '$idData' ");
while ($donnees = $reponse2->fetch())
{
	$goalssumData = $donnees ['SUM(Goals)'];
	$assistssumData = $donnees ['SUM(Assists)'];
	$penaltiessumData = $donnees ['SUM(Penalties)'];
	$preassistssumData = $donnees ['SUM(Pre_Assists)'];
	$yellowcardsumData = $donnees ['SUM(Yellow_Card)'];
	$redcardsumData = $donnees ['SUM(Red_Card)'];
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
	"dateData":"'.$dateinData.'",
	"pseudoData":"'.$pseudo.'",
	"goalsData":"'.$goalssumData.'",
	"assistsData":"'.$assistssumData.'",
	"penaltiesData":"'.$penaltiessumData.'",
	"preassistsData":"'.$preassistssumData.'",
	"yellowcardData":"'.$yellowcardsumData.'",
	"redcardData":"'.$redcardsumData.'",
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
$reponseJanuary->closeCursor();
$reponseFebruary->closeCursor();
$reponseMarch->closeCursor();
$reponseApril->closeCursor();
$reponseMay->closeCursor();
$reponseJune->closeCursor();
$reponseJuly->closeCursor();
$reponseAugust->closeCursor();
$reponseSeptember->closeCursor();
$reponseOctober->closeCursor();
$reponseNovember->closeCursor();
$reponseDecember->closeCursor();
//$reponseJanuary->closeCursor();

?>