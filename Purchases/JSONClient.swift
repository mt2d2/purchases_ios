//
//  URLFetcher.swift
//  Purchases
//
//  Created by Michael Tremel on 6/15/15.
//  Copyright © 2015 Michael Tremel. All rights reserved.
//

import UIKit

class JSONClient: NSObject {
    class func post(url: String, body: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in })!.resume()
    }
    
    class func get(url: String, callback: ((AnyObject) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!, completionHandler: {(data, response, error) -> Void in
            do {
                if let json = data {
                    let parsed = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments)
                    callback(parsed)
                }
            } catch _ { }
        })!.resume()
    }
}
