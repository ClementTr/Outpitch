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
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(true)
        
        sleep(2)
        let estLog = maVariableIneffacable.integerForKey("estCO") as Int
        if(estLog == 1){
            self.performSegueWithIdentifier("S_ALREADYCO", sender: self)
        }
        else{
            self.performSegueWithIdentifier("S_NOTCO", sender: self)
        }
    }
}
