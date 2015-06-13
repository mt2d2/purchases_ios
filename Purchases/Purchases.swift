//
//  Purcase.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import UIKit

struct Purchase: Deserializable {
    var id = 0
    var name = ""
    var cost = 0.0
    var timeBought = NSDate()
    
    init(data: [String: AnyObject]) {
        self.id <-- data["id"]
        self.name <-- data["name"]
        self.timeBought <-- data["time_bought"]
        self.cost <-- data["cost"]
    }
    
    init(fromName: String, fromCost: Double) {
        self.name = fromName
        self.cost = fromCost
    }
    
    func toJSON() -> String {
        return "{ \"name\": \"\(self.name)\", \"cost\": \(self.cost) }"
    }
}
