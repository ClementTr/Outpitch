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


$firstname=$_POST[firstname];
$firstname = str_replace(' ', '', $firstname);
$lastname=$_POST[lastname];
$lastname = str_replace(' ', '', $lastname);
$age=$_POST[age];
$age = str_replace(' ', '', $age);
$email=$_POST[email];
$email = str_replace(' ', '', $email);
$pseudo=$_POST[pseudo];
$pseudo = str_replace(' ', '', $pseudo);
$mdp=$_POST[mdp];
$mdp = str_replace(' ', '', $mdp);



/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Player WHERE Mail = '$email' ");
$reponse2 = $bdd->query(" SELECT* FROM Player WHERE Username = '$pseudo' ");


/* Gestion du nombre de lignes en réponse à la requête. */
$num1 = $reponse1->rowCount();
$num2 = $reponse2->rowCount();


if($num1!=0)
{
	/* Email existe déjà */
	$erreur=0;
}
elseif($num2!=0)
{
	/* Pseudo existe déjà */
	$erreur=1;
}
else
{
	$erreur=2;
	$bdd->exec('INSERT INTO Player(Firstname, Lastname, Age, Mail, Username, Password) 
				VALUES("'.$firstname.'", "'.$lastname.'", "'.$age.'", "'.$email.'", "'.$pseudo.'", "'.$mdp.'")');
}

/*if($erreur==2)
{
	$bdd->exec('INSERT INTO Player(Firstname, Lastname, Age, Mail, Username, Password) 
				VALUES("'.$firstname.'", "'.$lastname.'", "'.$age.'", "'.$email.'", "'.$pseudo.'", "'.$mdp.'")');
}*/



/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	
	"firstnameData":"'.$firstname.'", 
	"pseudo":"'.$pseudo.'", 
	"lastnameData":"'.$lastname.'", 
	"ageData":"'.$age.'", 
	"passwordData":"'.$mdp.'", 
	"mailData":"'.$email.'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();

?>