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
$email=$_POST[email];


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Player WHERE Mail ='$email' ");
while ($donnees = $reponse1->fetch())
{
	$idData = $donnees ['ID_Player'];
	$firstnameData = $donnees['Firstname'];
	$lastnameData = $donnees['Lastname'];
	$ageData = $donnees ['Age'];
	$passwordData = $donnees ['Password'];
}

/* Gestion du nombre de lignes en réponse à la requête. */
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


/* Format JSON. */
echo '{  
		"erreur":'.$erreur.', 
		"idData":"'.$idData.'", 
		"firstnameData":"'.$firstnameData.'", 
		"lastnameData":"'.$lastnameData.'", 
		"ageData":"'.$ageData.'", 
		"passwordData":"'.$passwordData.'" 
		}';

   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();

?>