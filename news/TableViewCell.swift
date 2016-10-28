//
//  TableViewCell.swift
//  news
//
//  Created by Afionas on 10/27/16.
//  Copyright © 2016 SerhiySharga. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

   
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageViewSource: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
