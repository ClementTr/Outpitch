//
//  Player.swift
//  Outpitch
//
//  Created by Clément Tailleur on 14/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Player: Register, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var TF_NATION: UITextField!
    @IBOutlet weak var TF_CLUB: UITextField!
    @IBOutlet weak var TF_POSTE: UITextField!
    @IBOutlet weak var TF_SPORT: UITextField!
    
    var tab_country :[String] = ["", "Algeria", "Austria", "Belgium", "Brazil", "Canada", "Czech Republic", "Denmark", "England", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Ivory Coast", "Mali", "Mexico", "Monaco", "Morocco", "Netherlands", "Northern Ireland", "Poland", "Portugal", "Scotland", "Spain", "Switzerland", "Tunisia", "Turkey", "USA", "Wales"]
    var tab_club: [String] = ["", "Arsenal FC", "Chelsea FC", "Manchester City FC", "Manchester United FC", "Liverpool FC", "Club Atlético de Madrid", "FC Barcelona", "Real Madrid CF", "Villareal CF", "AS Monaco FC", "LOSC", "OGC Nice","Olympique de Marseille", "Olympique Lyonnais", "Paris Saint-Germain", "Stade Rennais FC", "AC Milan", "AS Roma", "FC Internazionale Milano", "Juventus FC", "SSC Napoli", "BV 09 Borussia Dortmund", "FC Bayern München", "TSV Bayer 04 Leverkusen", "FC Porto", "SL Benfica", "Sporting Clube de Portugal", "Galatasaray SK", "Fenerbahce SK", "PSV Eindhoven"]//"AC Milan", "Arsenal FC", "AS Monaco FC", "AS Roma", "BV 09 Borussia Dortmund", "Chelsea FC", "Club Atlético de Madrid", "FC Barcelona", "FC Bayern München", "FC Internazionale Milano", "FC Porto", "Fenerbahce SK", "Galatasaray SK", "Juventus FC", "Liverpool FC", "LOSC", "Manchester City FC", "Manchester United FC", "OGC Nice", "Olympique de Marseille", "Olympique Lyonnais", "Paris Saint-Germain", "PSV Eindhoven", "Real Madrid CF", "SL Benfica", "Sporting Clube de Portugal", "SSC Napoli", "Stade Rennais FC", "TSV Bayer 04 Leverkusen", "Villareal CF"]
    var tab_sport: [String] = ["", "Football"]
    var tab_position : [String] = ["", "Keeper", "Left-back", "Center-back", "Right-back", "Defending midfielder", "Central midfielder", "Playmaker", "Attacking midfielder", "Wide midfielders", "Wingers", "Withdrawn striker", "Striker"]
    
    var PV_Country = UIPickerView()
    var PV_Club = UIPickerView()
    var PV_Position = UIPickerView()
    var PV_Sport = UIPickerView()
    
    var toolBar = UIToolbar()
    var activeTextField = UITextField()
    
    var nationJSON : NSString!
    var Alert : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 3/255, green: 14/255, blue: 138/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action:"donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:"cancelPicker:")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        PV_Country.delegate = self
        PV_Country.dataSource = self
        
        PV_Club.delegate = self
        PV_Club.dataSource = self
        
        PV_Position.delegate = self
        PV_Position.dataSource = self
        
        PV_Sport.delegate = self
        PV_Sport.dataSource = self
        
        //delegate Textfields
        
        TF_NATION.delegate = self
        TF_CLUB.delegate = self
        TF_POSTE.delegate = self
        TF_SPORT.delegate = self
        
        //link textfields to pickerviews, and add toolbar to the pickerviews
        
        TF_NATION.inputView = PV_Country
        TF_NATION.inputAccessoryView = toolBar
        TF_CLUB.inputView = PV_Club
        TF_CLUB.inputAccessoryView = toolBar
        TF_POSTE.inputView = PV_Position
        TF_POSTE.inputAccessoryView = toolBar
        TF_SPORT.inputView = PV_Sport
        TF_SPORT.inputAccessoryView = toolBar
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    override func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //Function textFieldDidBeginEditing will put in activeTextField variable which textfield is selected by the user
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    //Functions donePicker and cancelPicker linked to Done and Cancel buttons in the toolbar
    
    func donePicker(sender: UIBarButtonItem) {
        
        if activeTextField == TF_NATION {
            
            PV_Country.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_CLUB  {
            
            PV_Club.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_POSTE {
            PV_Position.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_SPORT {
            PV_Sport.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        
        
        
    }
    func cancelPicker(sender: UIBarButtonItem) {
        if activeTextField == TF_NATION {
            
            PV_Country.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_CLUB  {
            
            PV_Club.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_POSTE {
            PV_Position.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_SPORT {
            PV_Sport.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    
    //return the nomber of columns of the pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //return the number of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == TF_NATION {
            
            return tab_country.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_CLUB  {
            return tab_club.count
        }
        else if activeTextField == TF_POSTE {
            
            return tab_position.count
        }
        else if activeTextField == TF_SPORT {
            
            return tab_sport.count
        }
        else {
            
            return 0
        }
        
    }
    
    // if a row is selected, display it on the text field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == TF_NATION {
            TF_NATION.text = tab_country[row] // A modifier selon le TF et le tab voulu
        }
        else if activeTextField == TF_CLUB {
            
            TF_CLUB.text = tab_club[row]
        }
        else if activeTextField == TF_POSTE {
            
            TF_POSTE.text = tab_position[row]
        }
        else if activeTextField == TF_SPORT {
            
            TF_SPORT.text = tab_sport[row]
        }
        
    }
    
    // set tittle for each rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == TF_NATION {
            
            return tab_country[row] // A modifier selon le tab voulu
        }
        else if activeTextField == TF_CLUB {
            
            return tab_club[row] // A modifier selon le tab voulu
        }
        else if activeTextField == TF_POSTE {
            
            return tab_position[row]
        }
        else if activeTextField == TF_SPORT {
            
            return tab_sport[row]
        }
        else {
            
            return ""
        }
    }
    
    
    @IBAction override func BT_REGISTER(sender: UIButton) {
        let nation:NSString = TF_NATION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let positionnement:NSString = TF_POSTE.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let club:NSString = TF_CLUB.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let pseudo = (maVariableIneffacable.valueForKey("PSEUDO") as? String)!
        
        if( nation.isEqualToString("") || positionnement.isEqualToString("") || club.isEqualToString("")){
            let alertController = UIAlertController(title: "Error", message: "Please tape your all paraemeters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            let post:NSString = "pseudo=\(pseudo) &nation=\(nation) &position=\(positionnement) &club=\(club)"
            NSLog("PostData: %@",post);
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSplayer/player.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSplayer/player.php")!
            let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let reponseError: NSError? = nil
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
                
                if (res.statusCode >= 200 && res.statusCode < 300){
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData);
                    
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    NSLog("Success: %ld", success);
                    if(success == 1){
                        let positionJSON:NSString = jsonData.valueForKey("positionData") as! NSString
                        let pictureJSON = jsonData.valueForKey("pictureData") as! NSString
                        let nationJSON:NSString = jsonData.valueForKey("nationData") as! NSString
                        let clubJSON:NSString = jsonData.valueForKey("clubData") as! NSString
                        let nationlinkJSON:NSString = jsonData.valueForKey("nationlinkData") as! NSString
                        let clublinkJSON:NSString = jsonData.valueForKey("clublinkData") as! NSString
                        let idJSON:NSString = jsonData.valueForKey("idData") as! NSString
                        let goalsJSON:NSString = jsonData.valueForKey("goalsData") as! NSString
                        let assistsJSON:NSString = jsonData.valueForKey("assistsData") as! NSString
                        let preassistsJSON:NSString = jsonData.valueForKey("preassistsData") as! NSString
                        let penaltiesJSON:NSString = jsonData.valueForKey("penaltiesData") as! NSString
                        let yellowcardJSON:NSString = jsonData.valueForKey("yellowcardData") as! NSString
                        let redcardJSON:NSString = jsonData.valueForKey("redcardData") as! NSString
                        let teamnumberJSON:NSString = jsonData.valueForKey("teamnumberData") as! NSString
                        
                        positionJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        pictureJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        nationJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        clubJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        nationlinkJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        clublinkJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        idJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        goalsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        assistsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        preassistsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        penaltiesJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        yellowcardJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        redcardJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        teamnumberJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        
                        /* forKey donne les valeurs des JSON à ce que l'on met entre guillements pour les utiliser dans une autre classe. */
                        maVariableIneffacable.setObject(positionJSON, forKey: "POSITION")
                        maVariableIneffacable.setObject(pictureJSON, forKey: "PICTURE")
                        maVariableIneffacable.setObject(nationJSON, forKey: "NATION")
                        maVariableIneffacable.setObject(clubJSON, forKey: "CLUB")
                        maVariableIneffacable.setObject(nationlinkJSON, forKey: "NATIONLINK")
                        maVariableIneffacable.setObject(clublinkJSON, forKey: "CLUBLINK")
                        maVariableIneffacable.setObject(idJSON, forKey: "ID")
                        maVariableIneffacable.setObject(goalsJSON, forKey: "GOALS")
                        maVariableIneffacable.setObject(assistsJSON, forKey: "ASSISTS")
                        maVariableIneffacable.setObject(preassistsJSON, forKey: "PREASSISTS")
                        maVariableIneffacable.setObject(penaltiesJSON, forKey: "PENALTIES")
                        maVariableIneffacable.setObject(yellowcardJSON, forKey: "YC")
                        maVariableIneffacable.setObject(redcardJSON, forKey: "RC")
                        maVariableIneffacable.setObject(teamnumberJSON, forKey: "TEAMNUMBER")
                        //maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        Alert = 4
                        self.performSegueWithIdentifier("S_ENDPLAYER", sender: self)
                        print("BG_NEW_PLAYER")
                    }else {
                        var alertController = UIAlertController(title: "Error", message: "Please connect to the internet", preferredStyle: .Alert)
                        if let error = reponseError{
                            let messageErreur = (error.localizedDescription)
                            alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
                        }
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                    }
                }else {
                    var alertController = UIAlertController(title: "Error", message: "Please connect to the internet", preferredStyle: .Alert)
                    if let error = reponseError{
                        let messageErreur = (error.localizedDescription)
                        alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
                    }
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_ENDPLAYER"){
            let tabCtrl       = segue.destinationViewController as! UITabBarController
            let secondViewController = tabCtrl.viewControllers![0] as! Profile
            secondViewController.Alert = self.Alert
        }
    }
    
    
}


