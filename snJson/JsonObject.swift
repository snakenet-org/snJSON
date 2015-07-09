//
//  JsonObject.swift
//  json-swift
//
//  Created by Marc Fiedler on 08/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonObject {
    private var mRawData = Dictionary<String, AnyObject>()
    private var mValid: Bool = false
    private var mData =  Dictionary<String, JsonAttribute>()
    
    public init(str: String = ""){
        // Initialize the NSObject
        //super.init()
        
        if( str != ""){
            // Parse the string into an array that we can work with
            self.mRawData = deserialize(str)
            self.parse(self.mRawData)
        }
        else{
            // the object is just being created, so there is no need not
            // to assume its valid at this point
            self.mValid = true
        }
    }
    
    public init(arr: Dictionary<String, AnyObject>){
        //super.init()
        // parse the array
        self.parse(arr)
    }
    
    // Deserialize the JSON String into a JSON Array<String, AnyObject>
    private func deserialize(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String: AnyObject] {
                return dictionary
            }
        }
        return [String: AnyObject]()
    }
    
    private func parse(data: Dictionary<String, AnyObject>){
        for(key, val) in data {
            // if its Integer castable
            if let iVal = val as? Int {
                mData[key] = JsonAttribute(val: val, type: JsonType.Integer)
            }
            
            if let sVal = val as? String {
                mData[key] = JsonAttribute(val: val, type: JsonType.String)
            }
            
            if let oVal = val as? Dictionary<String, AnyObject> {
                mData[key] = JsonAttribute(val: JsonObject(arr: val as! Dictionary<String, AnyObject>), type: JsonType.Object)
            }
            
            if let liVal = val as? [Int] {
                mData[key] = JsonAttribute(val: val, type: JsonType.IntegerList)
            }
            
            if let lsVal = val as? [String] {
                mData[key] = JsonAttribute(val: val, type: JsonType.StringList)
            }
        }
        
        self.mValid = true;
    }
    
    // add a new object
    public func add(key: String, val: AnyObject){
        // Type check
        if let iVal = val as? Int {
            self.mData[key] = JsonAttribute(val: val, type: JsonType.Integer)
        }
        if let sVal = val as? String {
            self.mData[key] = JsonAttribute(val: val, type: JsonType.String)
        }
        if let oVal = val as? JsonObject {
            self.mData[key] = JsonAttribute(val: val, type: JsonType.Object)
        }
        if let liVal = val as? [Int] {
            self.mData[key] = JsonAttribute(val: val, type: JsonType.IntegerList)
        }
        if let lsVal = val as? [String] {
            self.mData[key] = JsonAttribute(val: val, type: JsonType.StringList)
        }
     }
    
    // get the JsonString
    public func getJsonString() -> String{
        return serialize()
    }
    
    // get the Array that represents this Json Object
    public func getJsonArray() -> Dictionary<String, AnyObject>{
        var data = Dictionary<String, AnyObject>()
        for( key, val ) in mData {
            if( val.type == JsonType.Object ){
                let d: JsonObject = val.value()!
                data[key] = d.getJsonArray()
            }
            else{
                data[key] = val.val
             }
        }
        
        return data
    }
    
    // universal get function. You should know yourself whats comming out
    public func get(key: String) -> JsonAttribute{
        return self.mData[key]!
    }
    
    // report if this object is a valid JSON object
    public func isValid() -> Bool{
        return self.mValid
    }
    
    // return a key val pair as a key {val.key: val.val} pair
    private func asArray(key: String, val: AnyObject) -> (key: String, val: [String: AnyObject]){
        var transformed = Dictionary<String, AnyObject>()
    
        // if the array "var" can be cast into a Dict, proceed
        if let _val = val as? Dictionary<String, AnyObject>{
            for(key, value) in _val{
                if let strVal = value as? String{
                    // the key must always be a String, but value can be
                    // string, Int or even an array
    
                    transformed[key] = value
                }
    
                if let intVal = value as? Int{
                    transformed[key] = value
                }
                
                // for arrays in arrays
                if let arrVal = value as? Dictionary<String, AnyObject>{
                    let data = asArray(key, val: value)
                    transformed[data.key] = data.val
                }
            }
        }
        
        return (key, transformed)
    }
    
    // use Json Serialization
    private func serialize(prettyPrinted: Bool = false) -> String {
        var value = self.getJsonArray()
        
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }
        }
        return ""
    }
}