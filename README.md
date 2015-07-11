snakeNet JSON lib for Swift
==========

snJson is a tiny and simple JSON object lib for Swift

Import
-----

This tiny library is meant to simplify the use of JSON in Swift with no dependencies. The Interface to the objects is very simple.
Just import the snJson Library:

````swift
    import snJson
````

Usage
===========

Reading
--------

Example Json String:

````swift
    var jString = "{\"Name\": \"Jane Doe\", \"Url\": \"http://snakenet.org/\", \"Age\": 24, \"Parents\": {\"Mother\": \"Johanna Doe\", \"Father\": \"John Doe\"}, \"List\": [1, 2, 5, 3, 6, 3, 7], \"Aliases\": [\"Jack\", \"Jim\", \"James\"]}"

    let test = JsonObject(str: jString)
````

Ater the object is created you can access the different fields via the .string, .int, .double, .array or .dict members

````swift
    let name: String = test.get("Name")!.string!

    let age: Int = test.get("Age")!.int!

    let mother = test.get("Parents")?.object!.get("Mother")!.string
````

If you have nested elements, you can choose to directly access them or let the JsonElement class handle it

````swift
    // without JsonElement
    let parents:NSDictionary = test.get("Parents")!.dict!
    let father: String = parents["Father"] as! String

    // with JsonElement
    let mother = test.get("Parents")?.object!.get("Mother")!.string

let list = test.get("List")!.array!
````

The same applies for arrays

````swift
    let list = test.get("List")!.array!
````

You can turn any JsonObject back into a string with the .getJsonString() memner

````swift
    println("Name: \(name) - Age: \(age).")
    println("Mother: \(mother)")
    println("Father: \(father)")
    println("List: \(list)")

    println("Data: \(test.getJsonString())")

    /* Output:
        Name: Jane Doe - Age: 24.
        Mother: Optional("Johanna Doe")
        Father: John Doe
        List: ( 1, 2, 5, 3, 6, 3, 7 )
        Data: {
            "Name" : "Jane Doe",
            "Aliases" : {
                "0" : "Jack",
                "1" : "Jim",
                "2" : "James"
            },
            "List" : {
                "2" : 5,
                "1" : 2,
                "6" : 7,
                "3" : 3,
                "4" : 6,
                "0" : 1,
                "5" : 3
            },
            "Parents" : {
                "Father" : "John Doe",
                "Mother" : "Johanna Doe"
            },
            "Url" : "http:\/\/snakenet.org\/",
            "Age" : 24
        }
*/
````

Writing
--------

To write into a new object is equally straight forward:

````swift
    let myList = ["Apple", "Microsoft", "Sony", "Samsung"]
    let myDict = [
        "Microsoft": "XBox",
        "Sony": "Playstation",
        "Nintendo": "Wii"
    ]

    var jTest = JsonObject()

    jTest.set("myName", val: "Marc Fiedler")
    jTest.set("myUrl", val: "Http://snakenet.org")
    jTest.set("PhoneBrands", val: myList)
    jTest.set("Consoles", val: myDict)

    println("Data: \(jTest.getJsonString())")

    /* Output:
        Data: 
        {
            "Consoles" : {
                "Sony" : "Playstation",
                "Nintendo" : "Wii",
                "Microsoft" : "XBox"
            },
            "myUrl" : "Http:\/\/snakenet.org",
            "myName" : "Marc Fiedler",
            "PhoneBrands" : {
                "2" : "Sony",
                "1" : "Microsoft",
                "0" : "Apple",
                "3" : "Samsung"
            }
        }

    */
````

Error Handling
--------
Errors are handles on a per-element basis. If something goes wrong while parsing or an element if of a type that is not supported .isValid() will return false and .getError() will provide you with an NSError

````swift
    let test = JsonObject(str: jString)
    
    if( !test.isValid() ){
        println("Test Error: \(test.getError())")
    }
    else{
        // go on
    }
````


Copywrite
===========

(c) 2015 Marc Fiedler for [snakeNet.org] 

[snakenet.org]: http://snakenet.org/
