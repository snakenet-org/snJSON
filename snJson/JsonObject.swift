//
//  JsonObject.swift
//  json-swift
//
//  Created by Marc Fiedler on 08/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

/// Errors that can occur in the JSON Object
public enum JsonError: ErrorType {
    case Unknown
    case SyntaxError
    case InvalidData
    case InvalidType
    case IndexNotFound
    case NetworkError
}

/// A JSON Object. Each Object is also an Element in JSON
public class JsonObject {
    public static let version = 3
    
    // MARK: - Public API / Members -
    
    /// Type of the element. Is defined in JsonElement.Types
    public var type: Int!
    
    public var string: String?
    public var int: Int?
    public var double: Double?
    
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
    
    // MARK: - Privates
    private var mData = Dictionary<String, JsonObject>()
    
    // MARK: - Public API / Methods
    
    /// empty initializer
    public init(){
        // every initial object is always a dict.
        self.type = Types.Dictionary
        
        // MARK: - Maybe change this in the future?
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
        
        if let vArr: NSArray = val as? NSArray {
            type = Types.Array
            
            var count: Int = 0
            for vl in vArr {
                do{
                    try set("\(count)", val: vl)
                }
                catch let error as JsonError{
                    throw error
                }
                count++
            }
        }
        
        if let vDict = val as? NSDictionary {
            type = Types.Dictionary
            for (key, val) in vDict {
                do{
                    try set(key as! String, val: val)
                }
                catch let error as JsonError{
                    throw error
                }
            }
        }
        
        // check if a type was assigned or not
        if( self.type == Types.Unknown ){
            throw JsonError.InvalidType
        }
    }
    
    private func getJsonArray() -> Array<AnyObject> {
        var jsonArray = Array<AnyObject>()
        
        for( _, val ) in mData {
            switch( val.type ){
            case Types.Array:
                jsonArray.append( val.getJsonArray() )
            
            case Types.Dictionary:
                jsonArray.append( val.getJsonDict() )
                
            case Types.Double:
                jsonArray.append( val.double! )
                
            case Types.String:
                jsonArray.append( val.string! )
                
            case Types.Integer:
                jsonArray.append( val.int! )
                
            default:
                print("Error, default in getJsonArray")
            }
        }
        
        return jsonArray
    }
    
    private func getJsonDict() -> Dictionary<String, AnyObject>{
        var jsonDict = Dictionary<String, AnyObject>()
        
        for( key, val ) in mData {
            switch( val.type ){
            case Types.Array:
                jsonDict[key] = val.getJsonArray()

            case Types.Dictionary:
                jsonDict[key] = val.getJsonDict()

            case Types.String:
                jsonDict[key] = val.string
                
            case Types.Integer:
                jsonDict[key] = val.int
                
            case Types.Double:
                jsonDict[key] = val.double
                
            default:
                print("Error, default in getJsonDict")
            }
        }
        
        return jsonDict
    }
    
    public func getJsonString() -> String {
        var jsonString: String = String()
        // just define the start point according to the type of this object
        if( type == Types.Array ){
            let jsonArray = getJsonArray()
            
            if NSJSONSerialization.isValidJSONObject(jsonArray) {
                if let data = try? NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted) {
                    if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        jsonString = string as String
                    }
                }
            }
        }
        else{
            let jsonDict = getJsonDict()
            
            if NSJSONSerialization.isValidJSONObject(jsonDict) {
                if let data = try? NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions.PrettyPrinted) {
                    if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        jsonString = string as String
                    }
                }
            }
        }
        
        return jsonString
    }

    public subscript(key: AnyObject) -> AnyObject? {
        get{
            return get(key)
        }
        
        set(val){
            do{
                try set(key, val: val!)
            } catch {
                // MARK :- This might be better to throw as well??
                print("Error, could not set value")
            }
        }
    }
    
    public subscript(key: AnyObject) -> JsonObject? {
        return get(key)
    }
    
    public func get(key: AnyObject) -> JsonObject? {
        let empty: JsonObject? = nil
        
        guard let data: JsonObject = mData["\(key)"] else {
            // return nil if this key does not exist
            print("JsonObject [get] - Data not found")
            return empty
        }
        
        return data
    }
    
    public func set(key: AnyObject, val: AnyObject) throws {
        do{
            mData["\(key)"] = try JsonObject(obj: val)
        }
        catch let error as JsonError{
            throw error
        }
    }
}