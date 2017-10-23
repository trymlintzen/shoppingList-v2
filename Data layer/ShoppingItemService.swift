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
import FirebaseStorage
import SVProgressHUD


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
                    itemObject.id = snapshot.key 
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.addShoppingID),
                                                    object: self,
                                                    userInfo: [dictKey.shoppingData : itemObject])
                }
            })
        
        ref.child("ShoppingItems").observe(.childChanged , with: { (snapshot) in
            if let dataChanged = snapshot.value as? NSDictionary,
                let itemObject = self.oneDictionaryToOneObject (item: dataChanged) {
                itemObject.id = snapshot.key
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.changeShoppingID),
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
                itemObj.id = key as! String
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
            let weight = item["weight"] as? Double {
            let shoppingitemObject = ShoppingItems.init(name: name,
                                                        price: price,
                                                        weight: weight,
                                                        photoUrlString: photoUrlString,
                                                        details: details)
            return shoppingitemObject
        } else {
            return nil
        }
    }
    
    func objectToDic (shoppingitemObject: ShoppingItems) -> Dictionary<String, Any> {
        var ObjectDict = Dictionary<String, Any>()
             ObjectDict["name"] = shoppingitemObject.name 
             ObjectDict["price"] = shoppingitemObject.price
        ObjectDict["details"] = shoppingitemObject.details
             ObjectDict["photo"] = shoppingitemObject.photoUrlString
             ObjectDict["weight"] = shoppingitemObject.weight
             ObjectDict["id"] = shoppingitemObject.id
        return ObjectDict
    }
    
    func addShopItem(shopItem: ShoppingItems) {
        let AddDict = objectToDic(shoppingitemObject: shopItem)
        ref.child("ShoppingItems").child(shopItem.id).setValue(AddDict)
    }
    
    func deleteShopItem(shopItem: ShoppingItems) {
        ref.child("ShoppingItems").child(shopItem.id).removeValue()
    }
    
    func updateShopItem(shopItem: ShoppingItems) {
        let changedItem = objectToDic(shoppingitemObject: shopItem)
        ref.child("ShoppingItems").child(shopItem.id).updateChildValues(changedItem)
    }
    
    func uploadImage(image: UIImage , imageName:String) {
        // Create a root reference
        let storageRef = Storage.storage().reference()
        let imagesRef = storageRef.child(imageName)
        
        let data = UIImageJPEGRepresentation(image, 0.2)
        // Upload file and metadata to the object ‘images/mountains.jpg’
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
//        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        let uploadTask = imagesRef.putData(data!, metadata: metadata)

        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(percentComplete)
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
            snapshot.reference.downloadURL(completion: { (url, error) in
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.imageUploadedID),
                                                object: self,
                                                userInfo: [dictKey.imageURLKey : url])
                
            })
            print("success")
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
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
