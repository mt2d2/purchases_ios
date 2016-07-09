//
//  JSONClient.swift
//  Purchases
//
//  Created by Michael Tremel on 6/15/15.
//  Copyright © 2015 Michael Tremel. All rights reserved.
//

import UIKit

class JSONClient {
    class func basicRequest(_ url: String, method: String, body: String, completionHandler: (Data?, URLResponse?, NSError?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        
        let username = "test"
        let password = "test"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString(options: .lineLength64Characters)
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        
        request.httpMethod = method
        request.httpBody = (body as NSString).data(using: String.Encoding.utf8.rawValue)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        UIApplication.shared().isNetworkActivityIndicatorVisible = true
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        // disabled in callback when executed
    }
    
    class func post(_ url: String, body: String) {
        basicRequest(url, method: "POST", body: body, completionHandler: {(_, _, _) in })
    }
    
    class func get(_ url: String, callback: ((AnyObject) -> Void)) {
        basicRequest(url, method: "GET", body: "") { (data, response, error) in
            do {
                UIApplication.shared().isNetworkActivityIndicatorVisible = false
                
                if let json = data {
                    let parsed = try JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions.allowFragments)
                    callback(parsed)
                }
            } catch _ { }
        }
    }
    
    class func delete(_ url: String) {
        basicRequest(url, method: "DELETE", body: "", completionHandler: {(_, _, _) in })
    }
}
