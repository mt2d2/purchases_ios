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
        id <-- data["id"]
        name <-- data["name"]
        timeBought <-- data["time_bought"]
        cost <-- data["cost"]
    }
}
