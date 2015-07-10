//
//  JsonAttribute.swift
//  snJson
//
//  Created by Marc Fiedler on 09/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonElement: NSObject {
    public var val: AnyObject!
    public var type: Int!
    
    public struct Types{
        // mostly for the value part of a pair or a value
        // part of an Array or a Dict
        public static let Integer: Int = 1
        public static let String: Int = 2
        public static let Array: Int = 3
        public static let Dictionary: Int = 4
    }
    
    public init(val: AnyObject, type: Int){
        self.val = val
        self.type = type

        super.init()
    }

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
