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
                    let a = self.dictToObject(shoppingItem: shoppingItem)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.shoppingID),
                                                    object: self,
                                                    userInfo: [dictKey.shoppingData : a])
                }
                
            })

        ref.child("ShoppingItems").observe(.childAdded, with: { (snapshot) in
            if let dataItem = snapshot.value as? NSDictionary,
                let itemObject = self.oneDictionaryToOneObject(item: dataItem) {
                
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.addShoppingID),
                                                    object: self,
                                                    userInfo: [dictKey.shoppingData : itemObject])
                }
        })
    }
    
    func dictToObject(shoppingItem: NSDictionary) -> [ShoppingItems] {
        var shopitems: [ShoppingItems] = []
        
        for key in shoppingItem.keyEnumerator() {
            if let item = shoppingItem[key] as? NSDictionary,
                let itemObj = oneDictionaryToOneObject(item: item) {
                shopitems.append(itemObj)
            }
        }
        return shopitems
    }
    
    func oneDictionaryToOneObject(item : NSDictionary) -> ShoppingItems? {
        if let name = item["name"] as? String,
            let price = item["price"] as? Double,
            let details = item["details"] as? String,
            let photoUrlString = item["photo"] as? String,
            let weight = item["weight"] as? Double{
            let shoppingitemObject = ShoppingItems.init(name: name,
                                                        price: price,
                                                        weight: weight,
                                                        photoUrlString: photoUrlString,
                                                        details: details )
            return shoppingitemObject
        } else {
            return nil
        }
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
