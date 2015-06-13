//
//  AddPurchaseViewController.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import UIKit

class AddPurchaseViewController: UIViewController {
   
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var costField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.becomeFirstResponder()
        self.nameField.addTarget(self.costField, action: "becomeFirstResponder", forControlEvents: UIControlEvents.EditingDidEndOnExit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
