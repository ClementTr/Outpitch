//
//  Settings.swift
//  Outpitch
//
//  Created by Clément Tailleur on 29/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Settings: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var TF_PASSWORD: UITextField!
    @IBOutlet weak var TF_PASSWORD_CONFIRMATION: UITextField!
    @IBOutlet weak var TF_LEAGUE: UITextField!
    @IBOutlet weak var TF_ABBREVIATION: UITextField!
    @IBOutlet weak var TF_COLOR: UITextField!
    
    var myabbreviation = String()
    var myleague = String()
    var mycolor = String()
    var teamName = String()
    var name = String()
    var Alert = Int()
    
    var PV_COLORS = UIPickerView()
    var toolBar = UIToolbar()
    var activeTextField = UITextField()
    var tab_colors: [String] = ["", "Azure", "Black", "Blue", "Green", "Red", "White", "Yellow"]
    
    override func viewDidLoad() {
        TF_LEAGUE.text = myleague
        TF_ABBREVIATION.text = myabbreviation
        TF_COLOR.text = mycolor
        
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

            
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    
    
    
    @IBAction func BT_UPDATE(sender: UIButton) {
        
        let league:NSString = TF_LEAGUE.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let mdp:NSString = TF_PASSWORD.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let abbreviation:NSString = TF_ABBREVIATION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password_confirmation:NSString = TF_PASSWORD_CONFIRMATION.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let colorData:NSString = TF_COLOR.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if( league.isEqualToString("") || mdp.isEqualToString("") || password_confirmation.isEqualToString("") || abbreviation.isEqualToString("")){
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
            let post:NSString = "league=\(league) &mdp=\(mdp) &teamName=\(teamName) &abbreviation=\(abbreviation) &colorData=\(colorData)"
            
            NSLog("PostData: %@",post);
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSsettings/settings.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSsettings/settings.php")!
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
                                        
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    NSLog("Success: %ld", success);
                    
                    if(success == 1){
                        name = jsonData.valueForKey("nameData") as! String
                        name.stringByReplacingOccurrencesOfString(" ", withString: "")
                        
                        Alert = 5
                        print("BG_PARAMETRES")
                        self.performSegueWithIdentifier("S_BACK_SETTINGS", sender: self)
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_BACK_SETTINGS"){
            let secondViewController = segue.destinationViewController as! Team
            secondViewController.cellule = self.name
            secondViewController.Alert = self.Alert
        }
    }
    
}
