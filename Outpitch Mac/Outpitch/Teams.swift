//
//  Teams.swift
//  Outpitch
//
//  Created by Clément Tailleur on 08/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Teams: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var TV_TEAMS: UITableView!
    
    var cell_Selected = String()
    var data = [String]()
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    /*
     Here it's a table viewController
     The table view download your all clubs (lookforClub function) 
     When you connect yourself to the profile, all your team are put with loop for 
     in TEAMi object
     Same thing when you join or create a team.
     Here we just put each result in an array if the result is different from nil (not display
     empty case).
     Then each case will have for title a team.
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        lookforClub()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func lookforClub(){
        data.removeAll()
        
        for i in 1...25{
            if let tempMember = maVariableIneffacable.valueForKey("TEAM" + String(i)) as? String{
                if(tempMember != ""){
                    data.append(tempMember.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    Update()
                }
            }
        }
    }
    
    func Update(){
        TV_TEAMS.beginUpdates()
        TV_TEAMS.insertRowsAtIndexPaths([
            NSIndexPath(forRow: data.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        TV_TEAMS.endUpdates()
    }
    
    
    
    /*
     size of array data (number of team)
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    /*
     Use the class TeamCell (identifier CellTeam) for each cellule
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TeamCell = TV_TEAMS.dequeueReusableCellWithIdentifier("CellTeam") as! TeamCell
        let cellule = data[indexPath.row]
        cell.setCell(cellule) //See TeamCell
        return cell
    }
    
    /*
     cell_Selected is the name of the team corresponding of an index of our array
     if we tape on, we go to the Team window
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.cell_Selected = data[indexPath.row]
        self.performSegueWithIdentifier("S_MYTEAM", sender:self)
    }
    
    /*
     when we go to the team window, we give to the variable cellule of Team,
     the value cell_Selected (team name).
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_MYTEAM"){
            let secondViewController = segue.destinationViewController as! Team
            secondViewController.cellule = self.cell_Selected
        }
    }
    
    
    
    
    /*
     Plus button : blocked creation or registration in an existing team if you already have
     25 teams else, create dynamically a new case (in order to avoid out of range) and go to
     the window (create/join)
     
     */
    @IBAction func BT_ADD_TEAM(sender: UIBarButtonItem) {
        let teamNumber = maVariableIneffacable.valueForKey("TEAMNUMBER") as! String
        if let number = Int(teamNumber) {
            if(number>=25){
                let alertController = UIAlertController(title: "Are you full of yourself ?", message: "You can't have more than 25 teams", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                presentViewController(alertController, animated: true, completion: nil)
            }else{
                self.performSegueWithIdentifier("S_ADD", sender:self)
                data.append("New Team")
            }
        } else {
            print("'\(teamNumber)' did not convert to an Int")
        }
    }
    
    
}
