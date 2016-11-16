//
//  Presentation.swift
//  Outpitch
//
//  Created by Clément Tailleur on 08/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Presentation: UIViewController {
    
    let maVariableIneffacable:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    /*
     Function called when window appears. Without doing anything.
     */
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        
        /*
         Wait two seconds in order to show our icon
         */
        sleep(2)
        
        /*
         Then look for the key 'estCo'. This key is put to 1 when you connect yourself to your outpitch profile.
         And is put to 0 when you disconnect. 
         It allows the automatic connection.
         We give its value to estLog. If estCo = estLog equals 1, it's mean your are already connect
         and it sent you directly to your profile using (S_ALREADYCO) segue (See Main.storyboard : identifier for each segue (arrow
         between windows) ).
         Else it sent you to connection window using (S_NOTCO) segue.
         */
        let estLog = maVariableIneffacable.integerForKey("estCO") as Int
        if(estLog == 1){
            self.performSegueWithIdentifier("S_ALREADYCO", sender: self)
        }
        else{
            self.performSegueWithIdentifier("S_NOTCO", sender: self)
        }
    }
}
