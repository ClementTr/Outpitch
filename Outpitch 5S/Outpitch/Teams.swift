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
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : TeamCell = TV_TEAMS.dequeueReusableCellWithIdentifier("CellTeam") as! TeamCell
        let cellule = data[indexPath.row]
        cell.setCell(cellule)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.cell_Selected = data[indexPath.row]
        self.performSegueWithIdentifier("S_MYTEAM", sender:self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_MYTEAM"){
            let secondViewController = segue.destinationViewController as! Team
            secondViewController.cellule = self.cell_Selected
        }
    }
    
    
    
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
