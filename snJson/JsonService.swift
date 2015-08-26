//
//  JsonService.swift
//  snJson
//
//  Created by Marc Fiedler on 11/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonService: NSObject {
    
    // simple construct.
    public override init() {
        super.init()
    }
    
    // the request function that uses the NSURL Shared Session to make a very simple HTTP request
    public func request(url:String, success: ((JsonObject)->()), error: ((NSError?)->())? ) {
        let nsURL = NSURL(string: url)
        
        // run the session in a new task
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) {
            (data,response,err) in
            let err: NSError? = err
            
            if let _ = err {
                // if error wasn't nil return the NSError
                error?(err)
            }
            else{
                // Transform the reply data directly into a JsonObject
                do{
                    let jMsg = try JsonObject(data: data!)
                    success(jMsg)
                }
                catch{
                    
                }
            }
        }
        // start taask
        task.resume()
    }
}
