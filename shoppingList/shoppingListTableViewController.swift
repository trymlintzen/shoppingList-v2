//
//  shoppingListTableViewController.swift
//  shoppingList
//
//  Created by Trym Lintzen on 13-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit

class shoppingListTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var addTextField: UITextField!
    var name = ""
    var selectedShoppingItem: ShoppingItems?
    var shoppingList: [String] = ["Paella" , "Chicken", "Paprika" , "Rice", "Onions", "Oregano", "Garnalen", "Erwten"]
    
    var shoppingItemsObjects: [ShoppingItems] = []
    

//    var shoppingListImages: [UIImage] = [#imageLiteral(resourceName: "paellaImage"), #imageLiteral(resourceName: "kipfilet"), #imageLiteral(resourceName: "paprika"), #imageLiteral(resourceName: "rijst") , #imageLiteral(resourceName: "onion"), #imageLiteral(resourceName: "oregano"), #imageLiteral(resourceName: "garnalen"), #imageLiteral(resourceName: "erwten") ]
    
    
    
    @IBOutlet weak var textFieldOutlet: UITextField! 
    
    
    
//    var dictKeys : [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       shoppingItemsObjects = ShoppingItemService.createShoppingItemObjects()
        
        
//        let keys = shoppinglistDic.keys
//        dictKeys = Array(keys)
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        return shoppingItemsObjects.count
        
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let rowNumber = indexPath.row
        
        var storeObject = shoppingItemsObjects[indexPath.row]
        cell.textLabel?.text = storeObject.name
        
        ///"\(rowNumber) \(shoppingList[indexPath.row])"
        
//        cell.imageView?.image = shoppingListImages[rowNumber]
        
        
        // Configure the cell...
        
        return cell
    }
    
    @IBAction func AddButton(_ sender: UIButton) {
        var newitem = ShoppingItems.init(name: textFieldOutlet.text!, price: 1.0, weight: 1.0, photo: UIImage())
        shoppingItemsObjects.append(newitem)
        self.tableView.reloadData()
        resignFirstResponder()
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
          view.endEditing(true)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedShoppingItem = shoppingItemsObjects[indexPath.row]

        performSegue(withIdentifier: "detailViewSegue" , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue" {
            let detailView = segue.destination as! detailViewController
//            detailView.shopItemName = name
                detailView.selectedShoppingItem = self.selectedShoppingItem
        }
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//        let rowNumber = indexPath.row
//
//
//        cell.textLabel?.text = "\(rowNumber) \(shoppingList[rowNumber])"
//
//        cell.imageView?.image =  shoppingListImages[rowNumber]
//
//        // Configure the cell...
//
//        return cell
//    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingItemsObjects.remove(at: indexPath.row)
//   Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


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
