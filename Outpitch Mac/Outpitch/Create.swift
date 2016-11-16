//
//  Create.swift
//  Outpitch
//
//  Created by Clément Tailleur on 09/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Create: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var TF_NAME: UITextField!
    @IBOutlet weak var TF_ABBREVIATION: UITextField!
    @IBOutlet weak var TF_LEAGUE: UITextField!
    @IBOutlet weak var TF_PASSWORD: UITextField!
    @IBOutlet weak var TF_CONFIRMATION: UITextField!
    @IBOutlet weak var TF_COLOR: UITextField!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var Alert = Int()
    var teamnameJSON = NSString()
    
    var PV_COLORS = UIPickerView()
    var toolBar = UIToolbar()
    var activeTextField = UITextField()
    var tab_colors: [String] = ["", "Azure", "Black", "Blue", "Green", "Red", "White", "Yellow"]
    
    override func viewDidLoad() {
        
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 3/255, green: 14/255, blue: 138/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action:"donePicker:")
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:"cancelPicker:")
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        PV_COLORS.delegate = self
        PV_COLORS.dataSource = self
        TF_COLOR.delegate = self
        TF_COLOR.inputView = PV_COLORS
        TF_COLOR.inputAccessoryView = toolBar
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    func donePicker(sender: UIBarButtonItem) {
        if activeTextField == TF_COLOR {
            PV_COLORS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        if activeTextField == TF_COLOR {
            PV_COLORS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == TF_COLOR {
            return tab_colors.count // A modifier selon le tab voulu
        }else {
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == TF_COLOR {
            TF_COLOR.text = tab_colors[row] // A modifier selon le TF et le tab voulu
        }
    }
    
    // set tittle for each rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(activeTextField == TF_COLOR){
            return tab_colors[row] // A modifier selon le tab voulu
        }else{
            return ""
        }
    }
    
    
    @IBAction func BT_CREATE(sender: UIButton) {
        
        let nameTeam:NSString = TF_NAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password:NSString = TF_PASSWORD.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let confirmation:NSString = TF_CONFIRMATION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let league : NSString = TF_LEAGUE.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let abbreviation : NSString = TF_ABBREVIATION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        let color:NSString = TF_COLOR.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        
        if( nameTeam.isEqualToString("") || password.isEqualToString("") || confirmation.isEqualToString("") || league.isEqualToString("") || abbreviation.isEqualToString("") || color.isEqualToString(""))
        {
            
            let alertController = UIAlertController(title: "Error", message: "Tape all your parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }else if(TF_PASSWORD.text != TF_CONFIRMATION.text){
            
            let alertController = UIAlertController(title: "Error !", message:nil, preferredStyle: .Alert)
            alertController.message = "You didn't confirm your password correctly"
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            
            let post:NSString = "nameTeam=\(nameTeam) &mdp=\(password) &idPlayer=\(idPlayer) &abbreviation=\(abbreviation) &league=\(league) &colorData=\(color)"
            
            NSLog("PostData: %@",post);
            
            let url = NSURL(string:"http://localhost:8888/Outpitch/iOScreate/create.php")!
            
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
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
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
                    
                    if(success == 1)
                    {
                        let nameJSON = jsonData.valueForKey("teamnameData") as! NSString
                        nameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        let teamnumberJSON:NSString = jsonData.valueForKey("teamnumberData") as! NSString
                        teamnumberJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        maVariableIneffacable.setObject(teamnumberJSON, forKey: "TEAMNUMBER")
                        teamnameJSON = jsonData.valueForKey("teamnameData") as! NSString
                        maVariableIneffacable.setObject(nameJSON, forKey: "NAMETEAM")
                        
                        var teamsJSON = [NSString](count:26, repeatedValue: "")
                        for i in 1...25{
                            teamsJSON[i] = jsonData.valueForKey("team" + String(i)) as! NSString
                            maVariableIneffacable.setObject(teamsJSON[i], forKey: "TEAM"+String(i))
                        }
                        
                        maVariableIneffacable.synchronize()
                        
                        Alert = 2
                        self.performSegueWithIdentifier("S_CREATED", sender: self)
                        
                    }else if(success == 0){
                        NSLog("Login échoué");
                        let alertController = UIAlertController(title: "Change something !", message: "This team name already exists !", preferredStyle: .Alert)
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
            
        }//fin du SI champs vides
        
        
        print("BG_CREATED")
    }
    
    
    /*
     If a team is well created we change the value of Alert to 2, and give it to the variable Alert of Profil.
     Same thing for the teamName.
     Then a specific message (message Alert2) will be displayed when Profile will appear as 'Congratulation you created #teamnameJson'
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_CREATED"){
            let tabCtrl       = segue.destinationViewController as! UITabBarController
            let secondViewController = tabCtrl.viewControllers![0] as! Profile
            secondViewController.Alert = self.Alert
            secondViewController.teamnameAlert = self.teamnameJSON as String
        }
    }

}
