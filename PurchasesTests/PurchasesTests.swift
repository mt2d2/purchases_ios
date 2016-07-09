//
//  PurchasesTests.swift
//  PurchasesTests
//
//  Created by Michael Tremel on 6/11/15.
//  Copyright (c) 2015 Michael Tremel. All rights reserved.
//

import UIKit
import XCTest

@testable
import Purchases

class PurchasesTests: XCTestCase {
    
    var purchases = [Purchase]()
    
    override func setUp() {
        super.setUp()
        
        let str = "[{\"id\":2,\"name\":\"Zest\",\"cost\":85,\"time_bought\":\"2015-06-14T23:14:48.654224843-07:00\"},{\"id\":1,\"name\":\"added via post 4\",\"cost\":29.32,\"time_bought\":\"2015-06-14T23:01:36.957803279-07:00\"}]"
        
        do {
            let json = try JSONSerialization.jsonObject(with: str.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.allowFragments)
            purchases <-- json
        } catch _ {
            XCTFail()
        }
    }
    
    override func tearDown() {
    }
    
    func testCount() {
        XCTAssertEqual(2, purchases.count)
    }
    
    func testDeserialization() {
        let purchase1 = purchases[0]
        XCTAssertEqual(2, purchase1.id)
        XCTAssertEqual("Zest", purchase1.name)
        XCTAssertEqual(85, purchase1.cost)
        
        let purchase2 = purchases[1]
        XCTAssertEqual(1, purchase2.id)
        XCTAssertEqual("added via post 4", purchase2.name)
        XCTAssertEqual(29.32, purchase2.cost)
    }
    
    func testJSONOutput() {
        let newPurchase = Purchase(fromName: "Test", fromCost: 99.21)
        let expectedJSON = "{\"name\":\"Test\",\"cost\":99.21}"
        
        XCTAssertEqual(expectedJSON, newPurchase.toJSON())
    }
}
