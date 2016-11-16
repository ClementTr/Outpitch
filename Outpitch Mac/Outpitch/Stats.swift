//
//  Stats.swift
//  Outpitch
//
//  Created by Clément Tailleur on 02/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Stats: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    
    @IBOutlet weak var TF_DATE: UITextField!
    @IBOutlet weak var TF_GOALS: UITextField!
    @IBOutlet weak var TF_PENALTIES: UITextField!
    @IBOutlet weak var TF_ASSISTS: UITextField!
    @IBOutlet weak var TF_PREASSISTS: UITextField!
    @IBOutlet weak var TF_YC: UITextField!
    @IBOutlet weak var TF_RC: UITextField!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var username : NSString = ""
    
    var tab_numbers20 :[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    var tab_numbers2: [String] = ["0", "1", "2"]
    var tab_number1: [String] = ["0", "1"]
    
    var PV_GOALS = UIPickerView()
    var PV_ASSISTS = UIPickerView()
    var PV_PREASSISTS = UIPickerView()
    var PV_PENALTIES = UIPickerView()
    var PV_YC = UIPickerView()
    var PV_RC = UIPickerView()
    var DV_DATE = UIDatePicker()
    
    var dateGame = ""
    var today_date = NSDate()
    
    var toolBar = UIToolbar()
    
    var activeTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We create a date format with the today's date which will be displayed in the textfield
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let printable_date = dateFormatter.stringFromDate(today_date)
        //print(printable_date)
        TF_DATE.text = printable_date
        //We put in dateGame (variable that will be entered in database) the current date with the good format.
        dateFormatter.dateFormat = "MM-dd-yyyy"
        dateGame = dateFormatter.stringFromDate(today_date)
        
        
        username = (maVariableIneffacable.valueForKey("PSEUDO") as? String)!
        
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
        
        //Creation of the pickerviews
        
        PV_GOALS.delegate = self
        PV_GOALS.dataSource = self
        
        PV_PENALTIES.delegate = self
        PV_PENALTIES.dataSource = self
        
        PV_ASSISTS.delegate = self
        PV_ASSISTS.dataSource = self
        
        PV_PREASSISTS.delegate = self
        PV_PREASSISTS.dataSource = self
        
        PV_YC.delegate = self
        PV_YC.dataSource = self
        
        PV_RC.delegate = self
        PV_RC.dataSource = self
        
        
        //delegate Textfields
        
        TF_GOALS.delegate = self
        TF_PENALTIES.delegate = self
        TF_ASSISTS.delegate = self
        TF_PREASSISTS.delegate = self
        TF_YC.delegate = self
        TF_RC.delegate = self
        TF_DATE.delegate = self
        
        //link textfields to pickerviews, and add toolbar to the pickerviews
        
        TF_GOALS.inputView = PV_GOALS
        TF_GOALS.inputAccessoryView = toolBar
        TF_PENALTIES.inputView = PV_PENALTIES
        TF_PENALTIES.inputAccessoryView = toolBar
        TF_ASSISTS.inputView = PV_ASSISTS
        TF_ASSISTS.inputAccessoryView = toolBar
        TF_PREASSISTS.inputView = PV_PREASSISTS
        TF_PREASSISTS.inputAccessoryView = toolBar
        TF_YC.inputView = PV_YC
        TF_YC.inputAccessoryView = toolBar
        TF_RC.inputView = PV_RC
        TF_RC.inputAccessoryView = toolBar
        
        TF_DATE.inputView = DV_DATE
        TF_DATE.inputAccessoryView = toolBar
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func TF_DATE(sender: UITextField) {
        
        DV_DATE.datePickerMode = UIDatePickerMode.Date
        sender.inputView = DV_DATE
        
        DV_DATE.addTarget(self, action: #selector(Stats.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    //Functions donePicker and cancelPicker linked to Done and Cancel buttons in the toolbar
    
    func donePicker(sender: UIBarButtonItem) {
        
        if activeTextField == TF_GOALS {
            
            PV_GOALS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_PENALTIES  {
            
            PV_PENALTIES.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_ASSISTS {
            
            PV_ASSISTS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_PREASSISTS   {
            
            PV_PREASSISTS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_YC  {
            
            PV_YC.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_RC {
            PV_RC.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_DATE {
            DV_DATE.removeFromSuperview()
            toolBar.removeFromSuperview()
            
            
            DV_DATE.datePickerMode = UIDatePickerMode.Date
            let dateString = TF_DATE.text
            //let dateString = "Oct 22, 2015"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM, dd, yyyy"
            let dateObj = dateFormatter.dateFromString(dateString!)
            
            dateFormatter.dateFormat = "MM-dd-yyyy"
            
            dateGame = dateFormatter.stringFromDate(dateObj!)
            print (dateGame)
        }
    }
    
    func cancelPicker(sender: UIBarButtonItem) {
        if activeTextField == TF_GOALS  {
            
            PV_GOALS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        if activeTextField == TF_PENALTIES {
            
            PV_PENALTIES.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        if activeTextField == TF_ASSISTS {
            
            PV_ASSISTS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        if activeTextField == TF_PREASSISTS {
            
            PV_PREASSISTS.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_YC  {
            
            PV_YC.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_RC {
            PV_RC.removeFromSuperview()
            toolBar.removeFromSuperview()
        }
        else if activeTextField == TF_DATE {
            DV_DATE.removeFromSuperview()
            toolBar.removeFromSuperview()
            
        }
        else if activeTextField == TF_DATE {
            DV_DATE.removeFromSuperview()
            toolBar.removeFromSuperview()
            
            print(TF_DATE.text)
            let dateString = TF_DATE.text
            //let dateString = "Oct 22, 2015"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMM, dd, yyyy"
            let dateObj = dateFormatter.dateFromString(dateString!)
            
            dateFormatter.dateFormat = "MMddyyyy"
            
            dateGame = dateFormatter.stringFromDate(dateObj!)
            print (dateGame)
        }
        
    }
    
    
    //return the number of columns of the pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    //return the number of rows in each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == TF_GOALS  {
            
            return tab_numbers20.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_PENALTIES {
            
            return tab_numbers20.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_ASSISTS {
            
            return tab_numbers20.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_PREASSISTS {
            
            return tab_numbers20.count // A modifier selon le tab voulu
        }
        else if activeTextField == TF_YC  {
            return tab_numbers2.count
        }
        else if activeTextField == TF_RC{
            
            return tab_number1.count
        }
        else {
            
            return 0
        }
        
    }
    
    // if a row is selected, display it on the text field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == TF_GOALS{
            TF_GOALS.text = tab_numbers20[row] // A modifier selon le TF et le tab voulu
        }
        else if activeTextField == TF_PENALTIES {
            
            TF_PENALTIES.text = tab_numbers20[row]
        }
        else if activeTextField == TF_ASSISTS {
            
            TF_ASSISTS.text = tab_numbers20[row]
        }
        else if activeTextField == TF_PREASSISTS {
            
            TF_PREASSISTS.text = tab_numbers20[row]
        }
        else if activeTextField == TF_YC {
            
            TF_YC.text = tab_numbers2[row]
        }
        else if activeTextField == TF_RC {
            
            TF_RC.text = tab_number1[row]
        }
        
    }
    // set tittle for each rows
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if activeTextField == TF_GOALS  {
            
            return tab_numbers20[row] // A modifier selon le tab voulu
        }
        else if activeTextField == TF_PENALTIES  {
            
            return tab_numbers20[row]
        }
        else if activeTextField == TF_ASSISTS {
            
            return tab_numbers20[row]
        }
        else if activeTextField == TF_PREASSISTS {
            
            return tab_numbers20[row]
        }
        else if activeTextField == TF_YC  {
            return tab_numbers2[row]
        }
        else if activeTextField == TF_RC{
            
            return tab_number1[row]
        }
        else {
            
            return ""
        }
    }
    
    
    
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        TF_DATE.text = dateFormatter.stringFromDate(sender.date)
        
        let dateString = TF_DATE.text
        //let dateString = "Oct 22, 2015"
        
        dateFormatter.dateFormat = "MMM, dd, yyyy"
        let dateObj = dateFormatter.dateFromString(dateString!)
        
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        dateGame = dateFormatter.stringFromDate(dateObj!)
        print (dateGame)
        
        
        
    }
    
    
    /*
     Works as others php access. Just recover value of the key of idPlayer in order to insert datas for the good player in our php file
     with SQL.
     */
    
    @IBAction func BT_SUBMIT(sender: UIButton) {
        username.stringByReplacingOccurrencesOfString(" ", withString: "")
        let datematch:NSString = dateGame.stringByReplacingOccurrencesOfString(" ", withString: "")
        let goals:NSString = TF_GOALS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let assists:NSString = TF_ASSISTS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let penalties:NSString = TF_PENALTIES.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let preassists:NSString = TF_PREASSISTS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let yellowcard:NSString = TF_YC.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let redcard:NSString = TF_RC.text!.stringByReplacingOccurrencesOfString(" ", withString: "")
        let idPlayer = (maVariableIneffacable.valueForKey("ID") as? String)!
        
        
        if( goals.isEqualToString("") || assists.isEqualToString("") || penalties.isEqualToString("") || preassists.isEqualToString("") || yellowcard.isEqualToString("") || redcard.isEqualToString("") || datematch.isEqualToString("") )
        {
            /* si les champs sont vides */
            
            let alertController = UIAlertController(title: "Error", message: "Tape your all parameters", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
        else
        {
            
            let post:NSString = "pseudo=\(username) &goals=\(goals) &assists=\(assists) &penalties=\(penalties) &preassists=\(preassists) &yellowcard=\(yellowcard) &redcard=\(redcard) &datematch=\(datematch) &idPlayer=\(idPlayer) "
            
            NSLog("PostData: %@",post);
            
            let url = NSURL(string:"http://localhost:8888/Outpitch/iOSstats/stats.php")!
            
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
                        
                        let pseudoJSON:NSString = jsonData.valueForKey("pseudoData") as! NSString
                        let datematchJSON:NSString = jsonData.valueForKey("dateData") as! NSString
                        let goalsJSON:NSString = jsonData.valueForKey("goalsData") as! NSString
                        let assistsJSON:NSString = jsonData.valueForKey("assistsData") as! NSString
                        let preassistsJSON:NSString = jsonData.valueForKey("preassistsData") as! NSString
                        let penaltiesJSON:NSString = jsonData.valueForKey("penaltiesData") as! NSString
                        let yellowcardJSON:NSString = jsonData.valueForKey("yellowcardData") as! NSString
                        let redcardJSON:NSString = jsonData.valueForKey("redcardData") as! NSString
                        pseudoJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        datematchJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        goalsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        assistsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        preassistsJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        penaltiesJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        yellowcardJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        redcardJSON.stringByReplacingOccurrencesOfString(" ", withString: "")
                        
                        /* forKey donne les valeurs des JSON à ce que l'on met entre guillements pour les utiliser dans une autre classe. */
                        maVariableIneffacable.setObject(pseudoJSON, forKey: "PSEUDO")
                        maVariableIneffacable.setObject(datematchJSON, forKey: "DATE")
                        maVariableIneffacable.setObject(goalsJSON, forKey: "GOALS")
                        maVariableIneffacable.setObject(assistsJSON, forKey: "ASSISTS")
                        maVariableIneffacable.setObject(preassistsJSON, forKey: "PREASSISTS")
                        maVariableIneffacable.setObject(penaltiesJSON, forKey: "PENALTIES")
                        maVariableIneffacable.setObject(yellowcardJSON, forKey: "YC")
                        maVariableIneffacable.setObject(redcardJSON, forKey: "RC")
                        
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
                        
                        maVariableIneffacable.setInteger(1, forKey: "estCO")
                        maVariableIneffacable.synchronize()
                        
                        self.performSegueWithIdentifier("S_STATED", sender: self)
                        
                    }else{
                        NSLog("Login failed");
                        let alertController = UIAlertController(title: "Error", message: "Problem during the seizure.", preferredStyle: .Alert)
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
        print("BG_NEW_STATS")
    }
    
}