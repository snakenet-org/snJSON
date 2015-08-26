//
//  JsonService.swift
//  snJson
//
//  Created by Marc Fiedler on 11/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonService {
    // the request function that uses the NSURL Shared Session to make a very simple HTTP request
    public static func request(url:String, success: ((JsonObject)->()) ) {
        let nsURL = NSURL(string: url)
        
        // run the session in a new task
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) { (data: NSData? ,response: NSURLResponse? , error: NSError?) -> Void in
            
            if let _ = error {
                // if error wasn't nil return the NSError
                print("Network Error: \(error)")
            }
            else{
                // Transform the reply data directly into a JsonObject
                do{
                    let jMsg = try JsonObject(data: data!)
                    success(jMsg)
                } catch {
                    print("Invalid Data")
                }
            }
        }
        // start taask
        task.resume()
    }
}
