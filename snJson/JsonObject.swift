//
//  JsonObject.swift
//  json-swift
//
//  Created by Marc Fiedler on 08/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonObject {
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
    
    public init(str: NSString){
        serialize(str)
    }
    
    public init(data: AnyObject?){
        parse(data)
    }

    private func serialize(str: NSString){
        var error:NSError?
        // convert the NSString to NSData (for JSONObjectWithData, if that works, serialize the string
        if let data = str.dataUsingEncoding(NSUTF8StringEncoding) {
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
        else{
            mValid = false
            mError = NSError(domain: "JsonObject", code: JsonErrors.DataNotConvertable, userInfo: nil)
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
        var typeAssigned = false
        if let iVal = val as? Int {
            mData[key] = JsonElement(val: val, type: JsonElement.Types.Integer)
            typeAssigned = true
        }
        
        if let sVal = val as? String {
            mData[key] = JsonElement(val: val, type: JsonElement.Types.String)
            typeAssigned = true
        }
        
        if let aVal = val as? NSArray {
            mData[key] = JsonElement(val: JsonObject(data: val), type: JsonElement.Types.Array)
            typeAssigned = true
        }
        
        if let dVal = val as? NSDictionary {
            mData[key] = JsonElement(val: JsonObject(data: val), type: JsonElement.Types.Dictionary)
            typeAssigned = true
        }
        
        return typeAssigned
    }
    
    public func get(key: String) -> JsonElement? {
        return mData[key]
    }
    
    public func getError() -> NSError? {
        return mError
    }
    
    public func isValid() -> Bool {
        return mValid
    }
}