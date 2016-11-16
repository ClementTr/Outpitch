//
//  Members.swift
//  Outpitch
//
//  Created by Clément Tailleur on 15/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Members: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TV_MEMBER: UITableView!
    @IBOutlet weak var BT_TEAM: UIButton!
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var members = [String]()
    var team = String()
    var cell_Selected = String()
    
    var nationlink = String()
    var clublink = String()
    
    var friend = String()
    var position = String()
    var firstname = String()
    var lastname = String()
    var age = String()
    var goals = String()
    var assists = String()
    var penalties = String()
    var preassists = String()
    var ycard = String()
    var rcard = String()
    
    var Diaby = String()
    var MOTM = String()
    var FOTM = String()
    var Ronaldinho = String()
    var Dejong = String()
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...25{
            if let tempMember = maVariableIneffacable.valueForKey("MEMBER" + String(i)) as? String{
                if(tempMember != ""){
                    members.append(tempMember.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
                    Update()
                }
            }
        }
        
    }
    
    func Update(){
        TV_MEMBER.beginUpdates()
        TV_MEMBER.insertRowsAtIndexPaths([
            NSIndexPath(forRow: members.count-1, inSection: 0)
            ], withRowAnimation: .Automatic)
        TV_MEMBER.endUpdates()
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MemberCell = TV_MEMBER.dequeueReusableCellWithIdentifier("CellMember") as! MemberCell
        let cellule = members[indexPath.row]
        cell.setCell(cellule)
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.cell_Selected = members[indexPath.row]
        self.performSegueWithIdentifier("S_FRIEND", sender:self)
    }
    
    
    
    func myFriend(){
        
        let username = cell_Selected
        
        let post:NSString = "pseudo=\(username)"
        
        NSLog("PostData: %@",post);
        
        //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOSfriend/friend.php")!
        let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOSfriend/friend.php")!
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
                    
                    firstname = jsonData.valueForKey("firstnameData") as! String
                    lastname = jsonData.valueForKey("lastnameData") as! String
                    age  = jsonData.valueForKey("ageData") as! String
                    position = jsonData.valueForKey("positionData") as! String
                    goals = jsonData.valueForKey("goalsData") as! String
                    assists = jsonData.valueForKey("assistsData") as! String
                    preassists = jsonData.valueForKey("preassistsData") as! String
                    penalties = jsonData.valueForKey("penaltiesData") as! String
                    ycard = jsonData.valueForKey("yellowcardData") as! String
                    rcard = jsonData.valueForKey("redcardData") as! String
                    
                    Diaby = jsonData.valueForKey("numberDiaby") as! String
                    MOTM = jsonData.valueForKey("numberMOTM") as! String
                    FOTM = jsonData.valueForKey("numberFOTM") as! String
                    Ronaldinho = jsonData.valueForKey("numberRonaldinho") as! String
                    Dejong = jsonData.valueForKey("numberDejong") as! String
                    
                    nationlink = jsonData.valueForKey("nationlinkData") as! String
                    clublink = jsonData.valueForKey("clublinkData") as! String
                    
                    maVariableIneffacable.setInteger(1, forKey: "estCO")
                    maVariableIneffacable.synchronize()
                    
                }else{
                    NSLog("Login failed");
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
            if let error = reponseError
            {
                let messageErreur = (error.localizedDescription)
                alertController = UIAlertController(title: "Error", message: messageErreur, preferredStyle: .Alert)
            }
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    print("BG_CONNECTION")

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier=="S_FRIEND"){
            let secondViewController = segue.destinationViewController as! Friend
            secondViewController.friend = self.cell_Selected
            
            myFriend()
            
            secondViewController.nationlink = self.nationlink
            secondViewController.clublink = self.clublink
            
            secondViewController.position = self.position
            secondViewController.firstname = self.firstname
            secondViewController.lastname = self.lastname
            secondViewController.age = self.age
            secondViewController.goals = self.goals
            secondViewController.assists = self.assists
            secondViewController.penalties = self.penalties
            secondViewController.preassists = self.preassists
            secondViewController.ycard = self.ycard
            secondViewController.rcard = self.rcard
            
            secondViewController.Diaby = self.Diaby
            secondViewController.MOTM = self.MOTM
            secondViewController.FOTM = self.FOTM
            secondViewController.Ronaldinho = self.Ronaldinho
            secondViewController.Dejong = self.Dejong
        }
    }


}
