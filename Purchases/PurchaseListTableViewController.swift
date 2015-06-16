//
//  PurchaseListTableViewController.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import UIKit

class PurchaseListTableViewController: UITableViewController {
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var purchases = [Purchase]()
    
    @IBAction func unwindToPurchaseList(segue: UIStoryboardSegue) {
        self.loadInitialData()
    }
    
    func costTotal() -> Double {
        return self.purchases.reduce(0, combine: {$0 + $1.cost})
    }
    
    func refresh(sender: AnyObject) {
        self.loadInitialData()
        self.refreshControl!.endRefreshing()
    }
    
    func presentBlank() {
        self.totalView?.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0)
        self.totalLabel?.text = ""
    }
    
    func presentData() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            
            UIView.animateWithDuration(0.4, animations: {
                self.totalView?.backgroundColor = self.colorForTotalCost()
                self.totalLabel?.text = "Total: $\(self.costTotal())"
            })
        })

    }
    
    func colorForTotalCost() -> UIColor {
        let spent = self.costTotal()
        let max = 1500.0 // TODO grab this from the server/let app decide
        
        let percentage = (spent / max)
        
        // http://stackoverflow.com/questions/1696044/how-to-delete-a-row-in-a-sqlite-database-table
        let r = 2.0 * percentage
        let g = 2.0 * (1 - percentage)
        let b = 0
        let a = 0.1
        
        return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
    }
    
    func loadInitialData() {
// todo, hazard, removing this needs to be kepy in sync
//        self.purchases.removeAll(keepCapacity: true)
        
        JSONClient.get("http://Deanna.local:8080/purchases") {(json) in
            self.purchases <-- json
            self.presentData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.presentBlank()
        self.loadInitialData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.purchases.removeAll()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.purchases.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListPrototypeCell", forIndexPath: indexPath) as! PurchaseTableViewCell
        let purchase = self.purchases[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.doesRelativeDateFormatting = true
        let dateString = dateFormatter.stringFromDate(purchase.timeBought!)

        cell.nameLabel.text = purchase.name
        cell.costLabel.text = String(format: "$%.2f", purchase.cost)
        cell.timeBoughtLabel.text = dateString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            self.purchases.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.presentData()
            
            // TODO commit the change to the server
        } else if editingStyle == .Insert {
            return // unsupported
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
