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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shoppingListTableViewController.notifyObservers(notification:)),
                                               name: NSNotification.Name(rawValue: notificationIDs.shoppingID),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shoppingListTableViewController.addNotifyObservers),
                                               name: NSNotification.Name(rawValue: notificationIDs.addShoppingID),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shoppingListTableViewController.changeNotifyObservers),
                                               name: NSNotification.Name(rawValue: notificationIDs.changeShoppingID),
                                               object: nil)
        
        ShoppingItemService.sharedInstance.getShoppingListData()
        
        let shoppingNib = UINib(nibName: "ShoppingCell", bundle: nil)
        self.tableView.register(shoppingNib, forCellReuseIdentifier: TableCellIDs.shoppingCellID)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func notifyObservers(notification: NSNotification) {
        var shopItemDict = notification.userInfo as! Dictionary<String , [ShoppingItems]>
        shoppingItemsObjects = shopItemDict[dictKey.shoppingData]!
        self.tableView.reloadData()
    }
    
    @objc func addNotifyObservers(notification: NSNotification) {
        var addShopItemDict = notification.userInfo as! Dictionary<String, ShoppingItems>
        let oneObject = addShopItemDict[dictKey.shoppingData]
        shoppingItemsObjects.append(oneObject!)
        self.tableView.reloadData()
    }
    
    @objc func changeNotifyObservers(notification: NSNotification) {
        var changeShopItemDict = notification.userInfo as! Dictionary<String, ShoppingItems>
        let oneObject = changeShopItemDict[dictKey.shoppingData]
        self.shoppingItemsObjects = shoppingItemsObjects.map { (item) -> ShoppingItems in
            if item.id == oneObject?.id {
                return oneObject!
            } else {
                return item
            }
       }
         self.tableView.reloadData()
    }
//        shoppingItemsObjects.append(oneObject!)
    
    
    
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
         let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIDs.shoppingCellID, for: indexPath) as! ShoppingCell
   
        let storeObject = shoppingItemsObjects[indexPath.row]
        cell.labelNameMain?.text = storeObject.name
        return cell
    }
    
//    @IBAction func AddButton(_ sender: UIButton) {
//        let newitem = ShoppingItems.init(name: textFieldOutlet.text!, price: 1.0, weight: 1.0, photoUrlString: "", details: "" )
//        shoppingItemsObjects.append(newitem)
//
//        self.tableView.reloadData()
//    }
    
    @IBAction func addShoppingItem(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "New Shopping Item", message: "Enter a new shopping Item", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "The new item"
        }
        alert.addTextField { (priceField) in
            priceField.keyboardType = .numberPad
            priceField.placeholder = "The new Price"
        }
        alert.addTextField { (weightField) in
            weightField.keyboardType = .numberPad
            weightField.placeholder = "The new weight"
        }
        alert.addTextField { (detailsTextField) in
            detailsTextField.placeholder = "The new details"
        }
        alert.addTextField { (imageTextField) in
            imageTextField.placeholder = "The new imageURL"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            if let textField = alert?.textFields?[0].text,
                let priceField = alert?.textFields?[1].text,
                let priceDouble = Double(priceField),
                let weightfield = alert?.textFields?[2].text,
                let weightDouble = Double(weightfield),
                let photoUrlStringField = alert?.textFields?[3].text,
                let details = alert?.textFields?[4].text
            {
                let shopItem = ShoppingItems.init(name: textField, price: priceDouble, weight: weightDouble, photoUrlString: photoUrlStringField, details: details)
                
                ShoppingItemService.sharedInstance.addShopItem(shopItem: shopItem)
                print("Text field: \(textField)")
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // Dit geeft aan dat welke row je klikt in de alle shoppingItemObject dat het de selectedShopping item wordt voor volgende "prepare" functie.
        self.selectedShoppingItem = shoppingItemsObjects[indexPath.row]

        performSegue(withIdentifier: seguesIdentifiers.detailTableSegue , sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguesIdentifiers.detailTableSegue {
            
                            // Hier zeg je dus: Ga naar "detail(View/Table)Segue" als op een selectedShoppingItem wordt geklikt, want check regel 82
            let detailView = segue.destination as! detailTableViewController
            detailView.selectedShoppingItem = self.selectedShoppingItem
         }
    }
    
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
//   Delete the row from the data source
        ShoppingItemService.sharedInstance.deleteShopItem(shopItem: self.shoppingItemsObjects[indexPath.row] )
            shoppingItemsObjects.remove(at: indexPath.row)

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

