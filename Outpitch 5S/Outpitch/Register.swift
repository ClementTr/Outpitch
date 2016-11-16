//
//  Register.swift
//  Outpitch
//
//  Created by Clément Tailleur on 07/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Register: UIViewController {
    
    @IBOutlet weak var TF_FIRSTNAME: UITextField!
    @IBOutlet weak var TF_LASTNAME: UITextField!
    @IBOutlet weak var TF_AGE: UITextField!
    @IBOutlet weak var TF_MAIL: UITextField!
    @IBOutlet weak var TF_USERNAME: UITextField!
    @IBOutlet weak var TF_PASSWORD: UITextField!
    @IBOutlet weak var TF_PASSWORDCONFIRMATION: UITextField!
    
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var alertmessage : NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func BT_REGISTER(sender: UIButton) {
        let prenom:NSString = TF_FIRSTNAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let ndfamille:NSString = TF_LASTNAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let age:NSString = TF_AGE.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let email:NSString = TF_MAIL.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let username:NSString = TF_USERNAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password:NSString = TF_PASSWORD.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if( prenom.isEqualToString("") || ndfamille.isEqualToString("") || age.isEqualToString("") || email.isEqualToString("") || username.isEqualToString("") || password.isEqualToString("")){
            let alertController = UIAlertController(title: "Erreur", message: "Tape your all parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(TF_PASSWORD.text != TF_PASSWORDCONFIRMATION.text){
            let alertController = UIAlertController(title: "Problem !", message:nil, preferredStyle: .Alert)
            alertController.message = "You didn't confirm your password correctly"
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            let post:NSString = "pseudo=\(username) &mdp=\(password) &firstname=\(prenom) &lastname=\(ndfamille) &email=\(email) &age=\(age)"
            NSLog("PostData: %@",post);
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSregister/register.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSregister/register.php")!
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
                    if(success == 2){
                        let pseudoJSON = jsonData.valueForKey("pseudo") as! NSString
                        let passwordJSON:NSString = jsonData.valueForKey("passwordData") as! NSString
                        let firstnameJSON = jsonData.valueForKey("firstnameData") as! NSString
                        let lastnameJSON:NSString = jsonData.valueForKey("lastnameData") as! NSString
                        let ageJSON:NSString = jsonData.valueForKey("ageData") as! NSString
                        let mailJSON:NSString = jsonData.valueForKey("mailData") as! NSString
                        
                        
                        pseudoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        passwordJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        firstnameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        lastnameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        ageJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        mailJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        
                        maVariableIneffacable.setObject(pseudoJSON, forKey: "PSEUDO")
                        maVariableIneffacable.setObject(passwordJSON, forKey: "PASSWORD")
                        maVariableIneffacable.setObject(firstnameJSON, forKey: "FIRSTNAME")
                        maVariableIneffacable.setObject(lastnameJSON, forKey: "LASTNAME")
                        maVariableIneffacable.setObject(ageJSON, forKey: "AGE")
                        maVariableIneffacable.setObject(mailJSON, forKey: "MAIL")
                        
                        //maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        self.performSegueWithIdentifier("S_ENDREGISTER", sender: self)
                    }else if(success == 1){
                        NSLog("Login échoué");
                        let alertController = UIAlertController(title: "We Know YOU !", message: "This username already exists.", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                    }else if(success == 0){
                        NSLog("Login échoué");
                        let alertController = UIAlertController(title: "We Know YOU !", message: "This mail adress already exists.", preferredStyle: .Alert)
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
        print("BG_REGISTER")
    }
    
    
}
