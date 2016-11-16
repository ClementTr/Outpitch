//
//  Parameters.swift
//  Outpitch
//
//  Created by Clément Tailleur on 27/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Parameters: UIViewController, UIImagePickerControllerDelegate, UIPickerViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var TF_COUNTRY: UITextField!
    @IBOutlet weak var TF_CLUB: UITextField!
    @IBOutlet weak var TF_POSITION: UITextField!
    @IBOutlet weak var TF_FIRSTNAME: UITextField!
    @IBOutlet weak var TF_LASTNAME: UITextField!
    @IBOutlet weak var TF_AGE: UITextField!
    @IBOutlet weak var TF_PSEUDO: UITextField!
    @IBOutlet weak var TF_MAIL: UITextField!
    @IBOutlet weak var TF_PASSWORD: UITextField!
    @IBOutlet weak var TF_PASSWORD_CONFIRMATION: UITextField!
    @IBOutlet weak var BT_PICTURE: UIButton!
   
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var nationJSON : NSString!
    var ImagePicker = UIImagePickerController()
    
    var tab_country :[String] = ["", "Algeria", "Argentina", "Austria", "Belgium", "Brazil", "Canada", "Colombia", "Czech Republic", "Denmark", "England", "France", "Germany", "Greece", "Hungary", "Ireland", "Italy", "Ivory Coast", "Mali", "Mexico", "Monaco", "Morocco", "Netherlands", "Northern Ireland", "Poland", "Portugal", "Scotland", "Spain", "Switzerland", "Tunisia", "Turkey", "USA", "Wales"]
    var tab_club: [String] = ["", "Arsenal FC", "Chelsea FC", "Manchester City FC", "Manchester United FC", "Liverpool FC", "Club Atlético de Madrid", "FC Barcelona", "Real Madrid CF", "Villareal CF", "AS Monaco FC", "LOSC", "OGC Nice","Olympique de Marseille", "Olympique Lyonnais", "Paris Saint-Germain", "Stade Rennais FC", "AC Milan", "AS Roma", "FC Internazionale Milano", "Juventus FC", "SSC Napoli", "BV 09 Borussia Dortmund", "FC Bayern München", "TSV Bayer 04 Leverkusen", "FC Porto", "SL Benfica", "Sporting Clube de Portugal", "Galatasaray SK", "Fenerbahce SK", "PSV Eindhoven"]//"AC Milan", "Arsenal FC", "AS Monaco FC", "AS Roma", "BV 09 Borussia Dortmund", "Chelsea FC", "Club Atlético de Madrid", "FC Barcelona", "FC Bayern München", "FC Internazionale Milano", "FC Porto", "Fenerbahce SK", "Galatasaray SK", "Juventus FC", "Liverpool FC", "LOSC", "Manchester City FC", "Manchester United FC", "OGC Nice", "Olympique de Marseille", "Olympique Lyonnais", "Paris Saint-Germain", "PSV Eindhoven", "Real Madrid CF", "SL Benfica", "Sporting Clube de Portugal", "SSC Napoli", "Stade Rennais FC", "TSV Bayer 04 Leverkusen", "Villareal CF"]
    
    var tab_sport: [String] = ["", "Football"]
    
    var tab_position : [String] = ["", "Keeper", "Left-back", "Center-back", "Right-back", "Defending midfielder", "Central midfielder", "Playmaker", "Attacking midfielder", "Wide midfielders", "Wingers", "Withdrawn striker", "Striker"]
    
    var PV_Country = UIPickerView()
    var PV_Club = UIPickerView()
    var PV_Position = UIPickerView()
    var PV_Sport = UIPickerView()
    
    var toolBar = UIToolbar()
    
    var activeTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.TF_PSEUDO.text = (maVariableIneffacable.valueForKey("PSEUDO") as? String)!
        self.TF_PASSWORD.text = (maVariableIneffacable.valueForKey("PASSWORD") as? String)!
        self.TF_PASSWORD_CONFIRMATION.text = (maVariableIneffacable.valueForKey("PASSWORD") as? String)!
        self.TF_FIRSTNAME.text = (maVariableIneffacable.valueForKey("FIRSTNAME") as? String)!
        self.TF_LASTNAME.text = (maVariableIneffacable.valueForKey("LASTNAME") as? String)!
        self.TF_AGE.text = (maVariableIneffacable.valueForKey("AGE") as? String)!
        self.TF_MAIL.text = (maVariableIneffacable.valueForKey("MAIL") as? String)!
        self.TF_POSITION.text = (maVariableIneffacable.valueForKey("POSITION") as? String)!
        self.TF_COUNTRY.text = (maVariableIneffacable.valueForKey("NATION") as? String)!
        self.TF_CLUB.text = (maVariableIneffacable.valueForKey("CLUB") as? String)!
        
        //Creation of the toolbar
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 3/255, green: 14/255, blue: 138/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action:"donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:"cancelPicker:")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //Creation of the pickerviews
        
        PV_Country.delegate = self
        PV_Country.dataSource = self
        
        PV_Club.delegate = self
        PV_Club.dataSource = self
        
        PV_Position.delegate = self
        PV_Position.dataSource = self
        
        
        
        //delegate Textfields
        
        TF_COUNTRY.delegate = self
        TF_CLUB.delegate = self
        TF_POSITION.delegate = self
        
        
        //link textfields to pickerviews, and add toolbar to the pickerviews
        
        TF_COUNTRY.inputView = PV_Country
        TF_COUNTRY.inputAccessoryView = toolBar
        TF_CLUB.inputView = PV_Club
        TF_CLUB.inputAccessoryView = toolBar
        TF_POSITION.inputView = PV_Position
        TF_POSITION.inputAccessoryView = toolBar
        
        ImagePicker.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Function textFieldDidBeginEditing will put in activeTextField variable which textfield is selected by the user
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    //Functions donePicker and cancelPicker linked to Done and Cancel buttons in the toolbar
    
    func donePicker(sender: UIBarButtonItem) {
        
        if activeTextField == TF_COUNTRY {
            
            PV_Country.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_CLUB  {
            
            PV_Club.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_POSITION {
            PV_Position.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        
        
        
        
    }
    func cancelPicker(sender: UIBarButtonItem) {
        if activeTextField == TF_COUNTRY {
            
            PV_Country.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_CLUB  {
            
            PV_Club.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_POSITION {
            PV_Position.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        
    }
    
    
    //return the nomber of columns of the pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    //return the number of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == TF_COUNTRY{
            
            return tab_country.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_CLUB  {
            return tab_club.count
        }
        else if activeTextField == TF_POSITION {
            
            return tab_position.count
        }
            
        else {
            
            return 0
        }
        
    }
    // if a row is selected, display it on the text field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == TF_COUNTRY {
            TF_COUNTRY.text = tab_country[row] // A modifier selon le TF et le tab voulu
        }
        else if activeTextField == TF_CLUB {
            
            TF_CLUB.text = tab_club[row]
        }
        else if activeTextField == TF_POSITION {
            
            TF_POSITION.text = tab_position[row]
        }
        
        
    }
    // set tittle for each rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == TF_COUNTRY {
            
            return tab_country[row] // A modifier selon le tab voulu
        }
        else if activeTextField == TF_CLUB {
            
            return tab_club[row] // A modifier selon le tab voulu
        }
        else if activeTextField == TF_POSITION {
            
            return tab_position[row]
        }
            
        else {
            
            return ""
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func BT_NEW_PP(sender: UIButton) {
        
        let pictureAlert = UIAlertController(title: "Changing profile picture", message: "How do you want to change your picture?", preferredStyle: .Alert)
        // Create the actions
        let predefinedPictureAction = UIAlertAction(title: "Use pre-defined picture", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.performSegueWithIdentifier("S_PROFILE_PICTURE_2", sender: self)
        }
        
        let personalPictureAction = UIAlertAction(title: "Use personal picture from phone", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.ImagePicker.allowsEditing = false
            self.ImagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.ImagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
        }
        
        pictureAlert.addAction(predefinedPictureAction)
        pictureAlert.addAction(personalPictureAction)
        pictureAlert.addAction(cancelAction)
        self.presentViewController(pictureAlert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func BT_UPDATE(sender: AnyObject) {
        
        
        let pseudo:NSString = TF_PSEUDO.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let mdp:NSString = TF_PASSWORD.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password_confirmation:NSString = TF_PASSWORD_CONFIRMATION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let firstname:NSString = TF_FIRSTNAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let lastname:NSString = TF_LASTNAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let age:NSString = TF_AGE.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let email:NSString = TF_MAIL.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let positionnement:NSString = TF_POSITION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let nation:NSString = TF_COUNTRY.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let club:NSString = TF_CLUB.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        
        
        //let pseudo : NSString = globalPseudo.getValue()
        let id = (maVariableIneffacable.valueForKey("ID") as? String)!
        
        if( nation.isEqualToString("") || positionnement.isEqualToString("") || club.isEqualToString("") || firstname.isEqualToString("") || lastname.isEqualToString("") || age.isEqualToString("") || pseudo.isEqualToString("") || email.isEqualToString("") || mdp.isEqualToString("") || password_confirmation.isEqualToString("")){
            
            let alertController = UIAlertController(title: "Error", message: "Please tape your all parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }else if(mdp != password_confirmation){
            
            let alertController = UIAlertController(title: "Error", message: "Your password is not correctly confirmed", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            let post:NSString = "id=\(id) &pseudo=\(pseudo) &mdp=\(mdp) &firstname=\(firstname) &lastname=\(lastname) &age=\(age) &email=\(email) &position=\(positionnement) &nation=\(nation) &club=\(club)"
            
            NSLog("PostData: %@",post);
            
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSupdate/update.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSupdate/update.php")!
            //let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            let postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
            
            let postLength:NSString = String( postData.length )
            
            let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            
            //var reponseError: NSError?
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
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    
                    NSLog("Response ==> %@", responseData);
                    
                    //var reponseError: NSError?
                    
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    NSLog("Success: %ld", success);
                    
                    if(success == 1){
                        let pseudoJSON:NSString = jsonData.valueForKey("pseudoData") as! NSString
                        let passwordJSON:NSString = jsonData.valueForKey("passwordData") as! NSString
                        
                        let firstnameJSON:NSString = jsonData.valueForKey("firstnameData") as! NSString
                        let lastnameJSON:NSString = jsonData.valueForKey("lastnameData") as! NSString
                        let ageJSON:NSString = jsonData.valueForKey("ageData") as! NSString
                        let emailJSON:NSString = jsonData.valueForKey("emailData") as! NSString
                        let nationJSON:NSString = jsonData.valueForKey("nationData") as! NSString
                        let clubJSON:NSString = jsonData.valueForKey("clubData") as! NSString
                        let postJSON:NSString = jsonData.valueForKey("positionData") as! NSString
                        let nationlinkJSON:NSString = jsonData.valueForKey("nationlinkData") as! NSString
                        let clublinkJSON:NSString = jsonData.valueForKey("clublinkData") as! NSString
                        pseudoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        passwordJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        firstnameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        lastnameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        ageJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        emailJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        nationJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        clubJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        postJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        nationlinkJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        clublinkJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        
                        
                        /* forKey donne les valeurs des JSON à ce que l'on met entre guillements pour les utiliser dans une autre classe. */
                        maVariableIneffacable.setObject(pseudoJSON, forKey: "PSEUDO")
                        maVariableIneffacable.setObject(passwordJSON, forKey: "PASSWORD")
                        maVariableIneffacable.setObject(firstnameJSON, forKey: "FIRSTNAME")
                        maVariableIneffacable.setObject(lastnameJSON, forKey: "LASTNAME")
                        maVariableIneffacable.setObject(ageJSON, forKey: "AGE")
                        maVariableIneffacable.setObject(emailJSON, forKey: "MAIL")
                        maVariableIneffacable.setObject(nationJSON, forKey: "NATION")
                        maVariableIneffacable.setObject(clubJSON, forKey: "CLUB")
                        maVariableIneffacable.setObject(postJSON, forKey: "POSITION")
                        maVariableIneffacable.setObject(nationlinkJSON, forKey: "NATIONLINK")
                        maVariableIneffacable.setObject(clublinkJSON, forKey: "CLUBLINK")
                        maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        
                        self.performSegueWithIdentifier("S_UPDATE", sender: self)
                        
                        let alertController = UIAlertController(title: "Congratulations !", message:nil, preferredStyle: .Alert)
                        alertController.message = "We changed your parameters " + (pseudoJSON as String) + " !";
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                        print("BG_PARAMETRES")
                        
                        
                    }else{
                        NSLog("New parameters failed");
                        let alertController = UIAlertController(title: "Error", message: "Problem during setting", preferredStyle: .Alert)
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
        print("BG_PARAMETERS")
    }
    
    
}
