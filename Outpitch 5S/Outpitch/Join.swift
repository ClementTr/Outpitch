//
//  Join.swift
//  Outpitch
//
//  Created by Clément Tailleur on 09/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Join: UIViewController {

    @IBOutlet weak var TF_NAME: UITextField!
    @IBOutlet weak var TF_PASSWORD: UITextField!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var Alert = Int()
    var teamnameJSON = NSString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func BT_JOIN(sender: UIButton) {
        let teamName:NSString = TF_NAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password:NSString = TF_PASSWORD.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        
        if( teamName.isEqualToString("") || password.isEqualToString("") )
        {
            /* si les champs sont vides */
            
            let alertController = UIAlertController(title: "Error", message: "Tape your parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
            let post:NSString = "teamName=\(teamName) &mdp=\(password) &idPlayer=\(idPlayer)"
            
            NSLog("PostData: %@",post);
            
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSjoin/join.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSjoin/join.php")!
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
                        let teamnumberJSON:NSString = jsonData.valueForKey("teamnumberData") as! NSString
                        teamnumberJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        maVariableIneffacable.setObject(teamnumberJSON, forKey: "TEAMNUMBER")
                        teamnameJSON = jsonData.valueForKey("teamnameData") as! NSString
                        
                        var teamsJSON = [NSString](count:26, repeatedValue: "")
                        for i in 1...25{
                            teamsJSON[i] = jsonData.valueForKey("team" + String(i)) as! NSString
                            maVariableIneffacable.setObject(teamsJSON[i], forKey: "TEAM"+String(i))
                        }

                        maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        Alert = 1
                        self.performSegueWithIdentifier("S_JOINED", sender: self)
                        
                        print("BG_NEW_PLAYER")
                        
                    }else if(success == 2){
                        let alertController = UIAlertController(title: "Error", message: "You seem to be already in this team", preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                    }else{
                        NSLog("Login failed");
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
        print("BG_JOINED")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_JOINED"){
            let tabCtrl       = segue.destinationViewController as! UITabBarController
            let secondViewController = tabCtrl.viewControllers![0] as! Profile
            secondViewController.Alert = self.Alert
            secondViewController.teamnameAlert = self.teamnameJSON as String
        }
    }
    
    

}
