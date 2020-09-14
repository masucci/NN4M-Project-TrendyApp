//
//  TableViewCell.swift
//  NN4M Project
//
//  Created by Lorenzo on 13/09/2020.
//  Copyright © 2020 Lorenzo. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var tableImage: UIImageView!
    @IBOutlet weak var tableLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var trendingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
