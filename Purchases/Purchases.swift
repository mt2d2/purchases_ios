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
    var timeBought = Date()
    
    init(data: [String: AnyObject]) {
        let _ = self.id <-- data["id"]
        let _ = self.name <-- data["name"]
        let _ = self.timeBought <-- data["time_bought"] //, "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSSZZZZZ") // 2015-06-11T17:24:44.153108381-07:00
        let _ = self.cost <-- data["cost"]
    }
    
    init(fromName: String, fromCost: Double) {
        self.name = fromName
        self.cost = fromCost
    }
    
    func toJSON() -> String {
        return "{\"name\":\"\(self.name)\",\"cost\":\(self.cost)}"
    }
}
