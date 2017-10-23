//
//  ShoppingCell.swift
//  shoppingList
//
//  Created by Trym Lintzen on 18-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit

class ShoppingDetailCell: UITableViewCell  {
    
    @IBOutlet weak var ItemImage: UIImageView!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


    
}
