//
//  JsonAttribute.swift
//  snJson
//
//  Created by Marc Fiedler on 09/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonElement: NSObject {
    public let val: AnyObject!
    
    public var type: Int!
    public var valid: Bool!
    
    public var string: String?
    public var int: Int?
    public var double: Double?
    public var array: NSArray?
    public var dict: NSDictionary?
    public var object: JsonObject?
    
    public struct Types{
        // mostly for the value part of a pair or a value
        // part of an Array or a Dict
        public static let Unkniwn: Int = -1
        public static let Integer: Int = 1
        public static let String: Int = 2
        public static let Double: Int = 3
        public static let Array: Int = 4
        public static let Dictionary: Int = 5
    }
    
    public init(val: AnyObject){
        self.val = val
        
        if let iVal = val as? Int {
            type = Types.Integer
            self.int = (val as! Int)
            // while we are at it, convert the int also to a string
            self.string = String( val as! Int )
        }
        
        if let dVal = val as? Double {
            type = Types.Double
            self.double = (val as! Double)
            self.string = String( stringInterpolationSegment: val as! Double)
        }
        
        if let sVal = val as? String {
            type = Types.String
            self.string = (val as! String)
        }
        
        if let aVal = val as? NSArray {
            type = Types.Array
            self.array = (val as! NSArray)
            self.object = JsonObject(data: val as! NSArray)
        }
        
        if let dVal = val as? NSDictionary {
            type = Types.Dictionary
            self.dict = (val as! NSDictionary)
            self.object = JsonObject(data: val as! NSDictionary)
        }
        
        // check if a type was assigned or not
        if let tType = type {
            valid = true
        }
        else{
            type = Types.Unkniwn
            valid = false
        }

        super.init()
    }
}
