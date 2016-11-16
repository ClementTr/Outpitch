//
//  Game.swift
//  Outpitch
//
//  Created by Clément Tailleur on 21/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Game: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var TF_DATE: UITextField!
    @IBOutlet weak var TF_GOALS_US: UITextField!
    @IBOutlet weak var TF_GOALS_THEM: UITextField!
    
    
    @IBOutlet weak var TF_OPPONENT: UITextField!
    
    var teamName = String()
    
    var tab_numbers20 :[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    var DV_DATE = UIDatePicker()
    var PV_GOALS_US = UIPickerView()
    var PV_GOALS_THEM = UIPickerView()
    var toolBar = UIToolbar()
    
    var activeTextField = UITextField()
    
    var today_date = NSDate()
    var dateGame = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We create a date format with the today's date which will be displayed in the textfield
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let printable_date = dateFormatter.stringFromDate(today_date)
        //print(printable_date)
        TF_DATE.text = printable_date
        //We put in dateGame (variable that will be entered in database) the current date with the good format.
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateGame = dateFormatter.stringFromDate(today_date)
        
        //Creation of the toolbar
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 3/255, green: 14/255, blue: 138/255, alpha: 1)
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action:#selector(Stats.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(Stats.cancelPicker(_:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //delegate
        TF_DATE.delegate = self
        
        TF_GOALS_US.delegate = self
        PV_GOALS_US.delegate = self
        PV_GOALS_US.dataSource = self
        
        TF_GOALS_THEM.delegate = self
        PV_GOALS_THEM.delegate = self
        PV_GOALS_THEM.dataSource = self
        
        //link TF and pickerviews/toolbars
        TF_DATE.inputView = DV_DATE
        TF_DATE.inputAccessoryView = toolBar
        
        TF_GOALS_US.inputView = PV_GOALS_US
        TF_GOALS_US.inputAccessoryView = toolBar
        
        TF_GOALS_THEM.inputView = PV_GOALS_THEM
        TF_GOALS_THEM.inputAccessoryView = toolBar
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func TF_DATE(sender: UITextField) {
        DV_DATE.datePickerMode = UIDatePickerMode.Date
        sender.inputView = DV_DATE
        
        DV_DATE.addTarget(self, action: #selector(Stats.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    func donePicker(sender: UIBarButtonItem) {
        if activeTextField == TF_DATE {
            DV_DATE.removeFromSuperview()
            toolBar.removeFromSuperview()
            
            DV_DATE.datePickerMode = UIDatePickerMode.Date
            let dateString = TF_DATE.text
            //let dateString = "Oct 22, 2015"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM, dd, yyyy"
            let dateObj = dateFormatter.dateFromString(dateString!)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            dateGame = dateFormatter.stringFromDate(dateObj!)
            print (dateGame)
        }
        else if activeTextField == TF_GOALS_US{
            PV_GOALS_US.removeFromSuperview()
            toolBar.removeFromSuperview()
            
        }
        else if activeTextField == TF_GOALS_THEM{
            PV_GOALS_THEM.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        if activeTextField == TF_DATE {
            DV_DATE.removeFromSuperview()
            toolBar.removeFromSuperview()
            
            DV_DATE.datePickerMode = UIDatePickerMode.Date
            let dateString = TF_DATE.text
            //let dateString = "Oct 22, 2015"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            let dateObj = dateFormatter.dateFromString(dateString!)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            dateGame = dateFormatter.stringFromDate(dateObj!)
            print (dateGame)
        }
        else if activeTextField == TF_GOALS_US{
            PV_GOALS_US.removeFromSuperview()
            toolBar.removeFromSuperview()
            
        }
        else if activeTextField == TF_GOALS_THEM{
            PV_GOALS_THEM.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        TF_DATE.text = dateFormatter.stringFromDate(sender.date)
        let dateString = TF_DATE.text
        //let dateString = "Oct 22, 2015"
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateObj = dateFormatter.dateFromString(dateString!)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dateGame = dateFormatter.stringFromDate(dateObj!)
        print (dateGame)
        
    }
    //return the number of columns of the pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    //return the number of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == TF_GOALS_US  {
            
            return tab_numbers20.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_GOALS_THEM{
            return tab_numbers20.count
        }
        else {
            return 0
        }
    }
    
    // if a row is selected, display it on the text field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == TF_GOALS_US {
            TF_GOALS_US.text = tab_numbers20[row] // A modifier selon le TF et le tab voulu
        }
        else if activeTextField == TF_GOALS_THEM {
            TF_GOALS_THEM.text = tab_numbers20[row]
        }
    }
    // set tittle for each rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == TF_GOALS_US  {
            
            return tab_numbers20[row] // A modifier selon le tab voulu
        }
        else if activeTextField == TF_GOALS_THEM {
            
            return tab_numbers20[row]
        }
        else {
            return ""
        }
    }
    
    
    @IBAction func BT_START_VOTE(sender: UIButton) {

        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        teamName = (maVariableIneffacable.valueForKey("TEAMNAME") as? String)!
        let matchdate : NSString = TF_DATE.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let goalsUs : NSString = TF_GOALS_US.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let goalsTheme : NSString = TF_GOALS_THEM.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let opponent : NSString = TF_OPPONENT.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let dateBegin = NSDate()
        let hoursToAddInSeconds: NSTimeInterval = 86400 //ADD 24h
        let dateEnd = dateBegin.dateByAddingTimeInterval(hoursToAddInSeconds)
        let dateEndString = dateFormatter.stringFromDate(dateEnd)
        
        
        if( idPlayer == "" || teamName == "" || matchdate.isEqualToString("") || goalsUs.isEqualToString("") || goalsTheme.isEqualToString("") || opponent.isEqualToString("") ){
            
            let alertController = UIAlertController(title: "Erreur", message: "Tape your all parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }else{
            
            let post:NSString = "idPlayer=\(idPlayer) &teamName=\(teamName) &timeInsert=\(dateEndString) &matchDate=\(dateGame) &goalsUs=\(goalsUs) &goalsTheme=\(goalsTheme) &opponent=\(opponent)"
            
            NSLog("PostData: %@",post);
            
            //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSgame/game.php")!
            let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSgame/game.php")!
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
                        
                        maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        self.performSegueWithIdentifier("S_GAME_BACK", sender:self)
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
            print("BG_BEGIN_TROPHY")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_GAME_BACK"){
            let secondViewController = segue.destinationViewController as! Team
            secondViewController.cellule = self.teamName
        }
    }
    
    
    
}
