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
    public let type: Int!
    
    public var valid: Bool!
    
    public var string: String?
    public var int: Int?
    public var double: Double?
    public var array: NSArray?
    public var dict: NSDictionary?
    
    public struct Types{
        // mostly for the value part of a pair or a value
        // part of an Array or a Dict
        public static let Integer: Int = 1
        public static let String: Int = 2
        public static let Double: Int = 3
        public static let Array: Int = 4
        public static let Dictionary: Int = 5
    }
    
    public init(val: AnyObject, type: Int){
        self.val = val
        self.type = type

        switch type{
            case Types.Integer:
                self.int = (val as! Int)
                // while we are at it, convert the int also to a string
                self.string = String( val as! Int )
            case Types.Double:
                self.double = (val as! Double)
                self.string = String( stringInterpolationSegment: val as! Double)
            case Types.String:
                self.string = (val as! String)
            case Types.Dictionary:
                self.dict = NSDictionary()
                for( key, val ) in (val as! NSDictionary){
                    self.dict[key] = JsonElement(val: val, type: 1)
                }
            case Types.Array:
            
        }
        
        super.init()
    }
}
