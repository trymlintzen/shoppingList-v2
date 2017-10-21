//
//  shoppingItems.swift
//  shoppingList
//
//  Created by Trym Lintzen on 16-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation
import UIKit

class ShoppingItems {
    
    var name: String
    var price: Double
    var weight: Double
    var photo: UIImage = UIImage()
    var photoUrlString: String
    var details: String
    var id : String = NSUUID().uuidString

    init(name: String, price: Double, weight: Double, photoUrlString: String, details: String) {
        self.name = name
        self.price = price
        self.weight = weight
        self.photoUrlString = photoUrlString
        self.details = details
    }
}
