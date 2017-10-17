//
//  ShoppingItemService.swift
//  shoppingList
//
//  Created by Trym Lintzen on 16-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation

class ShoppingItemService {
    
    static func createShoppingItemObjects()  {
       let paella = ShoppingItems.init(name: "paella", price: 5.0, weight: 50.0, photo: #imageLiteral(resourceName: "paellaImage"))
        let chicken = ShoppingItems.init(name: "chicken", price: 4.0, weight: 30.0, photo: #imageLiteral(resourceName: "kipfilet"))
        let paprika = ShoppingItems.init(name: "paprika", price: 2.0, weight: 1.5, photo: #imageLiteral(resourceName: "paprika"))
        
        let allItems = [paella, chicken, paprika]
        let allItemsDic = [notificationIDs.shoppingData : allItems]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myCoffee"), object: self, userInfo: allItemsDic)
    }
    
    

    
    
}
