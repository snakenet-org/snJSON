//
//  JsonObject.swift
//  json-swift
//
//  Created by Marc Fiedler on 08/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonObject {
    public static let version = 3
    
    private var mValid: Bool!
    private var mError: NSError?
    private var mData = Dictionary<String, JsonElement>()
    
    public struct JsonErrors {
        static let Unknown: Int = -1
        static let DataNotConvertable: Int = 1
        static let JSONSyntaxError = 2
        static let UnknownElementType = 3
    }
    
    public init(){
        mValid = true
    }
    
    public init(data: NSData){
        serialize(data)
    }
    
    public init(str: NSString){
        // convert the NSString to NSData (for JSONObjectWithData, if that works, serialize the string
        if let data = str.dataUsingEncoding(NSUTF8StringEncoding) {
            serialize(data)
        }
        else{
            mValid = false
            mError = NSError(domain: "JsonObject", code: JsonErrors.DataNotConvertable, userInfo: nil)
        }
    }
    
    public init(obj: AnyObject?){
        parse(obj)
    }

    private func serialize(data: NSData){
        var error:NSError?
        // get the data out of the NSString and serialize it correctly
        var jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error)
            
        if let anError = error {
            // something went wrong!
            mValid = false
            mError = error
        }
        else{
            parse(jsonData)
        }
    }
    
    private func parse(jsonData: AnyObject?){
        if let jsonArr = jsonData as? NSArray {
            // data was an array
            mValid = true
            
            var counter: Int = 0
            for element in jsonArr {
                if( !catalogue(String(counter), val: element) ){
                    mValid = false
                    mError = NSError(domain: "JsonObject", code: JsonErrors.UnknownElementType, userInfo: nil)
                    break
                }
                
                counter++
            }
        }
        
        if let jsonDict = jsonData as? NSDictionary {
            // data is a dict
            mValid = true
            
            for(key, val) in jsonDict {
                // we can safely assume that key will always be a String
                if( !catalogue(key as! String, val: val) ){
                    mValid = false
                    mError = NSError(domain: "JsonObject", code: JsonErrors.UnknownElementType, userInfo: nil)
                    break
                }
            }
        }
    }
    
    // catalogue a key/value pair into mData
    private func catalogue(key: String, val: AnyObject) -> Bool{
        mData[key] = JsonElement(val: val)
        return mData[key]!.valid
    }
    
    public func getJsonArray() -> Dictionary<String, AnyObject>{
        var jsonArray = Dictionary<String, AnyObject>()
        
        for( key, val ) in mData {
            if val.type == JsonElement.Types.Dictionary {
                jsonArray[key] = val.object!.getJsonArray()
            }
            else if val.type == JsonElement.Types.Array {
                jsonArray[key] = val.object!.getJsonArray()
            }
            else{
                jsonArray[key] = val.val
            }
        }
        
        return jsonArray
    }
    
    public func getJsonString() -> String {
        var jsonString: String = String()
        var jsonArray = getJsonArray()
        
        if NSJSONSerialization.isValidJSONObject(jsonArray) {
            if let data = NSJSONSerialization.dataWithJSONObject(jsonArray, options: NSJSONWritingOptions.PrettyPrinted, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    jsonString = string as String
                }
            }
        }
        
        return jsonString
    }
    
    public subscript(key: String) -> JsonElement? {
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
    
    public func get(key: String) -> JsonElement? {
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