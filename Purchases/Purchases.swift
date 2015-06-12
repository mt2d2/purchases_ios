//
//  Purcase.swift
//  Purchases
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import UIKit

class Purchase: NSObject {
    var name = ""
    var cost = 0.0
    var timeBought = NSDate()
    
    init(fromName: String, fromCost: Double) {
        self.name = fromName
        self.cost = fromCost
    }
}
