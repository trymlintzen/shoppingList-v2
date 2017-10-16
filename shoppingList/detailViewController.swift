//
//  detailViewController.swift
//  shoppingList
//
//  Created by Trym Lintzen on 16-10-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {


    
    @IBOutlet weak var itemLabel: UILabel!
     var selectedShoppingItem: ShoppingItems?
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var imageViewFood: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel?.text = selectedShoppingItem?.name
        
        if let price = selectedShoppingItem?.price,
            let weight = selectedShoppingItem?.weight {
            priceLabel.text = "\(price)"
            weightLabel.text = "\(weight)"
        }


        
        imageViewFood?.image = selectedShoppingItem?.photo
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
