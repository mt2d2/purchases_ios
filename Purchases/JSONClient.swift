//
//  URLFetcher.swift
//  Purchases
//
//  Created by Michael Tremel on 6/15/15.
//  Copyright © 2015 Michael Tremel. All rights reserved.
//

import UIKit

class JSONClient {
    class func basicRequest(url: String, method: String, body: String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = method
        request.HTTPBody = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: completionHandler)!.resume()
    }
    
    class func post(url: String, body: String) {
        basicRequest(url, method: "POST", body: body, completionHandler: {(_, _, _) in })
    }
    
    class func get(url: String, callback: ((AnyObject) -> Void)) {
        basicRequest(url, method: "GET", body: "") { (data, response, error) in
            do {
                if let json = data {
                    let parsed = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments)
                    callback(parsed)
                }
            } catch _ { }
        }
    }
    
    class func delete(url: String) {
        basicRequest(url, method: "DELETE", body: "", completionHandler: {(_, _, _) in })
    }
}
