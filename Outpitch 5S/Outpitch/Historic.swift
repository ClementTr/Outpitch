//
//  Historic.swift
//  Outpitch
//
//  Created by Clément Tailleur on 29/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Historic: UIViewController {
    
    
    @IBOutlet weak var LBL_LAST_OPPONENT: UILabel!
    @IBOutlet weak var LBL_LAST_DATE: UILabel!
    @IBOutlet weak var LBL_LAST_SCORE: UILabel!
    @IBOutlet weak var LBL_LAST_MOTM: UILabel!
    @IBOutlet weak var LBL_LAST_FOTM: UILabel!
    @IBOutlet weak var LBL_LAST_RONALDINHO: UILabel!
    @IBOutlet weak var LBL_LAST_DIABY: UILabel!
    @IBOutlet weak var LBL_LAST_DEJONG: UILabel!

  
    @IBOutlet weak var LBL_PENULTIMATE_OPPONENT: UILabel!
    @IBOutlet weak var LBL_PENULTIMATE_DATE: UILabel!
    @IBOutlet weak var LBL_PENULTIMATE_SCORE: UILabel!
    
    
    @IBOutlet weak var VIEW_LAST_GAME: UIView!
    @IBOutlet weak var LBL_ISVOTING: UILabel!
    
    var teamName = String()
    
    
    override func viewDidLoad() {
        
        lookforhistoric()
        
    }
    
    func lookforhistoric(){
        
        let post:NSString = "teamName=\(teamName)"
        
        NSLog("PostData: %@",post);
        
        //let url = NSURL(string:"http://192.168.0.15:8888/Outpitch/iOShistoric/historic.php")!
        let url = NSURL(string:"http://172.20.10.3:8888/Outpitch/iOShistoric/historic.php")!
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
                    let lastOpponent = jsonData.valueForKey("lastOpponent") as! String
                    LBL_LAST_OPPONENT.text = "Opponent: " + lastOpponent
                    
                    let lastDate = jsonData.valueForKey("lastDate") as! String
                    LBL_LAST_DATE.text = "Date : " + lastDate
                    
                    let lastGoalsfor = jsonData.valueForKey("lastGoalsfor") as! String
                    let lastGoalsagainst = jsonData.valueForKey("lastGoalsagainst") as! String
                    
                    if(Int(lastGoalsfor) > Int(lastGoalsagainst)){
                        LBL_LAST_SCORE.text = "Victory " + lastGoalsfor + "-" + lastGoalsagainst
                    }else if(Int(lastGoalsfor) < Int(lastGoalsagainst)){
                        LBL_LAST_SCORE.text = "Defeat " + lastGoalsfor + "-" + lastGoalsagainst
                    }else if(Int(lastGoalsfor) == Int(lastGoalsagainst) && lastGoalsfor != ""){
                        LBL_LAST_SCORE.text = "Draw " + lastGoalsfor + "-" + lastGoalsagainst
                    }else{
                        LBL_LAST_SCORE.text = "No score"
                    }
                    
                    
                    let lastwinnerDiaby = jsonData.valueForKey("LastWinnerDiaby") as! String
                    LBL_LAST_DIABY.text = "Diaby Trophy : " + lastwinnerDiaby
                    
                    let lastwinnerRonaldinho = jsonData.valueForKey("LastWinnerRonaldinho") as! String
                    LBL_LAST_RONALDINHO.text = "Ronaldinho Trophy : " + lastwinnerRonaldinho
                    
                    let lastwinnerDejong = jsonData.valueForKey("LastWinnerDejong") as! String
                    LBL_LAST_DEJONG.text = "Dejong Trophy : " + lastwinnerDejong
                    
                    let lastwinnerMOTM = jsonData.valueForKey("LastWinnerMOTM") as! String
                    LBL_LAST_MOTM.text = "Man of the match : " + lastwinnerMOTM
                    
                    let lastwinnerFOTM = jsonData.valueForKey("LastWinnerFOTM") as! String
                    LBL_LAST_FOTM.text = "Fail of the match : " + lastwinnerFOTM
                    
                    
                    
                    let penultimateOpponent = jsonData.valueForKey("penultimateOpponent") as! String
                    LBL_PENULTIMATE_OPPONENT.text = "Penultimate opponent: " + penultimateOpponent
                    
                    let penultimateDate = jsonData.valueForKey("penultimateDate") as! String
                    LBL_PENULTIMATE_DATE.text = "Penultimate date : " + penultimateDate
                    
                    let penultimateGoalsfor = jsonData.valueForKey("penultimateGoalsfor") as! String
                    let penultimateGoalsagainst = jsonData.valueForKey("penultimateGoalsagainst") as! String
                    
                    if(Int(penultimateGoalsfor) > Int(penultimateGoalsagainst)){
                        LBL_PENULTIMATE_SCORE.text = "Victory " + penultimateGoalsfor + "-" + penultimateGoalsagainst
                    }else if(Int(penultimateGoalsfor) < Int(penultimateGoalsagainst)){
                        LBL_PENULTIMATE_SCORE.text = "Defeat " + penultimateGoalsfor + "-" + penultimateGoalsagainst
                    }else if(Int(penultimateGoalsfor) == Int(penultimateGoalsagainst) && penultimateGoalsfor != ""){
                        LBL_PENULTIMATE_SCORE.text = "Draw " + penultimateGoalsfor + "-" + penultimateGoalsagainst
                    }else{
                        LBL_PENULTIMATE_SCORE.text = "No score for the penultimate game"
                    }
                    
                    let votingJSON = jsonData.valueForKey("Voting") as! NSInteger
                    if(Int(votingJSON) == 0){
                        VIEW_LAST_GAME.hidden = false
                        LBL_ISVOTING.hidden = true
                    }else{
                        VIEW_LAST_GAME.hidden = true
                        LBL_ISVOTING.hidden = false
                    }
                    
                }else{
                    NSLog("Connection problem");
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
}
