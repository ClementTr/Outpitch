//
//  Password.swift
//  Outpitch
//
//  Created by Clément Tailleur on 07/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Password: UIViewController {

    @IBOutlet weak var TF_MAIL: UITextField!
    

    @IBAction func BT_FOUND(sender: UIButton) {
    
        let userEmail:NSString = TF_MAIL.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        func viewDidLoad() {
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
        
        if( userEmail.isEqualToString(""))
        {
            /* si le champs est vide */
            
            let alertController = UIAlertController(title: "Error", message: "Tape your mail adress.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            let post:NSString = "email=\(userEmail)"
            NSLog("PostData: %@",post);
            
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSmdp/mdp.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSmdp/mdp.php")!
            
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
                    NSLog("Success: %ld", success);
                    
                    
                    if(success == 1)
                    {
                        NSLog("Login OK");
                        
                        let passwordJSON:NSString = jsonData.valueForKey("passwordData") as! NSString
                        NSLog("Password : %@", passwordJSON);
                        
                        self.performSegueWithIdentifier("S_BACKREGISTER", sender: self)
                        
                        let alertController = UIAlertController(title: "Mail send", message:nil, preferredStyle: .Alert)
                        alertController.message = "Your password is: " + (passwordJSON as String);
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        presentViewController(alertController, animated: true, completion: nil)
                        
                    }else{
                        NSLog("Login failed");
                        let alertController = UIAlertController(title: "Invalide", message: "This mail adress is not in our database", preferredStyle: .Alert)
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
        
        
        
        print("BG_PASSWORD_IS_BACK")
    }
}
