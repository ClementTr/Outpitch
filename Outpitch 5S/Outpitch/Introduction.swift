//
//  Introduction.swift
//  Outpitch
//
//  Created by Clément Tailleur on 07/03/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class Introduction: UIViewController {
    
    @IBAction func BT_REGISTER(sender: UIButton){
        self.performSegueWithIdentifier("SEGUE_CONNECTION", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Lights.png")!)
    }
}
