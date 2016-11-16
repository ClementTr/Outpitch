//
//  Team.swift
//  Outpitch
//
//  Created by Clément Tailleur on 14/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Team: UIViewController {
    
    @IBOutlet weak var IV_EMBLEM: UIImageView!
    @IBOutlet weak var LBL_TITLE: UINavigationItem!
    @IBOutlet weak var IV_ISVOTED: UIImageView!
    @IBOutlet weak var LBL_NEW_VOTE: UILabel!
    @IBOutlet weak var LBL_ABBREVIATION: UILabel!
    @IBOutlet weak var LBL_LEAGUE: UILabel!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var cellule = String()
    var Alert = Int()
    var teamnameJSON = NSString()
    var restTime = String()
    var dateStringEnd = String()
    
    var opponent = String()
    var date = String()
    var goalsfor = String()
    var goalsagainst = String()
    
    var winnerDiaby = String()
    var winnerDejong = String()
    var winnerRonaldinho = String()
    var winnerMOTM = String()
    var winnerFOTM = String()
    
    var leagueJSON = String()
    var abbreviationJSON = String()
    var colorJSON = String()
    var everybodyVoted:Int = 0
    
    /*
     Hide back button in order to manage ourself the navigation
     Replace it by a button tha we manage.
     The title of the window will have for text the cellule value of wiche one you tape just before
     cellule is teamName 
     Then each time the view appear,, we check if you voted or not using isvoted(cellule = team name) in view didload and viewWillAppear.
     isVoted check if Voted value in database is 0 (you don't vote) or 1 (you vote) in 
     Link_Player_Team where idTeam = teamName and idPlayer = iduser
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Teams", style: UIBarButtonItemStyle.Bordered, target: self, action: #selector(Team.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        LBL_TITLE.title = cellule
        isVoted(cellule)
        NSLog("You enter in you team named : %@", cellule)
        lookforMembers()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        isVoted(cellule)
        if(Alert == 5){
            let alertController = UIAlertController(title: "Congratulations !", message:nil, preferredStyle: .Alert)
            alertController.message = "We changed your parameters " + (cellule as String) + " !";
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            Alert = 0
        }
    }
    
    
    func back(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("S_TEAM_BACK", sender: self)
    }
    
    
    /*
     Return of teammates for a specific team.
     Using keys saved in app memory.
     */
    func lookforMembers(){
        
        if(cellule.stringByReplacingOccurrencesOfString(" ", withString: "") == "")
        {
            let alertController = UIAlertController(title: "Error", message: "No team found", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
            let post:NSString = "teamName=\(cellule)"
            
            NSLog("PostData: %@",post);
            
            let url = NSURL(string:"http://localhost:8888/Outpitch/iOSmembers/members.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch _ as NSError {
                urlData = nil
            } catch {
                fatalError()
            }
            
            
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    
                    NSLog("Success: %ld", success);
                    
                    
                    if(success == 1)
                    {
                        NSLog("Login OK");
                        
                        var membersJSON = [NSString](count:26, repeatedValue: "")
                        for i in 1...25{
                            membersJSON[i] = jsonData.valueForKey("member" + String(i)) as! NSString
                            maVariableIneffacable.setObject(membersJSON[i], forKey: "MEMBER"+String(i))
                        }
                        
                        maVariableIneffacable.synchronize()
                        
                    }else{
                        NSLog("Problem connection");
                        let alertController = UIAlertController(title: "Error", message: "Team not found", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                var alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                if let error = reponseError
                {
                    let messageErreur = (error.localizedDescription)
                    alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
                }
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
        print("BG_MEMBERS")
        
    }
    
    
    /*
     The most complicated function is here !
     Depending of value of time action, the sql request will be different in trophies.php
     Here for timeAction=0, and we recover value of Time (in team)
     If Time = "OFF", it means that you can create a vote
     Then we check value of actual time
     if actual time < Time in database (that we convert from string to date), then you can vote if you didn't vote for this match before (if voted != 1)
     else if actual time > Time in database then you can create a new game and and winners win their trophies. And date is passed to 'OFF' using function dateToActionTo("OFF", 1)
     timeAction will this time be 1, mean that requests called in trophies.php will be different
     (with time action equals 1, requests for election are called)
     
     */
    @IBAction func BT_TROPHIES(sender: UIButton) {
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        let timeAction = 0 // NO ACTION ON TIME
        let time = ""
        
        if(cellule.stringByReplacingOccurrencesOfString(" ", withString: "") == "")
        {
            let alertController = UIAlertController(title: "Error", message: "No team found", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
            let post:NSString = "idPlayer=\(idPlayer) &teamName=\(cellule) &timeAction=\(timeAction) &timeInsert=\(time)"
            
            NSLog("PostData: %@",post);
            
            let url = NSURL(string:"http://localhost:8888/Outpitch/iOStrophies/trophies.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch _ as NSError {
                urlData = nil
            } catch {
                fatalError()
            }
            
            
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    
                    NSLog("Success: %ld", success);
                    
                    
                    if(success == 1)
                    {
                        NSLog("Trophies OK");
                        let timeJSON = jsonData.valueForKey("timeData") as! NSString
                        timeJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        maVariableIneffacable.setObject(timeJSON, forKey: "TIME")
                        
                        let teamName = jsonData.valueForKey("teamnameData") as! NSString
                        teamName.stringByReplacingOccurrencesOfString(" ", withString: "")
                        maVariableIneffacable.setObject(teamName, forKey: "TEAMNAME")
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                        
                        let currentDate = NSDate()
                        dateStringEnd = timeJSON as String
                        
                        let dateStringNow = dateFormatter.stringFromDate(currentDate)
                        let endDate = dateFormatter.dateFromString(dateStringEnd)
                        
                        print(dateStringNow)
                        print(dateStringEnd)
                        
                        print(currentDate)
                        print(endDate)
                        
                        let votedJSON = jsonData.valueForKey("votedData") as! NSString
                        votedJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        maVariableIneffacable.setObject(votedJSON, forKey: "VOTED")
                        
                        maVariableIneffacable.synchronize()
                        
                        
                        
                        let alertTrophies = UIAlertController(title: "There is no Election for the moment...", message: "What should we do?", preferredStyle: .Alert)
                        // Create the actions
                        let NewVoteAction = UIAlertAction(title: "Create a new Match", style: UIAlertActionStyle.Default) {
                            UIAlertAction in
                            NSLog("New vote pressed")
                            self.performSegueWithIdentifier("S_NEW_GAME", sender: self)
                            
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                            UIAlertAction in
                            NSLog("Cancel Pressed")
                        }
                        
                        // Add the actions
                        alertTrophies.addAction(NewVoteAction)
                        alertTrophies.addAction(cancelAction)
                        
                        
                        
                        
                        if(self.dateStringEnd == "OFF"){
                            self.restTime = "OFF"
                            print("Begin of the vote !")
                            // Present the controller
                            self.presentViewController(alertTrophies, animated: true, completion: nil)
                            
                        }
                        else if(currentDate.timeIntervalSinceReferenceDate > endDate!.timeIntervalSinceReferenceDate){
                            print("Time's up !")
                            dateToActionTo("OFF", timeAction: 1) // ACTION 1 : trophies.php
                            let DiabyJSON = jsonData.valueForKey("numberDiaby") as! NSString
                            let MOTMJSON = jsonData.valueForKey("numberMOTM") as! NSString
                            let FOTMJSON:NSString = jsonData.valueForKey("numberFOTM") as! NSString
                            let RonaldinhoJSON = jsonData.valueForKey("numberRonaldinho") as! NSString
                            let DejongJSON:NSString = jsonData.valueForKey("numberDejong") as! NSString
                            
                            DiabyJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                            MOTMJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                            FOTMJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                            RonaldinhoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                            DejongJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                            
                            self.maVariableIneffacable.setObject(DiabyJSON, forKey: "DIABYTROPHY")
                            self.maVariableIneffacable.setObject(MOTMJSON, forKey: "MOTMTROPHY")
                            self.maVariableIneffacable.setObject(FOTMJSON, forKey: "FOTMTROPHY")
                            self.maVariableIneffacable.setObject(RonaldinhoJSON, forKey: "RONALDINHOTROPHY")
                            self.maVariableIneffacable.setObject(DejongJSON, forKey: "DEJONGTROPHY")
                            // Present the controller
                            self.presentViewController(alertTrophies, animated: true, completion: nil)
                            
                            
                            
                        }else if(currentDate.timeIntervalSinceReferenceDate < endDate!.timeIntervalSinceReferenceDate){
                            print("You can vote !")
                            let intervalMinutes = (endDate!.timeIntervalSinceDate(currentDate))/60
                            let x = Int(intervalMinutes)
                            restTime = String(x)
                            if(votedJSON == "1"){
                                let alertController = UIAlertController(title: "Patience !", message: "You alrdeady voted for this game, wait for the next one.", preferredStyle: .Alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                alertController.addAction(defaultAction)
                                presentViewController(alertController, animated: true, completion: nil)
                            }else{
                                self.performSegueWithIdentifier("S_TROPHIES", sender: self)
                            }
                        }
                        
                        
                    }else{
                        NSLog("Connection problem");
                        let alertController = UIAlertController(title: "Error", message: "Problem with timer, please let us solve this error", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                var alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                if let error = reponseError
                {
                    let messageErreur = (error.localizedDescription)
                    alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
                }
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
        }
        print("BG_TROPHIES")
    }
    
    
    func dateToActionTo(dateEndString : String, timeAction : Int){
        
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        let teamName = (maVariableIneffacable.valueForKey("TEAMNAME") as? String)!
        //let timeAction = 1 // ACTION VOTED
        //let dateEndString = "OFF"
        
        let post:NSString = "idPlayer=\(idPlayer) &teamName=\(teamName) &timeAction=\(timeAction) &timeInsert=\(dateEndString)"
        
        NSLog("PostData: %@",post);
        
        let url = NSURL(string:"http://localhost:8888/Outpitch/iOStrophies/trophies.php")!
        
        /* let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)! */
        /* NSUTF8StringEncoding : utilisé pour les accents */
        let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch _ as NSError {
            urlData = nil
        } catch {
            fatalError()
        }
        
        
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                var jsonData:NSDictionary = NSDictionary()
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                }catch {
                    // handle error
                }
                
                
                let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                //let success = Int(responseData as String)
                
                NSLog("Success: %ld", success);
                //NSLog("Success: %ld", success!);
                
                
                if(success == 1)
                {
                    NSLog("Login OK");
                    
                    let votedJSON = jsonData.valueForKey("votedData") as! NSString
                    let DiabyJSON = jsonData.valueForKey("numberDiaby") as! NSString
                    let MOTMJSON = jsonData.valueForKey("numberMOTM") as! NSString
                    let FOTMJSON:NSString = jsonData.valueForKey("numberFOTM") as! NSString
                    let RonaldinhoJSON = jsonData.valueForKey("numberRonaldinho") as! NSString
                    let DejongJSON:NSString = jsonData.valueForKey("numberDejong") as! NSString
                    
                    votedJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    DiabyJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    MOTMJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    FOTMJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    RonaldinhoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    DejongJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    
                    maVariableIneffacable.setObject(votedJSON, forKey: "VOTED")
                    maVariableIneffacable.setObject(DiabyJSON, forKey: "DIABYTROPHY")
                    maVariableIneffacable.setObject(MOTMJSON, forKey: "MOTMTROPHY")
                    maVariableIneffacable.setObject(FOTMJSON, forKey: "FOTMTROPHY")
                    maVariableIneffacable.setObject(RonaldinhoJSON, forKey: "RONALDINHOTROPHY")
                    maVariableIneffacable.setObject(DejongJSON, forKey: "DEJONGTROPHY")
                    
                    maVariableIneffacable.setInteger(1, forKey: "estCO")
                    maVariableIneffacable.synchronize()
                    
                    print("BG_TROPHY_GO")
                    
                }else{
                    NSLog("Login failed");
                    let alertController = UIAlertController(title: "Error", message: "We have a problem with our host", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            var alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
            if let error = reponseError
            {
                let messageErreur = (error.localizedDescription)
                alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
            }
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        print("BG_TROPHY_OFF")
    }
    
    
    /*
     This function check also the difference between the number of guys who voted in a team and
     the all members. If the difference is 0, then everybody voted, and the election can happen
     with dateToActionTo function using parameters ("OFF" and 1(election))
     This function is called each time the window appears.
     */
    func isVoted(teamName : String){
        
        let alertTrophies = UIAlertController(title: "There is no Election for the moment...", message: "What should we do?", preferredStyle: .Alert)
        // Create the actions
        let NewVoteAction = UIAlertAction(title: "Create a new Match", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            NSLog("New vote pressed")
            self.performSegueWithIdentifier("S_NEW_GAME", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertTrophies.addAction(NewVoteAction)
        alertTrophies.addAction(cancelAction)
        
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        
        let post:NSString = "teamName=\(teamName) &idPlayer=\(idPlayer)"
        
        NSLog("PostData: %@",post);
        
        let url = NSURL(string:"http://localhost:8888/Outpitch/iOScheckvoted/checkvoted.php")!
        
        /* let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)! */
        /* NSUTF8StringEncoding : utilisé pour les accents */
        let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch _ as NSError {
            urlData = nil
        } catch {
            fatalError()
        }
        
        
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            NSLog("Response code: %ld", res.statusCode);
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                NSLog("Response ==> %@", responseData);
                
                var error: NSError?
                
                var jsonData:NSDictionary = NSDictionary()
                do {
                    jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                }catch {
                    // handle error
                }
                
                
                let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                //let success = Int(responseData as String)
                
                NSLog("Success: %ld", success);
                //NSLog("Success: %ld", success!);
                
                
                if(success == 1){
                    var votedJSON = jsonData.valueForKey("votedData") as! NSString
                    votedJSON = votedJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    maVariableIneffacable.setObject(votedJSON, forKey: "TEAMISVOTED")
                    
                    var timeJSON = jsonData.valueForKey("timeData") as! NSString
                    timeJSON = timeJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    maVariableIneffacable.setObject(timeJSON, forKey: "TIMETEAM")
                    
                    abbreviationJSON = jsonData.valueForKey("abbreviationData") as! String
                    abbreviationJSON = abbreviationJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    
                    leagueJSON = jsonData.valueForKey("leagueData") as! String
                    leagueJSON = leagueJSON.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    
                    colorJSON = jsonData.valueForKey("colorData") as! String
                    colorJSON = colorJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    
                    var emblemJSON = jsonData.valueForKey("emblemData") as! String
                    emblemJSON = emblemJSON.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    
                    var everybodyvotedJSON = jsonData.valueForKey("EverybodyVoted") as! String
                    everybodyvotedJSON = everybodyvotedJSON.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    everybodyVoted =  Int(everybodyvotedJSON)!
                    
                    LBL_LEAGUE.text = "League : " + leagueJSON as String
                    LBL_ABBREVIATION.text = abbreviationJSON as String
                    IV_EMBLEM.image = UIImage(named: emblemJSON)
                    
                    if(emblemJSON == "White_Emblem.png"){
                        LBL_ABBREVIATION.textColor = UIColor.blackColor()
                    }else{
                        LBL_ABBREVIATION.textColor = UIColor.whiteColor()
                    }
                    
                    if(votedJSON == "0"){
                        IV_ISVOTED.hidden = false
                        LBL_NEW_VOTE.hidden = false
                    }else{
                        IV_ISVOTED.hidden = true
                        LBL_NEW_VOTE.hidden = true
                    }
                    
                    if(everybodyVoted == 1){
                        var alertController = UIAlertController(title: "Everybody voted !", message: "As fast as Mertesacker, tell it to your teammates", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                        
                        print("Everybody voted for this match !")
                        dateToActionTo("OFF", timeAction: 1) // ACTION 1 : trophies.php
                        // Present the controller
                        self.presentViewController(alertTrophies, animated: true, completion: nil)
                    }
                    maVariableIneffacable.synchronize()
                }else{
                    NSLog("Connection problem");
                    let alertController = UIAlertController(title: "Error", message: "Identifiers don't match.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                    
                }
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            }
        } else {
            var alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
            if let error = reponseError
            {
                let messageErreur = (error.localizedDescription)
                alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
            }
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    /*
     display memebers
     */
    @IBAction func BT_PLAYERS(sender: UIButton) {
        self.performSegueWithIdentifier("S_MEMBERS", sender: self)
    }
    
    
    /*
     access to database to delete link between idplayer/idteam in Link_Player_Team  table
     */
    func leaveTeam(){
        let idPlayer = (self.maVariableIneffacable.valueForKey("ID") as? String)!
        
        if(self.cellule.stringByReplacingOccurrencesOfString(" ", withString: "") == "")
        {
            let alertController = UIAlertController(title: "Error", message: "No team found", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
            let post:NSString = "teamName=\(self.cellule) &idPlayer=\(idPlayer)"
            
            NSLog("PostData: %@",post);
            
            let url = NSURL(string:"http://localhost:8888/Outpitch/iOSdeletemember/deletemember.php")!
            
            let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            var reponseError: NSError?
            var response: NSURLResponse?
            
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch _ as NSError {
                urlData = nil
            } catch {
                fatalError()
            }
            
            
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                NSLog("Response code: %ld", res.statusCode);
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    var error: NSError?
                    
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    
                    NSLog("Success: %ld", success);
                    
                    
                    if(success == 1)
                    {
                        NSLog("Login OK");
                        
                        let teamnumberJSON = jsonData.valueForKey("teamnumberData") as! NSString
                        teamnumberJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        self.maVariableIneffacable.setObject(teamnumberJSON, forKey: "TEAMNUMBER")
                        self.teamnameJSON = jsonData.valueForKey("teamnameData") as! NSString
                        
                        var teamsJSON = [NSString](count:26, repeatedValue: "")
                        for i in 1...25{
                            teamsJSON[i] = jsonData.valueForKey("team" + String(i)) as! NSString
                            self.maVariableIneffacable.setObject(teamsJSON[i], forKey: "TEAM"+String(i))
                        }
                        
                        self.maVariableIneffacable.setInteger(1, forKey: "estCO")
                        self.maVariableIneffacable.synchronize()
                        
                        self.Alert = 3
                        self.performSegueWithIdentifier("S_LEAVETEAM", sender: self)
                        
                    }else{
                        NSLog("Problem connection");
                        let alertController = UIAlertController(title: "Error", message: "Team not found", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                var alertController = UIAlertController(title: "Error", message: "Please connect to the internet.", preferredStyle: .Alert)
                if let error = reponseError
                {
                    let messageErreur = (error.localizedDescription)
                    alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
                }
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        print("BG_LEAVE")
        
    }
    
    
    /*
     Show different buttons which could called different function (leave/ parameters / cancel)
     */
    @IBAction func BT_SETTINGS(sender: UIButton) {
        let alert = UIAlertController()
        let ParametersAction = UIAlertAction(title: "Parameters", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            self.performSegueWithIdentifier("S_SETTINGS", sender: self)
        }
        
        let LeaveAction = UIAlertAction(title: "Leave", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            NSLog("Leave pressed")
            
            let leaveAlert = UIAlertController(title: "Are you sure you want to leave this team?", message: "I mean... really?", preferredStyle: .Alert)
            // Create the actions
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                NSLog("Leave confirmed")
                self.leaveTeam()
                
                
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Leave canceled")
                
                
            }
            leaveAlert.addAction(yesAction)
            leaveAlert.addAction(noAction)
            self.presentViewController(leaveAlert, animated: true, completion: nil)
            
            
            
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (alert: UIAlertAction!) -> Void in
            NSLog("Cancel pressed")
        }
        
        
        alert.addAction(ParametersAction)
        alert.addAction(LeaveAction)
        alert.addAction(CancelAction)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    
    @IBAction func BT_HISTORIC(sender: UIButton) {
        self.performSegueWithIdentifier("S_HISTORIC", sender: self)
    }
    
    
    /*
     Depending of where you go (window), you send different value from this class
     to the other.
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_LEAVETEAM"){
            let tabCtrl       = segue.destinationViewController as! UITabBarController
            let secondViewController = tabCtrl.viewControllers![0] as! Profile
            secondViewController.Alert = self.Alert
            secondViewController.teamnameAlert = self.teamnameJSON as String
        }else if (segue.identifier=="S_TROPHIES"){
            let secondViewController = segue.destinationViewController as! Trophies
            secondViewController.restTime = self.restTime
            secondViewController.dateStringEnd = self.dateStringEnd
            secondViewController.teamName = self.cellule
        }else if(segue.identifier=="S_HISTORIC"){
            let secondViewController = segue.destinationViewController as! Historic
            secondViewController.teamName = self.cellule
        }else if(segue.identifier=="S_SETTINGS"){
            let secondViewController = segue.destinationViewController as! Settings
            secondViewController.teamName = self.cellule
            secondViewController.myabbreviation = self.abbreviationJSON
            secondViewController.myleague = self.leagueJSON
            secondViewController.mycolor = self.colorJSON
        }
    }


}