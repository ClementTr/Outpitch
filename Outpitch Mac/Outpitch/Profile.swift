//
//  Profil.swift
//  Outpitch
//
//  Created by Clément Tailleur on 07/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit
import Charts

class Profile: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /* We connect all the items which are not actions of the view to the code
     * the first letters indicates the type of the item:
     * IV and UIV: Image View, LBL: Labels, BC: BarChart, PC: PieChart
     */
    
    @IBOutlet weak var IV_CLUB: UIImageView!
    @IBOutlet weak var IV_NATION: UIImageView!
    @IBOutlet weak var LBL_POSITION: UILabel!
    @IBOutlet weak var LBL_FIRSTNAME: UILabel!
    @IBOutlet weak var LBL_LASTNAME: UILabel!
    @IBOutlet weak var LBL_AGE: UILabel!
    @IBOutlet weak var UIV_PP: UIImageView!
    
    @IBOutlet weak var LBL_GOALS: UILabel!
    @IBOutlet weak var LBL_ASSISTS: UILabel!
    @IBOutlet weak var LBL_PENALTIES: UILabel!
    @IBOutlet weak var LBL_PREASSISTS: UILabel!
    @IBOutlet weak var LBL_YC: UILabel!
    @IBOutlet weak var LBL_RC: UILabel!
    @IBOutlet weak var BC_BARCHART: BarChartView!
    @IBOutlet weak var PC_PIECHART: PieChartView!
    
    
    @IBOutlet weak var LBL_TROPHY_DIABY_NUMBER: UILabel!
    @IBOutlet weak var LBL_TROPHY_MOTM_NUMBER: UILabel!
    @IBOutlet weak var LBL_TROPHY_FOTM_NUMBER: UILabel!
    @IBOutlet weak var LBL_TROPHY_RONALDINHO_NUMBER: UILabel!
    @IBOutlet weak var LBL_TROPHY_DEJONG_NUMBER: UILabel!
    
    
    // We initialize ImagePicker, which is a Image Picker Controller that will be used for picking an image from the users photo library
    var ImagePicker = UIImagePickerController()
    
    // We initilize goalsSCored and assists Made to an array of doubles full of zeroes and months which is an array of String
    // Both will be used to set up the Charts for the goals scored over time and assists made.
    var goalsScored = [Double](count:12, repeatedValue: 0.0)
    var assistsMade = [Double](count:12, repeatedValue: 0.0)
    var months: [String]!
    
    //Clement
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var settings : Bool = false;
    var teamnameAlert = String()
    var Alert : Int = 0;
    var picture = String()
    var myfirstname = String()
    
    
    // The following will execute when the view appears
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We call the Trophy function
        Trophy()
        
        // We add to goalsScored and assistsMade arrays the values of the goals and assists made for each month of 2016
        for i in 1...12{
            if let tempGoalsSum2016 = maVariableIneffacable.valueForKey("GOALSSUM2016_" + String(i)) as? String{
                if let tempGoals = Double(tempGoalsSum2016){
                    goalsScored[i-1] = tempGoals
                }
            }
        }
        
        for i in 1...12{
            if let tempAssistsSum2016 = maVariableIneffacable.valueForKey("ASSISTSSUM2016_" + String(i)) as? String{
                if let tempAssists = Double(tempAssistsSum2016){
                    assistsMade[i-1] = tempAssists
                }
            }
        }
        
        // We create the array month containing the name of each month and we call the setChart function for the BarChart displaying the goalsSCored
        // And the PieChart containing the assists made.
        
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        setChart(months, values: goalsScored)
        setChart(months, values : assistsMade)
        
        
        //Clement
        picture = maVariableIneffacable.valueForKey("PICTURE") as! String
        myfirstname = maVariableIneffacable.valueForKey("FIRSTNAME") as! String
        self.LBL_FIRSTNAME.text = myfirstname
        self.LBL_LASTNAME.text = (maVariableIneffacable.valueForKey("LASTNAME") as? String)!
        self.LBL_AGE.text = (maVariableIneffacable.valueForKey("AGE") as? String)! + " ans"
        self.LBL_POSITION.text = (maVariableIneffacable.valueForKey("POSITION") as? String)!
        self.LBL_GOALS.text = (maVariableIneffacable.valueForKey("GOALS") as? String)!
        self.LBL_ASSISTS.text = (maVariableIneffacable.valueForKey("ASSISTS") as? String)!
        self.LBL_PREASSISTS.text = (maVariableIneffacable.valueForKey("PREASSISTS") as? String)!
        self.LBL_PENALTIES.text = (maVariableIneffacable.valueForKey("PENALTIES") as? String)!
        self.LBL_YC.text = (maVariableIneffacable.valueForKey("YC") as? String)!
        self.LBL_RC.text = (maVariableIneffacable.valueForKey("RC") as? String)!
        
        if(LBL_GOALS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")==""){
            LBL_GOALS.text="0"
        }
        if(LBL_ASSISTS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")==""){
            LBL_ASSISTS.text="0"
        }
        if(LBL_PREASSISTS.text!.stringByReplacingOccurrencesOfString(" ", withString: "")==""){
            LBL_PREASSISTS.text="0"
        }
        if(LBL_PENALTIES.text!.stringByReplacingOccurrencesOfString(" ", withString: "")==""){
            LBL_PENALTIES.text="0"
        }
        if(LBL_YC.text!.stringByReplacingOccurrencesOfString(" ", withString: "")==""){
            LBL_YC.text="0"
        }
        if(LBL_RC.text!.stringByReplacingOccurrencesOfString(" ", withString: "")==""){
            LBL_RC.text="0"
        }
        
        let nationLink = (maVariableIneffacable.valueForKey("NATIONLINK") as? String)!
        let clubLink = (maVariableIneffacable.valueForKey("CLUBLINK") as? String)!
        IV_NATION.image = UIImage(named: nationLink)
        IV_CLUB.image = UIImage(named: clubLink)
        UIV_PP.image = UIImage(named: picture)
        
        ImagePicker.delegate = self
    }
    
    //Clement
    override func viewDidAppear(animated: Bool) {
        Trophy()
    }
    
    // We add to the labels displaying the numbers of trophies won the numbers of each trophy storred in database that the user won.
    // If he did not win any trophy we put a default value: 0. The action is repeated for each type of trophy.
    func Trophy(){
        if let diabyTrophy = maVariableIneffacable.valueForKey("DIABYTROPHY") as? String{
            if(diabyTrophy != ""){
                LBL_TROPHY_DIABY_NUMBER.text = diabyTrophy
            }else{
                LBL_TROPHY_DIABY_NUMBER.text = "0"
            }
        }else{
            LBL_TROPHY_DIABY_NUMBER.text = "0"
        }
        
        if let MOTMTrophy = maVariableIneffacable.valueForKey("MOTMTROPHY") as? String{
            if(MOTMTrophy != ""){
                LBL_TROPHY_MOTM_NUMBER.text = MOTMTrophy
            }else{
                LBL_TROPHY_MOTM_NUMBER.text = "0"
            }
        }else{
            LBL_TROPHY_MOTM_NUMBER.text = "0"
        }
        
        if let FOTMTrophy = maVariableIneffacable.valueForKey("FOTMTROPHY") as? String{
            if(FOTMTrophy != ""){
                LBL_TROPHY_FOTM_NUMBER.text = FOTMTrophy
            }else{
                LBL_TROPHY_FOTM_NUMBER.text = "0"
            }
        }else{
            LBL_TROPHY_FOTM_NUMBER.text = "0"
        }
        
        if let RonaldinhoTrophy = maVariableIneffacable.valueForKey("RONALDINHOTROPHY") as? String{
            if(RonaldinhoTrophy != ""){
                LBL_TROPHY_RONALDINHO_NUMBER.text = RonaldinhoTrophy
            }else{
                LBL_TROPHY_RONALDINHO_NUMBER.text = "0"
            }
        }else{
            LBL_TROPHY_RONALDINHO_NUMBER.text = "0"
        }
        
        if let DejongTrophy = maVariableIneffacable.valueForKey("DEJONGTROPHY") as? String{
            if(DejongTrophy != ""){
                LBL_TROPHY_DEJONG_NUMBER.text = DejongTrophy
            }else{
                LBL_TROPHY_DEJONG_NUMBER.text = "0"
            }
        }else{
            LBL_TROPHY_DEJONG_NUMBER.text = "0"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* The setChart function is used to display the charts on the display area. using the Charts API
     * The function takes 2 arguments, the dataPoints which are an array of String and the values, an array of Double
     * We first check if the values are the goalsScored or assistsMade to see if we want to display a BarChart or a PieChart.
     * We create an array containing all the values and an Index then we set de data of the chart and configure the aspect of the chart.
     */
    func setChart(dataPoints: [String], values: [Double]) {
        if values == goalsScored {
            BC_BARCHART.noDataText = "You need to provide data for the chart."
            var dataEntries: [BarChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Goals Scored")
            chartDataSet.colors = [UIColor(red: 255/255, green: 126/255, blue: 34/255, alpha: 1)]
            let chartData = BarChartData(xVals: months, dataSet: chartDataSet)
            BC_BARCHART.data = chartData
            
            BC_BARCHART.xAxis.labelPosition = .Bottom
            BC_BARCHART.backgroundColor = UIColor(red: 189/255, green: 195/255, blue: 199/255, alpha: 1)
            
        }
        else if values == assistsMade {
            PC_PIECHART.noDataText = "You need to provide data for the chart."
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
            let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
            PC_PIECHART.data = pieChartData
            
            var colors: [UIColor] = []
            // this is used to generate colors randomly for the different parts of the Piechart
            for i in 0..<dataPoints.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
            
            pieChartDataSet.colors = colors
            
        }
    }
    
    /* These two functions are used for picking an image from the users photo library and displaying it on the Image View.
     */
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            UIV_PP.contentMode = .ScaleAspectFit
            UIV_PP.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* This function is called when the user clicks on the Settings button.
     * We create an alert that will pop up containing actions, ChangePictureAction to change the picture, Parameters to change the user settings
     * Logout for loging out and cancel for cancelling the alert.
     * if the user clicks on Change Picture, an another alert pops out with 2 actions, using a personnal picture or a picture of our own database
     * if the user wants to use a proposed picture, it will send him to the Picture.swift screen, if he wants his own picture it will show up an image picker view.
     * if the user wants to edit his parameters, it will send him to Parameter.swift, if he wants to logout he will be send to the home page and logged out.
     */
    @IBAction func BT_SETTINGS(sender: UIButton) {
        let alert = UIAlertController()
        
        let ChangePictureAction = UIAlertAction(title:"Change profile picture", style: .Default){
            (alert:UIAlertAction!) -> Void in
            NSLog("ChangePicture pressed")
            
            let pictureAlert = UIAlertController(title: "Changing profile picture", message: "How do you want to change your picture?", preferredStyle: .Alert)
            // Create the actions
            let predefinedPictureAction = UIAlertAction(title: "Use pre-defined picture", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                self.performSegueWithIdentifier("S_PROFILE_PICTURE", sender: self)
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
        let ParametersAction = UIAlertAction(title: "Parameters", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            NSLog("Parameters pressed")
            self.performSegueWithIdentifier("S_PARAMETERS", sender: self)
            
        }
        
        let LogoutAction = UIAlertAction(title: "Logout", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            NSLog("Logout pressed")
            NSUserDefaults.standardUserDefaults()
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
            self.performSegueWithIdentifier("S_LOGOUT", sender: self)
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (alert: UIAlertAction!) -> Void in
            NSLog("Cancel pressed")
        }
        
        alert.addAction(ChangePictureAction)
        alert.addAction(ParametersAction)
        alert.addAction(LogoutAction)
        alert.addAction(CancelAction)
        presentViewController(alert, animated: true, completion:nil)
    }
    
    
    /* This is used for when the user is sent back to Profile page after having done an action.
     * If the user comes back here after joining a team it will pop up the appropriate alert.
     * Same things if he comes back after creating a team, leaving a team, connectiong for the first time, or changing his profile picture. */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(Alert == 1){
            let alertController = UIAlertController(title: "Congratulations !", message:nil, preferredStyle: .Alert)
            alertController.message = "You officially joined " + (teamnameAlert as String);
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(Alert == 2){
            let alertController = UIAlertController(title: "Congratulations !", message:nil, preferredStyle: .Alert)
            alertController.message = "You officially created " + (teamnameAlert as String);
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(Alert == 3){
            let alertController = UIAlertController(title: "Soooooo Bad !", message:nil, preferredStyle: .Alert)
            alertController.message = "You officially left " + (teamnameAlert as String);
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(Alert == 4){
            let alertController = UIAlertController(title: "Congratulations !", message:nil, preferredStyle: .Alert)
            alertController.message = "Welcome on Outpitch " + myfirstname;
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }else if(Alert == 5){
            let alertController = UIAlertController(title: "Well done chief !", message:nil, preferredStyle: .Alert)
            alertController.message = "We changed your picture " + (myfirstname as String) + " !";
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        Alert = 0
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="S_PROFILE_PICTURE"){
            let secondViewController = segue.destinationViewController as! Picture
            secondViewController.picture = self.picture
        }
    }
}