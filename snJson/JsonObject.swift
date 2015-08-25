//
//  JsonObject.swift
//  json-swift
//
//  Created by Marc Fiedler on 08/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

/// Errors that can occur in the JSON Object
enum JsonError: ErrorType {
    case Unknown
    case SyntaxError
    case InvalidData
    case InvalidType
}

/// A JSON Object. Each Object is also an Element in JSON
public class JsonObject {
    public static let version = 3
    
    // MARC - Public API / Members -
    
    /// Actual value of the Element, can be anything
    public var val: AnyObject!
    
    /// Type of the element. Is defined in JsonElement.Types
    public var type: Int!
    
    public var string: String?
    public var int: Int?
    public var double: Double?
    public var array: NSArray?
    public var dict: NSDictionary?
    public var object: JsonObject?
    
    /// Element types
    public struct Types{
        // mostly for the value part of a pair or a value
        // part of an Array or a Dict
        public static let Unknown: Int = -1
        public static let Integer: Int = 1
        public static let String: Int = 2
        public static let Double: Int = 3
        public static let Array: Int = 4
        public static let Dictionary: Int = 5
    }
    
    // MARC: - Public API / Methods
    
    /// empty initializer
    public init(){
        // do nothing
    }
    
    public init(data: NSData) throws {
        do{
            try serialize(data)
        } catch let error as JsonError {
            // rethrow from here
            throw error
        }
    }
    
    public init(str: NSString) throws {
        // convert the NSString to NSData (for JSONObjectWithData, if that works, serialize the string
        if let data: NSData = str.dataUsingEncoding(NSUTF8StringEncoding) {
            do{
                try serialize(data)
            } catch let error as JsonError {
                // rethrow from here
                throw error
            }
        }
        else{
            // throw an invalid data error if dataUsingEncoding fails
            throw JsonError.InvalidData
        }
    }
    
    public init(obj: AnyObject) throws {
        do{
            try parse(obj)
        }
        catch let error as JsonError {
            throw error
        }
    }

    private func serialize(data: NSData) throws {
        // get the data out of the NSString and serialize it correctly
        var jsonData: AnyObject?
        
        do {
            jsonData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        } catch {
            throw JsonError.SyntaxError
        }
        
        // if everything went good, parse the JSON Data
        do{
            try parse(jsonData)
        }
        catch let error as JsonError {
            throw error
        }
    }
    
    private func parse(val: AnyObject?) throws {
        self.val = val
        self.type = Types.Unknown
        
        if let _ = val as? Int {
            type = Types.Integer
            self.int = (val as! Int)
            
            // while we are at it, convert the int also to a string
            self.string = String( val as! Int )
        }
        
        if let _ = val as? Double {
            type = Types.Double
            self.double = (val as! Double)
            
            // save the same as a string value es well
            self.string = String( stringInterpolationSegment: val as! Double)
        }
        
        if let _ = val as? String {
            type = Types.String
            self.string = (val as! String)
        }
        
        if let _ = val as? NSArray {
            type = Types.Array
            self.array = (val as! NSArray)
        }
        
        if let _ = val as? NSDictionary {
            type = Types.Dictionary
            self.dict = (val as! NSDictionary)
        }
        
        // check if a type was assigned or not
        if( self.type == Types.Unknown ){
            throw JsonError.InvalidType
        }
    }
    
    public func getJsonArray() -> Dictionary<String, AnyObject>{
        var jsonArray = Dictionary<String, AnyObject>()
        
        for( key, val ) in mData {
            if val.type == JsonElement.Types.Dictionary {
                jsonArray[key] = val.getJsonArray()
            }
            else if val.type == JsonElement.Types.Array {
                jsonArray[key] = val.getJsonArray()
            }
            else{
                jsonArray[key] = val.val
            }
        }
        
        return jsonArray
    }
    
    public func getJsonString() -> String {
        var jsonString: String = String()
        let jsonArray = getJsonArray()
        
        if NSJSONSerialization.isValidJSONObject(jsonArray) {
            if let data = try? NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    jsonString = string as String
                }
            }
        }
        
        return jsonString
    }
    
    public subscript(key: String) -> JsonObject? {
        get{
            return mData[key]
        }
    }

    public subscript(key: String) -> AnyObject? {
        get {
            return mData[key]?.val
        }
        
        set(val){
            set(key, val: val!)
        }
    }
    
    public func get(key: String) -> JsonObject? {
        return mData[key]
    }
    
    public func getError() -> NSError? {
        return mError
    }
    
    public func set(key: String, val: AnyObject){
        mData[key] = JsonElement(val: val)
    }
    
    public func isValid() -> Bool {
        return mValid
    }
}