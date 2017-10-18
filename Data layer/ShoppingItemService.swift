//
//  ShoppingItemService.swift
//  shoppingList
//
//  Created by Trym Lintzen on 16-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase
class ShoppingItemService {
    
    public static let sharedInstance = ShoppingItemService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    var ref: DatabaseReference!
    
    public func getShoppingListData() {
        ref = Database.database().reference()
        ref.observeSingleEvent(of: .value , with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary,
                let shoppingItem = data["ShoppingItems"] as? NSDictionary {
                print(data)
                var shopitems: [ShoppingItems] = []

                    for key in shoppingItem.keyEnumerator() {
                        
                        if let item = shoppingItem[key] as? NSDictionary,
                            let name = item["name"] as? String,
                            let price = item["price"] ,
                            let photo = item["photo"] as? [String],
                            let weight = item["weight"] {
                                let shoppingitemObject = ShoppingItems.init(name: name,
                                                                      price: price as! Double,
                                                                      weight: weight as! Double,
                                                                      photoUrlString: photo)
                            shopitems.append(shoppingitemObject)
                        }
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.shoppingID),
                                                    object: self,
                                                    userInfo: [dictKey.shoppingData : shopitems])
                    
                    
                }
                
            })
        
    }
    
    
    
//    static func createShoppingItemObjects()  {
//       let paella = ShoppingItems.init(name: "paella", price: 5.0, weight: 50.0, photo: #imageLiteral(resourceName: "paellaImage"))
//        let chicken = ShoppingItems.init(name: "chicken", price: 4.0, weight: 30.0, photo: #imageLiteral(resourceName: "kipfilet"))
//        let paprika = ShoppingItems.init(name: "paprika", price: 2.0, weight: 1.5, photo: #imageLiteral(resourceName: "paprika"))
//        
//        let allItems = [paella, chicken, paprika]
//        let allItemsDic = [dictKey.shoppingData : allItems]
//        
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.shoppingID),
//                                        object: self,
//                                        userInfo: allItemsDic)
//    }
//    
    

    
    
}
