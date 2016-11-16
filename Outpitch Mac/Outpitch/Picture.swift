//
//  Picture.swift
//  Outpitch
//
//  Created by Clément Tailleur on 03/05/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Picture: UIViewController {
    
    
    @IBOutlet weak var IV_PROFILE_PICTURE: UIImageView!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var picture = String()
    var pp = String()
    var Alert = Int()
    
    override func viewDidLoad() {
        IV_PROFILE_PICTURE.image = UIImage(named: picture)
    }
    
    func changePicture(photoNumber : Int){
        pp = "Profile_" + String(photoNumber) + ".png"
        IV_PROFILE_PICTURE.image = UIImage(named: pp)
        if(photoNumber == 1){
            pp = "Jack.png"
            IV_PROFILE_PICTURE.image = UIImage(named: pp)
        }
    }
    
    /*
     Create as many button function as number of pre defined picture, calling different number (representing
     the specifi picture of the button)
     We have 16 pictures called 'Profile_i.png' so we just change the value of the number in 'pp'
     */
    
    @IBAction func BT_IMAGE_1(sender: UIButton) {
        changePicture(1)
    }
    
    @IBAction func BT_IMAGE_2(sender: UIButton) {
        changePicture(2)
    }
    
    @IBAction func BT_IMAGE_3(sender: UIButton) {
        changePicture(3)
    }
    
    @IBAction func BT_IMAGE_4(sender: UIButton) {
        changePicture(4)
    }
    
    @IBAction func BT_IMAGE_5(sender: UIButton) {
        changePicture(5)
    }
    
    @IBAction func BT_IMAGE_6(sender: UIButton) {
        changePicture(6)
    }
    
    @IBAction func BT_IMAGE_7(sender: UIButton) {
        changePicture(7)
    }
    
    @IBAction func BT_IMAGE_8(sender: UIButton) {
        changePicture(8)
    }
    
    @IBAction func BT_IMAGE_9(sender: UIButton) {
        changePicture(9)
    }
    
    @IBAction func BT_IMAGE_10(sender: UIButton) {
        changePicture(10)
    }
    
    @IBAction func BT_IMAGE_11(sender: UIButton) {
        changePicture(11)
    }
    
    @IBAction func BT_IMAGE_12(sender: UIButton) {
        changePicture(12)
    }
    
    @IBAction func BT_IMAGE_13(sender: UIButton) {
        changePicture(13)
    }
    
    @IBAction func BT_IMAGE_14(sender: UIButton) {
        changePicture(14)
    }
    
    @IBAction func BT_IMAGE_15(sender: UIButton) {
        changePicture(15)
    }
    
    @IBAction func BT_IMAGE_16(sender: UIButton) {
        changePicture(16)
    }
    
    
    
    @IBAction func BT_CANCEL(sender: UIButton) {
        self.performSegueWithIdentifier("S_CANCEL_PICTURE", sender: self)
    }
    
    /*
     Use ID_Player of key in order to insert 'pp' global value define in the class and set by clicking
     on a specific button (1-16)
     */
    
    
    @IBAction func BT_VALIDATE(sender: UIButton) {
        let myID = maVariableIneffacable.valueForKey("ID") as! String
        
        let post:NSString = "idPlayer=\(myID) &picture=\(pp)"
            
        NSLog("PostData: %@",post);
            
        let url = NSURL(string:"http://localhost:8888/Outpitch/iOSpicture/picture.php")!
            
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
                    pp = jsonData.valueForKey("pictureData") as! String
                    pp = pp.stringByReplacingOccurrencesOfString(" ", withString: "")
                    maVariableIneffacable.setObject(pp, forKey: "PICTURE")
                    
                    Alert = 5
                    self.performSegueWithIdentifier("S_CANCEL_PICTURE", sender: self)
                    
                }else{
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="S_CANCEL_PICTURE"){
            let tabCtrl       = segue.destinationViewController as! UITabBarController
            let secondViewController = tabCtrl.viewControllers![0] as! Profile
            secondViewController.Alert = self.Alert
        }
    }
    
}
