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

$id=$_POST[id];

$firstnameData=$_POST[firstname];
$lastnameData=$_POST[lastname];
$ageData=$_POST[age];
$emailData=$_POST[email];
$pseudoData=$_POST[pseudo];
$passwordData=$_POST[mdp];
$nationData=$_POST[nation];
$clubData=$_POST[club];
$positionData=$_POST[position];



$reponse1 = $bdd->query(" SELECT Link FROM Nation WHERE Name ='$nationData' ");
while ($donnees = $reponse1->fetch())
{
	$nationlinkData = $donnees ['Link'];
}


$reponse2 = $bdd->query(" SELECT Link FROM Club WHERE Name ='$clubData' ");
while ($donnees = $reponse2->fetch())
{
	$clublinkData = $donnees ['Link'];
}



$reponse3 = $bdd->query(" SELECT* FROM Player WHERE ID_Player ='$id' ");
$num = $reponse3->rowCount();

if($num!=1)
{
	$erreur=0;
}
else
{
	$erreur=1;
}

if($erreur==1)
{
	$bdd->exec('UPDATE Player SET Firstname = "'.$firstnameData.'", 
								Lastname = "'.$lastnameData.'", 
								Age = "'.$ageData.'", 
								Mail = "'.$emailData.'", 
								Nation = "'.$nationData.'", 
								Club = "'.$clubData.'", 
								Position = "'.$positionData.'", 
								Password = "'.$passwordData.'", 
								Username = "'.$pseudoData.'" WHERE ID_Player = "'.$id.'"');
}


/* Format JSON. */
echo '{  
		"erreur":'.$erreur.', 
		"pseudoData":"'.$pseudoData.'", 
		"passwordData":"'.$passwordData.'", 
		"firstnameData":"'.$firstnameData.'", 
		"lastnameData":"'.$lastnameData.'", 
		"ageData":"'.$ageData.'", 
		"emailData":"'.$emailData.'", 
		"positionData":"'.$positionData.'",
		"nationlinkData":"'.$nationlinkData.'", 
		"clublinkData":"'.$clublinkData.'",  
		"nationData":"'.$nationData.'", 
		"clubData":"'.$clubData.'"  
		}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();

?>