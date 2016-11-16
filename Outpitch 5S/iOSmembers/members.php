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


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Team WHERE Name = '$teamName' ");

/* Gestion du nombre de lignes en réponse à la requête. */
$num1 = $reponse1->rowCount();
while ($donnees = $reponse1->fetch())
	{
		$idteamData = $donnees ['ID_Team'];
	}
	
	

if($num1==1)
{
	/* On a trouvé une équipe */
	$erreur=1;
}
else
{
	/* Pas trouvé le nom */
	$erreur=0;
}

if($erreur==1)
{
	$reponse2 = $bdd->query(" SELECT* 
						FROM Link_Player_Team l  
						INNER JOIN Team t 
						ON l.ID_Team = t.ID_Team 
						INNER JOIN Player p 
						ON l.ID_Player = p.ID_Player 
						WHERE l.ID_Team = '$idteamData' 
						");
						
	$num2 = $reponse2->rowCount();
	$i = 1;
	while ($donnees = $reponse2->fetch())
	{
		$memberData[$i] = $donnees ['Username'];
		$memberData[$i] = str_replace(' ', '', $memberData[$i]);
		$i = $i+1;
	}
}



/* Format JSON. */
echo '{  
	"erreur":'.$erreur.', 
	
	"teamName":"'.$teamName.'",
	"IDTeam":"'.$idteamData.'",
	"numrep":"'.$num2.'",
	"member1":"'.$memberData[1].'",
	"member2":"'.$memberData[2].'",
	"member3":"'.$memberData[3].'",
	"member4":"'.$memberData[4].'",
	"member5":"'.$memberData[5].'",
	"member6":"'.$memberData[6].'",
	"member7":"'.$memberData[7].'",
	"member8":"'.$memberData[8].'",
	"member9":"'.$memberData[9].'",
	"member10":"'.$memberData[10].'",
	"member11":"'.$memberData[11].'",
	"member12":"'.$memberData[12].'",
	"member13":"'.$memberData[13].'",
	"member14":"'.$memberData[14].'",
	"member15":"'.$memberData[15].'",
	"member16":"'.$memberData[16].'",
	"member17":"'.$memberData[17].'",
	"member18":"'.$memberData[18].'",
	"member19":"'.$memberData[19].'",
	"member20":"'.$memberData[20].'",
	"member21":"'.$memberData[21].'",
	"member22":"'.$memberData[22].'",
	"member23":"'.$memberData[23].'",
	"member24":"'.$memberData[24].'",
	"member25":"'.$memberData[25].'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();

?>