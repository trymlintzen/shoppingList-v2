//
//  detailTableViewController.swift
//  shoppingList
//
//  Created by Trym Lintzen on 18-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit
import Kingfisher


class detailTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedShoppingItem: ShoppingItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let shoppingNib = UINib(nibName: "ShoppingDetailCell", bundle: nil)
        self.tableView.register(shoppingNib, forCellReuseIdentifier: TableCellIDs.shoppingDetailID)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Photo",
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: #selector(addPhotoChoser))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(detailTableViewController.notificationImageUrl),
                                               name: NSNotification.Name(rawValue: notificationIDs.imageUploadedID),
                                               object: nil)
        }
        
    @objc func notificationImageUrl(notification: NSNotification) {
        var imageDict = notification.userInfo as! Dictionary<String, URL>
        let url = imageDict[dictKey.imageURLKey]
        self.selectedShoppingItem?.photoUrlString = (url?.absoluteString)!
        ShoppingItemService.sharedInstance.updateShopItem(shopItem: selectedShoppingItem!)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool)   {
         super.viewWillDisappear(animated)

        let cell = tableView.cellForRow(at: IndexPath.init(row: 0 , section: 0)) as! ShoppingDetailCell
            
        selectedShoppingItem?.name = (cell.nameField?.text)!
        if let price = Double(cell.priceField.text!), let weight = Double(cell.weightField.text!) {
            selectedShoppingItem?.price = price
            selectedShoppingItem?.weight = weight
    
        ShoppingItemService.sharedInstance.updateShopItem(shopItem: selectedShoppingItem!)
       }
    }
            
        
    
        // call back serviceclass

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIDs.shoppingDetailID, for: indexPath) as! ShoppingDetailCell
        
        cell.nameField?.text = selectedShoppingItem?.name
        if let price = selectedShoppingItem?.price, let weight = selectedShoppingItem?.weight {
            cell.priceField.text = "\(price)"
            cell.weightField.text = "\(weight)"
        }
        
        let url = URL(string: (selectedShoppingItem?.photoUrlString)!)
        cell.ItemImage.kf.setImage(with: url)
        return cell
        
        }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

   
//    @objc func takePhoto(_ sender: UIBarButtonItem) {
//        let imagePicker = UIImagePickerController()
//        // if device has camera -> take picture other pick library
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePicker.sourceType = .camera
//        } else {
//            imagePicker.sourceType = .photoLibrary
//        }
//
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true, completion: nil)
//    }
    
  
    
    @IBAction func addPhotoChoser(_ sender: UIButton) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Take Photo", message: "Choose Camera or Library", preferredStyle: .actionSheet)
        let imagePicker = UIImagePickerController()
       
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Camera",
                                      style: .default,
                                      handler: { action  in
                                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                             imagePicker.sourceType = .camera
                                            imagePicker.delegate = self
                                            self.present(imagePicker, animated: true, completion: nil)
                                        }
                                        }))
                                       
        
        alert.addAction(UIAlertAction(title: "Photo Library",
                                      style: .default,
                                      handler: { action  in
                                        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                                            imagePicker.sourceType = .photoLibrary
                                            imagePicker.delegate = self
                                            self.present(imagePicker, animated: true, completion: nil)
                                        }
                                        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .default,
                                      handler: { action  in
                                            alert.dismiss(animated: true, completion: nil)
                                        }))
        
        // 4. Present the alert.
      self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // get picked image from info dictionary
        let cell = self.tableView.cellForRow(at: IndexPath.init(item: 0, section: 0)) as? ShoppingDetailCell
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Put that image on the screen in the image view
        cell?.ItemImage.image = image
        
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imagePath = imageURL.path!
        ShoppingItemService.sharedInstance.uploadImage(image: image, imageName: imagePath)
        // take image picker off te screen -
        // you must call this dismiss method
        dismiss(animated: true, completion: nil)

    }
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
