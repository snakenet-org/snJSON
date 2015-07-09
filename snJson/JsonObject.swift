//
//  JsonObject.swift
//  json-swift
//
//  Created by Marc Fiedler on 08/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonObject: NSObject {
    private var mRawData = Dictionary<String, AnyObject>()
    private var mValid: Bool = false
    
    public init(data: String = ""){
        // Initialize the NSObject
        super.init()
        
        if( data != ""){
            // Parse the string into an array that we can work with
            self.mRawData = parse(data)
        }
        else{
            // the object is just being created, so there is no need not
            // to assume its valid at this point
            self.mValid = true
        }
    }
    
    // Parse the JSON String into a JSON Array<String, AnyObject>
    private func parse(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [String: AnyObject] {
                return dictionary
            }
        }
        return [String: AnyObject]()
    }
    
    // to add a String "Hello": "World"
    public func addString(key: String, val: String){
        self.mRawData[key] = val as AnyObject
    }
    
    // to add an Integer "Meaning of life": 42
    public func addInt(key: String, val: Int){
        self.mRawData[key] = val as AnyObject
    }
    
    // add an object into the object {"Animal": "Snake", "Species": "Boa"}
    public func addArr(key: String, val: AnyObject){
        let data = asArray(key, val: val);
        self.mRawData[data.key] = data.val
     }
    
    // get the JsonString
    public func getJsonString() -> String{
        return serialize(self.mRawData)
    }
    
    // get a String out of the json object "Hello": "World" => getString("Hello") -> "world"
    // or reeturn "" if no key with that value is avaliable
    public func getString(key: String) -> String!{
        if let val = self.mRawData[key] as? String {
            return self.mRawData[key] as! String
        }
        else{
            // if there is no string with this key, return an empty string
            return ""
        }
    }
    
    // get an integer at key position or return nil if no such key
    // has an integer value
    public func getInt(key: String) -> Int!{
        if let val = self.mRawData[key] as? Int {
            return self.mRawData[key] as! Int
        }
        else{
            return nil
        }
    }
    
    // get an array with a key or return an empty array if no such key as
    // an array value
    public func getArr(key: String) -> Dictionary<String, AnyObject>!{
        if let val = self.mRawData[key] as? Dictionary<String, AnyObject> {
            return self.mRawData[key] as! Dictionary<String, AnyObject>
        }
        else{
            return [:]
        }
    }
    
    // universal get function. You should know yourself whats comming out
    public func get(key: String) -> AnyObject{
        return self.mRawData[key]!
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
    private func serialize(value: AnyObject, prettyPrinted: Bool = false) -> String {
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