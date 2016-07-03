
//  AddPurchaseViewController.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import Foundation
import UIKit

class AddPurchaseViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var nameField: AutocompleteField!
    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var purchaseStrings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.becomeFirstResponder()
        nameField.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nameField.suggestions = purchaseStrings
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        purchaseStrings.removeAll()
    }
    
    func convertCostTestField() -> Double? {
        guard let cost = self.costField?.text else {
            return nil
        }
        
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle        
        guard let ret = formatter.numberFromString(cost)?.doubleValue else {
            return nil
        }
        
        return ret
    }
    
    func shake(field: UITextField) {
        // http://stackoverflow.com/questions/1632364/shake-visual-effect-on-iphone-not-shaking-the-device
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-6, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 6, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 7/100
        
        field.layer.addAnimation(anim, forKey: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let s = sender as? UIBarButtonItem {
            if s == self.saveButton {
                if self.nameField.text!.isEmpty {
                    shake(self.nameField)
                    return false
                }
                
                if self.costField.text!.isEmpty {
                    shake(self.costField)
                    return false
                }
                
                if self.convertCostTestField() == nil {
                    let alertController = UIAlertController(title: "Invalid cost", message: "The cost must be a numeric dollar amount.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    return false
                }
            }
        }
        
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let s = sender as? UIBarButtonItem {
            if s == self.saveButton {
                // no validation here, done in shouldPerformSegueWithIdentifier
                let newPurchase = Purchase(fromName: self.nameField.text!, fromCost: self.convertCostTestField()!) // ok to unwrap, already validated
                let outputJSON = newPurchase.toJSON()
                
                JSONClient.post("https://mt2d2.net/purchases", body: outputJSON)
            }
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if let field = textField as? AutocompleteField {
            if field.suggestion?.characters.count > 0 {
                field.text = field.suggestion
            }
            costField.becomeFirstResponder()
        }
        
        return true
    }
}
