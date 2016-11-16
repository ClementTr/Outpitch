//
//  Introduction.swift
//  Outpitch
//
//  Created by Clément Tailleur on 07/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Introduction: UIViewController {
    
    
    /*
     When you press Register Button, this action happen.
     It just look for the segue 'SEGUE_CONNECTION' and the follow the link to show an other window 
     ("Here it's connection window")
     */
    @IBAction func BT_REGISTER(sender: UIButton){
        self.performSegueWithIdentifier("SEGUE_CONNECTION", sender: self)
    }
    
    
    /*
     Chnage background of the window with image 'Lights.png' in Resources file.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Lights.png")!)
    }
}
