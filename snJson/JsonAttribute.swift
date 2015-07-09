//
//  JsonAttribute.swift
//  snJson
//
//  Created by Marc Fiedler on 09/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonAttribute: NSObject {
    public var val: AnyObject!
    public var type: Int!
    
    public init(val: AnyObject, type: Int){
        self.val = val
        self.type = type
        
        /*switch type {
            case JsonType.String:
                println("String: \(val as? String)")
            case JsonType.List:
                println("List: \(val as? Dictionary<String, AnyObject>)")
            case JsonType.Object:
                println("Object: \( (val as? JsonObject)?.getJsonString() ) ")
            case JsonType.Integer:
                println("Int: \(val as? Int)")
            default:
                println("Error unknown type!")
        }*/
        super.init()
    }
    
    // for Strings and NSArray [Int]/[String]
    //public func value() -> NSObject? {
    //    if( self.type == JsonType.String ){
    //        return self.val as? String
    //    }
    //    else if( self.type == JsonType.StringList ){
    //        return self.val as? [String]
    //    }
    //    else if( self.type == JsonType.IntegerList ){
    //        return self.val as? [Int]
    //    }
        
    //    return nil
    //}

    public func array() -> NSArray? {
        return self.val as? NSArray
    }
    
    public func string() -> String? {
        return self.val as? String
    }
    
    public func value() -> String? {
        return self.val as? String
    }
    
    public func value() -> Int? {
        return self.val as? Int
    }
    
    public func value() -> JsonObject? {
        return self.val as? JsonObject
    }
}
