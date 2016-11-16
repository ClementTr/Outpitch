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

$name=$_POST[nameTeam];
$name = str_replace(' ', '', $name);

$password=$_POST[mdp];
$password = str_replace(' ', '', $password);

$confirmation=$_POST[confirmation];
$confirmation = str_replace(' ', '', $confirmation);

$abbreviation=$_POST[abbreviation];
$abbreviation = str_replace(' ', '', $abbreviation);

$league=$_POST[league];
$league = str_replace(' ', '', $league);

$colorData=$_POST[colorData];
$colorData = str_replace(' ', '', $colorData);


/* Créer une requête associée à la base de données. */
$reponse1 = $bdd->query(" SELECT* FROM Team WHERE Name = '$name' ");
$num1 = $reponse1->rowCount();


if($num1!=0)
{
	/* Ce nom existe déjà */
	$erreur=0;
}
else
{
	$erreur=1;
}

if($erreur==1)
{
	$bdd->exec('INSERT INTO Team(Name, Password, Abbreviation, League, Color) 
				VALUES("'.$name.'","'.$password.'","'.$abbreviation.'","'.$league.'","'.$colorData.'")
				');
	
	
	$reponse2 = $bdd->query(" SELECT* FROM Team WHERE Name = '$name' AND Password = '$password' ");
	$num2 = $reponse2->rowCount();
	while ($donnees = $reponse2->fetch())
	{
		$idteamData = $donnees ['ID_Team'];
	}
				
	$bdd->exec('INSERT INTO Link_Player_Team(ID_Player, ID_Team) 
				VALUES("'.$idPlayer.'","'.$idteamData.'")
				');
	
	$reponse3 = $bdd->query(" SELECT* 
						FROM Team t 
						INNER JOIN Link_Player_Team l 
						ON t.ID_Team = l.ID_Team 
						WHERE l.ID_Player = '$idPlayer' ");
	$num3 = $reponse3->rowCount();
	$i = 1;
	while ($donnees = $reponse3->fetch())
	{
		$teamData[$i] = $donnees ['Name'];
		$i = $i+1;
	}
	
	$reponse4 = $bdd->query(" SELECT COUNT(ID_Player) FROM Link_Player_Team WHERE ID_Player = '$idPlayer' ");
	while ($donnees = $reponse4->fetch())
	{
		$teamnumberData = $donnees ['COUNT(ID_Player)'];
	}
	//$continue=1;
}

/*if($continue==1)
{
	$reponse2 = $bdd->query(" SELECT* FROM Team WHERE Name = '$name' AND Password = '$password' ");
	$num2 = $reponse2->rowCount();
	while ($donnees = $reponse2->fetch())
	{
		$idteamData = $donnees ['ID_Team'];
	}
				
	$bdd->exec('INSERT INTO Link_Player_Team(ID_Player, ID_Team) 
				VALUES("'.$idPlayer.'","'.$idteamData.'")
				');
	
	$reponse3 = $bdd->query(" SELECT* 
						FROM Team t 
						INNER JOIN Link_Player_Team l 
						ON t.ID_Team = l.ID_Team 
						WHERE l.ID_Player = '$idPlayer' ");
	$num3 = $reponse3->rowCount();
	$i = 1;
	while ($donnees = $reponse3->fetch())
	{
		$teamData[$i] = $donnees ['Name'];
		$i = $i+1;
	}
	
	$reponse4 = $bdd->query(" SELECT* FROM Player WHERE ID_Player = '$idPlayer' ");
	while ($donnees = $reponse4->fetch())
	{
		$teamnumberData = $donnees ['Team_Number'];
	}
	$teamnumberData = $teamnumberData + 1;
	
	$reponse5 = $bdd->query(" UPDATE Player SET Team_Number = '$teamnumberData' WHERE ID_Player ='$idPlayer' ");
}*/



/* Format JSON. */
echo '{  
	"erreur":'.$erreur.',
	 
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
	"teamnameData":"'.$name.'", 
	"teamnumberData":"'.$teamnumberData.'", 
	"league":"'.$league.'", 
	"abbreviation":"'.$abbreviation.'", 
	"passwordData":"'.$password.'"
	}';


   
/* Terminer le traitement de la requête. */
$reponse1->closeCursor();
$reponse2->closeCursor();
$reponse3->closeCursor();
$reponse4->closeCursor();
$reponse5->closeCursor();

?>