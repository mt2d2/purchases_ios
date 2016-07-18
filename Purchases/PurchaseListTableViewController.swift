//
//  PurchaseListTableViewController.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import UIKit

class PurchaseListTableViewController: UITableViewController {
    
    static let PurchaseStringsKey = "PurchaseStrings"
    
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var purchases = [Purchase]()
    
    var backgroundObserver: NSObjectProtocol?
    var jsonObserver: NSObjectProtocol?
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        backgroundObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationDidEnterBackground, object: nil, queue: nil) { notification in
            let strings = self.purchaseStrings()
            if !strings.isEmpty {
                NSLog("Saving purchase strings")
                UserDefaults.standard.set(strings, forKey: PurchaseListTableViewController.PurchaseStringsKey)
            }
        }
        jsonObserver = NotificationCenter.default.addObserver(forName: JSONClient.JSONActivityNotification, object: nil, queue: nil, using: {
            notification in
            NSLog("Processing JSON refresh")
            self.loadInitialData()
        })
    }
    
    deinit {
        for observer in [backgroundObserver, jsonObserver] {
            if let observer = observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
    
    @IBAction func unwindToPurchaseList(_ segue: UIStoryboardSegue) {
    }
    
    func costTotal() -> Double {
        return self.purchases.reduce(0, combine: {$0 + $1.cost})
    }
    
    func refresh(_ sender: AnyObject) {
        self.loadInitialData()
        self.refreshControl!.endRefreshing()
        self.presentData()
    }
    
    func presentBlank() {
        self.totalView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.totalLabel?.text = ""
    }
    
    func presentData() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.4, animations: {
                self.totalView?.backgroundColor = self.colorForTotalCost()
                self.totalLabel?.text = String(format: "Total: $%.2f", self.costTotal())
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
        JSONClient.get("https://mt2d2.net/purchases") {(json) in
            let _ = self.purchases <-- json
            self.presentData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(PurchaseListTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        self.presentBlank()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.purchases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListPrototypeCell", for: indexPath as IndexPath) as! PurchaseTableViewCell
        let purchase = self.purchases[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.doesRelativeDateFormatting = true
        let dateString = dateFormatter.string(from: purchase.timeBought as Date)

        cell.nameLabel.text = purchase.name
        cell.costLabel.text = String(format: "$%.2f", purchase.cost)
        cell.timeBoughtLabel.text = dateString
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let removedPurchase = self.purchases.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            self.presentData()
            
            JSONClient.delete("https://mt2d2.net/purchases/\(removedPurchase.id)")

        } else if editingStyle == .insert {
            return // unsupported
        }
    }
    
    func purchaseStrings() -> [String] {
        return purchases.map { $0.name }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nav = segue.destinationViewController as? UINavigationController {
            if let dest = nav.viewControllers[0] as? AddPurchaseViewController {
                let strings = purchaseStrings()
                if !strings.isEmpty {
                    dest.purchaseStrings = purchaseStrings()
                } else {
                    if let strings = UserDefaults.standard.array(forKey: PurchaseListTableViewController.PurchaseStringsKey) as? [String] {
                        NSLog("Overriding purchase strings from NSUserDefaults")
                        dest.purchaseStrings = strings
                    }
                }
            }
        }
    }
}
