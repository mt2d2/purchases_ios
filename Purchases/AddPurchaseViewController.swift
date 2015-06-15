
//  AddPurchaseViewController.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import Foundation
import UIKit

class AddPurchaseViewController: UIViewController {
   
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var costField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.becomeFirstResponder()
        self.nameField.addTarget(self.costField, action: "becomeFirstResponder", forControlEvents: UIControlEvents.EditingDidEndOnExit)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertCostTestField() -> Double? {
        if let cost = self.costField?.text {
            let ret = strtod(cost, nil)
            // if parsing fails, return an empty optional double
            return ret == 0 ? nil : ret
        }
        
        return nil
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let s = sender as? UIBarButtonItem {
            if s == self.saveButton {
                if self.nameField.text!.isEmpty || self.costField.text!.isEmpty {
                   UIAlertView(title: "Bad entries", message: "We need a name and cost.", delegate: nil, cancelButtonTitle: "Got it!").show()
                    return false
                }
                
                if self.convertCostTestField() == nil {
                    UIAlertView(title: "Bad entries", message: "We need a valid, numeric cost.", delegate: nil, cancelButtonTitle: "Ok").show()
                    return false
                }
            }
        }
        
        return true
    }
    
    func post(url: String, body: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        request.HTTPBody = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in })!.resume()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let s = sender as? UIBarButtonItem {
            if s == self.saveButton {
                // no validation here, done in shouldPerformSegueWithIdentifier
                let newPurchase = Purchase(fromName: self.nameField.text!, fromCost: self.convertCostTestField()!) // ok to unwrap, already validated
                let outputJSON = newPurchase.toJSON()
                
                self.post("http://Deanna.local:8080/purchases", body: outputJSON)
            }
        }
    }

}
