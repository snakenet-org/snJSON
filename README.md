snakeNet's JSON lib for Swift 2
==========

snJson is a tiny and simple JSON object lib for Appl's' Swift >= 2.0. 
A very simple HTTP request service (JsonService) also comes with the library

Import
-----

This tiny library is meant to simplify the use of JSON in Swift with no dependencies.

Usage
===========

JsonObject
--------

All you need is the JsonObject class. All json related tasks will be handled inside the class.

Example Json String:

````swift
    var jString = "{\"Name\": \"Jane Doe\", \"Url\": \"http://snakenet.org/\", \"Age\": 24, \"Parents\": {\"Mother\": \"Johanna Doe\", \"Father\": \"John Doe\"}, \"List\": [1, 2, 5, 3, 6, 3, 7], \"Aliases\": [\"Jack\", \"Jim\", \"James\"]}"

    do{
        let test = try JsonObject(str: jString)
        print("Json: \(test.getJsonString())")
    } catch {
        print("Error, Invalid json")
    }
````

Ater the object is created you can access the different fields via the .string, .int or .double members

````swift
    let name: String = test["Name"]!.string!
    let age: Int = test["Age"]!.int!
    let mother = test["Parents"]!["Mother"]!.string!

    /** Output 
        Jane Doe: 24 -> Johanna Doe
    */
````

You can Access indices via String or Int identifier (if the key is a number)

````swift
    let json: JsonObject = JsonObject()

    json["TestStr"] = "Hello World"
    json["TestInt"] = 2
    json["TestDouble"] = 2.0
    json["TestBool"] = true
    json["TestArr"] = [1,2,3,4,5]
    json["TestArr2"] = ["A", "B", "C"]
    json["TestDict"] = ["A": 1, "B": 2.0, "C": "3"]

    let str = json["TestStr"]!.string!
    let i1 = json["TestArr"]!["1"]!.int!
    let i2 = json["TestArr"]![1]!.int!

    print("Test 1: \(str)")
    print("Test 2: \(i1)")
    print("Test 3: \(i2)")

    /** Output
        Test 1: Hello World
        Test 2: 2
        Test 3: 2
    */
````

You can turn any JsonObject back into a string with the .getJsonString() member

````swift
    println("Data: \(test.getJsonString())")

    /* Output:
    {
        "TestStr" : "Hello World",
        "TestBool" : 1,
        "TestInt" : 2,
        "TestDict" : { "C" : "3", "B" : 2, "A" : 1 },
        "TestArr" : [5,3,2,1,4],
        "TestDouble" : 2,
        "TestArr2" : [ "A", "B", "C" ]
    }
    */
````

Simple Networking
--------
snJson also comes with a very simple networking interface. You can make HTTP requests with it that will reply with JSON

````swift
    // in one of your functions

    JsonService.request("https://www.omdbapi.com/?t=Game%20of%20Thrones&Season=1&Episode=1", success: didReceiveData)
````

````swift
    /// Callback function inside your code
    func didReceiveData(data: JsonObject){
        let title = data["Title"]!.string
        let year = data["Year"]!.string
        let rating = data["imdbRating"]!.string

        print("\(title): \(year) -- \(rating)")
    }

    /** Output
        Optional("Winter Is Coming"): Optional("2011") -- Optional("8.4")
    */
````



Error Handling
--------
JsonObject will throw a JsonError if something during the parsing process goes wrong or if the provided data is not a valid JSON string

````swift
    do{
        let test2 = try JsonObject(str: jString)
        print("Json: \(test2.getJsonString())")
    } catch JsonError.SyntaxError {
        print("Invalid JSON Syntax")
    } catch JsonError.InvalidData {
        print("Unable to parse Data")
    } catch JsonError.InvalidType {
        print("Invalid JSON Data type used")
    } catch JsonError.Unknown {
        print("Unknown Json Error! Check the console")
    } catch {
        print("Something outside of JSON collapsed")
    }
````

License
===========
snJSON is available under the MIT license. See the LICENSE file for more info.


Copywrite
===========

(c) 2015 Marc Fiedler for [snakeNet.org] 

[snakenet.org]: http://snakenet.org/
