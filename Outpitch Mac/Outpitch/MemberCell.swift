//
//  MemberCell.swift
//  Outpitch
//
//  Created by Clément Tailleur on 15/04/2016.
//  Copyright © 2016 Clément Tailleur. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell {
    
    /*
     Same as TeamCell
     */
    @IBOutlet weak var LBL_TITLE: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(nameCell: String){
        self.LBL_TITLE.text = nameCell
    }
    
}
