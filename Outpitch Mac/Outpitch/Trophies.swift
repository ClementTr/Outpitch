//
//  Trophies.swift
//  Outpitch
//
//  Created by Clément Tailleur on 19/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Trophies: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource {

    @IBOutlet weak var LBL_TIME: UILabel!
    
    @IBOutlet weak var TF_TROPHY_DIABY: UITextField!
    @IBOutlet weak var TF_TROPHY_MOTM: UITextField!
    @IBOutlet weak var TF_TROPHY_RONALDINHO: UITextField!
    @IBOutlet weak var TF_TROPHY_FOTM: UITextField!
    @IBOutlet weak var TF_TROPHY_DEJONG: UITextField!
    
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var PV_Members_Diaby = UIPickerView()
    var PV_Members_Dejong = UIPickerView()
    var PV_Members_Ronaldinho = UIPickerView()
    var PV_Members_MOTM = UIPickerView()
    var PV_Members_FOTM = UIPickerView()
    
    var toolBar = UIToolbar()
    var activeTextField = UITextField()
    
    var restTime = String()
    var dateStringEnd = String()
    var teamName = String()
    
    var theTimer: NSTimer!
    var idPlayer = String()
    var dateNow = NSDate()
    var dateNowString = String()
    var members = [String](count: 25, repeatedValue: "")
    
    /*
     Make an array (members) of each member that the team has (using key MEMBERi) except your own pseudo
     then you can't vote for yourself
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Pseudo = (maVariableIneffacable.valueForKey("PSEUDO") as? String)!
        print(Pseudo)
        LBL_TIME.text = "You have only " + restTime + " minutes before the end of the time !"
        
        members.removeAll()

        for i in 0...25{
            if(i==0){
               members.append(" ")
            }else if let tempMember = maVariableIneffacable.valueForKey("MEMBER" + String(i)) as? String{
                if((tempMember != "") && tempMember != Pseudo.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())){
                    members.append(tempMember.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                }
            }
        }
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 3/255, green: 14/255, blue: 138/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action:"donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:"cancelPicker:")
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        PV_Members_Diaby.delegate = self
        PV_Members_Diaby.dataSource = self
        
        PV_Members_Dejong.delegate = self
        PV_Members_Dejong.dataSource = self
        
        PV_Members_Ronaldinho.delegate = self
        PV_Members_Ronaldinho.dataSource = self
        
        PV_Members_MOTM.delegate = self
        PV_Members_MOTM.dataSource = self
        
        PV_Members_FOTM.delegate = self
        PV_Members_FOTM.dataSource = self
        
        TF_TROPHY_DIABY.delegate = self
        TF_TROPHY_DIABY.inputView = PV_Members_Diaby
        TF_TROPHY_DIABY.inputAccessoryView = toolBar
        
        TF_TROPHY_DEJONG.delegate = self
        TF_TROPHY_DEJONG.inputView = PV_Members_Dejong
        TF_TROPHY_DEJONG.inputAccessoryView = toolBar
        
        TF_TROPHY_RONALDINHO.delegate = self
        TF_TROPHY_RONALDINHO.inputView = PV_Members_Ronaldinho
        TF_TROPHY_RONALDINHO.inputAccessoryView = toolBar
        
        TF_TROPHY_FOTM.delegate = self
        TF_TROPHY_FOTM.inputView = PV_Members_FOTM
        TF_TROPHY_FOTM.inputAccessoryView = toolBar
        
        TF_TROPHY_MOTM.delegate = self
        TF_TROPHY_MOTM.inputView = PV_Members_MOTM
        TF_TROPHY_MOTM.inputAccessoryView = toolBar
        
        setTime() //check if actual time is not older than Time of created Game + 24h
        
    }
    
    /*
     Process to create PickerView
     See Parameters etc to see how it is working
     */
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    //Functions donePicker and cancelPicker linked to Done and Cancel buttons in the toolbar

    
    func donePicker(sender: UIBarButtonItem) {
        
        if(activeTextField == TF_TROPHY_DIABY) {
            PV_Members_Diaby.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_DEJONG){
            PV_Members_Dejong.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_RONALDINHO){
            PV_Members_Ronaldinho.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_MOTM){
            PV_Members_MOTM.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_FOTM){
            PV_Members_FOTM.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        if(activeTextField == TF_TROPHY_DIABY){
            PV_Members_Diaby.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_DEJONG){
            PV_Members_Dejong.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_RONALDINHO){
            PV_Members_Ronaldinho.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_MOTM){
            PV_Members_MOTM.removeFromSuperview()
            toolBar.removeFromSuperview()
        }else if(activeTextField == TF_TROPHY_FOTM){
            PV_Members_FOTM.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    
    //return the nomber of columns of the pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //return the number of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(activeTextField == TF_TROPHY_DIABY){
            return members.count // A modifier selon le tab voulu
        }else if(activeTextField == TF_TROPHY_DEJONG){
            return members.count
        }else if(activeTextField == TF_TROPHY_RONALDINHO){
            return members.count
        }else if(activeTextField == TF_TROPHY_MOTM){
            return members.count
        }else if(activeTextField == TF_TROPHY_FOTM){
            return members.count
        }else{
            return 0
        }
        
    }
    // if a row is selected, display it on the text field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(activeTextField == TF_TROPHY_DIABY){
            TF_TROPHY_DIABY.text = members[row]
        }else if(activeTextField == TF_TROPHY_DEJONG){
            TF_TROPHY_DEJONG.text = members[row]
        }else if(activeTextField == TF_TROPHY_RONALDINHO){
            TF_TROPHY_RONALDINHO.text = members[row]
        }else if(activeTextField == TF_TROPHY_MOTM){
            TF_TROPHY_MOTM.text = members[row]
        }else if(activeTextField == TF_TROPHY_FOTM){
            TF_TROPHY_FOTM.text = members[row]
        }
    }
    
    // set tittle for each rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (activeTextField == TF_TROPHY_DIABY) {
            return members[row]
        }else if(activeTextField == TF_TROPHY_DEJONG){
            return members[row]
        }else if(activeTextField == TF_TROPHY_RONALDINHO){
            return members[row]
        }else if(activeTextField == TF_TROPHY_MOTM){
            return members[row]
        }else if(activeTextField == TF_TROPHY_FOTM){
            return members[row]
        }else {
            return ""
        }
    }
    
 
    
    func setTime() {
        theTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(Trophies.setTime), userInfo: nil, repeats: false)
        
        dateNow = NSDate()
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        dateNowString = dateFormatter.stringFromDate(dateNow)
        let dateEnd = dateFormatter.dateFromString(dateStringEnd)
        
        print(dateNow)
        print(dateEnd)
        
        if(dateNow.timeIntervalSinceReferenceDate > dateEnd!.timeIntervalSinceReferenceDate){
            theTimer.invalidate()
            dateToActionTo("OFF", timeAction: 2)
            performSegueWithIdentifier("S_TROPHIES_BACK", sender: nil)
        }else{
            //print("Good Time")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    /*Vote if actual time is older than time of creating Game + 24h
     using the same methode than in Temas (dateToActionTo with time action equals to 1 
     in order to make the election)
     */
    func dateToActionTo(dateEndString : String, timeAction : Int){
        
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        teamName = (maVariableIneffacable.valueForKey("TEAMNAME") as? String)!
        //let timeAction = 2 //ACTION INSERT NEW TIME
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
                    votedJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                    maVariableIneffacable.setObject(votedJSON, forKey: "VOTED")
                    
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
     Same process than for other connection with database
     Action to vote, insert id of the candidate for who you voted in database for the specific trophy
     Pass value of Voted to 1 (cannot vote 2 times)
     */
    @IBAction func BT_VOTE(sender: UIButton) {
        
        let trophyDiabyCandidate:NSString = TF_TROPHY_DIABY.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let trophyMOTMCandidate:NSString = TF_TROPHY_MOTM.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let trophyFOTMCandidate:NSString = TF_TROPHY_FOTM.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let trophyRonaldinhoCandidate:NSString = TF_TROPHY_RONALDINHO.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let trophyDejongCandidate:NSString = TF_TROPHY_DEJONG.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        let teamName = (maVariableIneffacable.valueForKey("TEAMNAME") as? String)!
        
        
        if( trophyDiabyCandidate.isEqualToString("") || trophyMOTMCandidate.isEqualToString("") || trophyFOTMCandidate.isEqualToString("") || trophyRonaldinhoCandidate.isEqualToString("") || trophyDejongCandidate.isEqualToString("") )
        {
            /* si les champs sont vides */
            let alertController = UIAlertController(title: "Error", message: "Tape your all parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
            let post:NSString = " idPlayer=\(idPlayer) &teamName=\(teamName) &trophyDiabyCandidate=\(trophyDiabyCandidate) &trophyMOTMCandidate=\(trophyMOTMCandidate) &trophyFOTMCandidate=\(trophyFOTMCandidate) &trophyRonaldinhoCandidate=\(trophyRonaldinhoCandidate) &trophyDejongCandidate=\(trophyDejongCandidate) "
            
            NSLog("PostData: %@",post);
            
            let url = NSURL(string:"http://localhost:8888/Outpitch/iOSvote/vote.php")!
            
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
                        
                        let votedJSON = jsonData.valueForKey("votedData") as! NSString
                        votedJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        maVariableIneffacable.setObject(votedJSON, forKey: "VOTED")
                        
                        maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        performSegueWithIdentifier("S_TROPHIES_BACK", sender: nil)
                        
                    }else{
                        NSLog("Login failed");
                        let alertController = UIAlertController(title: "Error", message: "Problem during the seizure.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                        
                    }
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Please connect to the internet", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                var alertController = UIAlertController(title: "Error", message: "Please connect to the internet", preferredStyle: .Alert)
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
        print("BG_NEW_VOTE")
    }
    
    /*
     Don't forget to send name of your team when you go back to Team in order
     to make action with database (isvoted(cellule)) possible
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_TROPHIES_BACK"){
            let secondViewController = segue.destinationViewController as! Team
            secondViewController.cellule = self.teamName
        }
    }
}
