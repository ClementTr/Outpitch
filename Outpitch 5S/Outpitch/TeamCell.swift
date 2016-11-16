//
//  TeamCell.swift
//  Outpitch
//
//  Created by Clément Tailleur on 14/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    
    @IBOutlet weak var LBL_TITLE: UILabel!
    
    func setCell(nameCell: String){
        self.LBL_TITLE.text = nameCell
    }
    
}
