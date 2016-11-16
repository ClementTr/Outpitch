//
//  Connection.swift
//  Outpitch
//
//  Created by Clément Tailleur on 06/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Connection: UIViewController {
    
    @IBOutlet weak var TF_USERNAME: UITextField!
    @IBOutlet weak var TF_PASSWORD: UITextField!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
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
    
    
    @IBAction func BT_CONNECTION(sender: UIButton) {
        
        /*
         This methode is the main way to connect our code to our database.
         So it's called often in our program and we will just explain it in this page because
         it's the same process everywhere using different variables.
         */
        
        
        /*
         Here, we create two variable which take value from textfield and removing white sapces.
         */
        let username:NSString = TF_USERNAME.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let password:NSString = TF_PASSWORD.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        /*
         First we check if these variables are empty. If they are, we display a pop up saying
         that we have to complete all the textfields.
         */
        if( username.isEqualToString("") || password.isEqualToString("") ){
            let alertController = UIAlertController(title: "Error", message: "Tape your all parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else{
            /*
             Then, if parameters are well taped, we create a post of type NSString.
             Here, 'pseudo' and 'mdp' have to be present in html file, they will take respectively values
             of 'username' and 'password'.
             */
            let post:NSString = "pseudo=\(username) &mdp=\(password)"
            NSLog("PostData: %@",post);
            /*
             Then, we specify the url of our php file which contain our requests using
             type NSURL.
             */
            //let url = NSURL(string:"http://localhost:8888/Outpitch/iOSlogin/login.php")!
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSlogin/login.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSlogin/login.php")!
            /*
             Here we decided to encoding our values with UTF8 characters for accent that
             french alphabet use a lot.
             */
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
            
            /*
             Then we try a connection using our url all request defined before.
             */
            var urlData: NSData?
            do {
                urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
            } catch _ as NSError {
                urlData = nil
            } catch {
                fatalError()
            }
            
            /*
             If there is a problem, the error will be catch, and urlData will be nil
             Else...
             */
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                NSLog("Response code: %ld", res.statusCode);
                
                /*
                 And depending of if the connection is ok or not (can be a problem with php code)
                 res will return a different number. We consider that there is a connection problem
                 if res is not between 200 and 300.
                 */
                if (res.statusCode >= 200 && res.statusCode < 300){
                    let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData);
                    var error: NSError?
                    
                    
                    /*
                     Here we try recover JSON values from the .php file.
                     */
                    var jsonData:NSDictionary = NSDictionary()
                    do {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(urlData!,options:NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    }catch {
                        // handle error
                    }
                    
                    /*
                     This is how recover 'erreur' from .php file and give its value to success.
                     If erreur = 1 : there is no error (the request found your username
                     in our databse)
                     */
                    let success:NSInteger = jsonData.objectForKey("erreur") as! NSInteger
                    NSLog("Success: %ld", success);
                    if(success == 1){
                        /*
                         We recover all JSON value that .php file return
                         */
                        let idJSON:NSString = jsonData.valueForKey("idData") as! NSString
                        let pseudoJSON:NSString = jsonData.valueForKey("pseudoData") as! NSString
                        let pictureJSON:NSString = jsonData.valueForKey("pictureData") as! NSString
                        let passwordJSON:NSString = jsonData.valueForKey("passwordData") as! NSString
                        let firstnameJSON:NSString = jsonData.valueForKey("firstnameData") as! NSString
                        let lastnameJSON:NSString = jsonData.valueForKey("lastnameData") as! NSString
                        let ageJSON:NSString = jsonData.valueForKey("ageData") as! NSString
                        let mailJSON:NSString = jsonData.valueForKey("mailData") as! NSString
                        let positionJSON:NSString = jsonData.valueForKey("positionData") as! NSString
                        let nationlinkJSON:NSString = jsonData.valueForKey("nationlinkData") as! NSString
                        let clublinkJSON:NSString = jsonData.valueForKey("clublinkData") as! NSString
                        let nationJSON:NSString = jsonData.valueForKey("nationData") as! NSString
                        let clubJSON:NSString = jsonData.valueForKey("clubData") as! NSString
                        let goalsJSON:NSString = jsonData.valueForKey("goalsData") as! NSString
                        let assistsJSON:NSString = jsonData.valueForKey("assistsData") as! NSString
                        let preassistsJSON:NSString = jsonData.valueForKey("preassistsData") as! NSString
                        let penaltiesJSON:NSString = jsonData.valueForKey("penaltiesData") as! NSString
                        let yellowcardJSON:NSString = jsonData.valueForKey("yellowcardData") as! NSString
                        let redcardJSON:NSString = jsonData.valueForKey("redcardData") as! NSString
                        let teamnumberJSON:NSString = jsonData.valueForKey("teamnumberData") as! NSString
                        let diabyJSON:NSString = jsonData.valueForKey("numberDiaby") as! NSString
                        let MOTMJSON = jsonData.valueForKey("numberMOTM") as! NSString
                        let FOTMJSON:NSString = jsonData.valueForKey("numberFOTM") as! NSString
                        let RonaldinhoJSON = jsonData.valueForKey("numberRonaldinho") as! NSString
                        let DejongJSON:NSString = jsonData.valueForKey("numberDejong") as! NSString
                        
                        /*
                         We remove all white spaces that requests could create in .php file
                         */
                        idJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        pseudoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        pictureJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        passwordJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        firstnameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        lastnameJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        ageJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        mailJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        positionJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        nationJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        clubJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        nationlinkJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        clublinkJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        goalsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        assistsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        preassistsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        penaltiesJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        yellowcardJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        redcardJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        teamnumberJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        diabyJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        MOTMJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        FOTMJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        RonaldinhoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        DejongJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        
                        /*
                         We give for each of our values an NSUserDefaults type. This type allow us
                         to use values everywhere in the code. They are register as key and can be refound
                         when you close the app.
                         */
                        maVariableIneffacable.setObject(idJSON, forKey: "ID")
                        maVariableIneffacable.setObject(pseudoJSON, forKey: "PSEUDO")
                        maVariableIneffacable.setObject(pictureJSON, forKey: "PICTURE")
                        maVariableIneffacable.setObject(passwordJSON, forKey: "PASSWORD")
                        maVariableIneffacable.setObject(firstnameJSON, forKey: "FIRSTNAME")
                        maVariableIneffacable.setObject(lastnameJSON, forKey: "LASTNAME")
                        maVariableIneffacable.setObject(ageJSON, forKey: "AGE")
                        maVariableIneffacable.setObject(mailJSON, forKey: "MAIL")
                        maVariableIneffacable.setObject(positionJSON, forKey: "POSITION")
                        maVariableIneffacable.setObject(nationlinkJSON, forKey: "NATIONLINK")
                        maVariableIneffacable.setObject(clublinkJSON, forKey: "CLUBLINK")
                        maVariableIneffacable.setObject(nationJSON, forKey: "NATION")
                        maVariableIneffacable.setObject(clubJSON, forKey: "CLUB")
                        maVariableIneffacable.setObject(goalsJSON, forKey: "GOALS")
                        maVariableIneffacable.setObject(assistsJSON, forKey: "ASSISTS")
                        maVariableIneffacable.setObject(preassistsJSON, forKey: "PREASSISTS")
                        maVariableIneffacable.setObject(penaltiesJSON, forKey: "PENALTIES")
                        maVariableIneffacable.setObject(yellowcardJSON, forKey: "YC")
                        maVariableIneffacable.setObject(redcardJSON, forKey: "RC")
                        maVariableIneffacable.setObject(teamnumberJSON, forKey: "TEAMNUMBER")
                        maVariableIneffacable.setObject(diabyJSON, forKey: "DIABYTROPHY")
                        maVariableIneffacable.setObject(MOTMJSON, forKey: "MOTMTROPHY")
                        maVariableIneffacable.setObject(FOTMJSON, forKey: "FOTMTROPHY")
                        maVariableIneffacable.setObject(RonaldinhoJSON, forKey: "RONALDINHOTROPHY")
                        maVariableIneffacable.setObject(DejongJSON, forKey: "DEJONGTROPHY")
                        
                        var teamsJSON = [NSString](count:26, repeatedValue: "")
                        for i in 1...25{
                            teamsJSON[i] = jsonData.valueForKey("team" + String(i)) as! NSString
                            maVariableIneffacable.setObject(teamsJSON[i], forKey: "TEAM"+String(i))
                        }
                        
                        var goalssum2016JSON = [NSString](count:13, repeatedValue: "")
                        for i in 1...12{
                            goalssum2016JSON[i] = jsonData.valueForKey("goalsSum2016_" + String(i)) as! NSString
                            self.maVariableIneffacable.setObject(goalssum2016JSON[i], forKey: "GOALSSUM2016_"+String(i))
                        }
                        
                        var assistssum2016JSON = [NSString](count:13, repeatedValue: "")
                        for j in 1...12{
                            assistssum2016JSON[j] = jsonData.valueForKey("assistsSum2016_" + String(j)) as! NSString
                            self.maVariableIneffacable.setObject(assistssum2016JSON[j], forKey: "ASSISTSSUM2016_"+String(j))
                        }
                        
                        /*
                         Allow use automatic connection
                         */
                        maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        /*
                         Take segue S_CONNECTION that show directly profile window.
                         */
                        self.performSegueWithIdentifier("S_CONNECTION", sender: self)
                    }else{
                        /*
                         If there is a problem, we show an alert message
                         */
                        let alertController = UIAlertController(title: "Error", message: "Identifiers don't match", preferredStyle: .Alert)
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

