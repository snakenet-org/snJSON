snakeNet Json (snJson)
==========

Tiny JSON object lib for swift

Usage
-----

This tiny library is meant to simplify the use of JSON in Swift. The Interface to the objects is very simple.
Just add [snJson/JsonObject.swift] or import the snJson Library

[snJson/JsonObject.swift]: ./snJson/JsonObject.swift

Synopsis
--------

How to parse a string into an object

````swift
    let testString = "{\"Name\": \"Jane Doe\", \"Url\": \"http://snakenet.org/\", \"Age\": 24, \"Parents\": {\"Mother\": \"Johanna Doe\", \"Father\": \"John Doe\"}}"
    
    let tJson = JsonObject(data: testString)
    
    let t1 = tJson.getString("Name")
    let t2 = tJson.getString("Url")
    let t3 = tJson.getInt("Age")
    let t4 = tJson.getArr("Parents")
    
    println("Name: \(t1)")
    println("Url: \(t2)")
    println("Age: \(t3)")
    println("Arr: \(t4)")
````

How to parse an object into a string

````swift
    var tJson2 = JsonObject()
    tJson2.addString("Snake", val: "Boa")
    tJson2.addString("Aqua", val: "Adder")
    tJson2.addInt("Major", val: 1)
    tJson2.addArr("Version", val: ["Major": 1, "Minor": 1, "Patch": 0])
    
    println("Test2: \(tJson2.getJsonString())")
````

Error handling has not yet been implemented, but I will keep the lib Swift2 compatible and with the changes to Swift I will also improve the lib.

Copywrite
===========

[page/snakeNet.org]

[page/snakenet.org]: http://snakenet.org/
