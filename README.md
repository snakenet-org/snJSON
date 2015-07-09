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

After parsing, the object will present you with two different ways to access the data. Firstly via the .val attribute on each element. For instance: 

````swift
    let test = json.get("test").val as! String
````

if you use the .val attribute you need to unwrap the type by yourself though. Secondly via the .value() member of each element. For example

````swift
    let test: String = json.get("test").value()
````

Here are some test cases:
````swift
    // example string
    var jString = "{\"Name\": \"Jane Doe\", \"Url\": \"http://snakenet.org/\", \"Age\": 24, \"Parents\": {\"Mother\": \"Johanna Doe\", \"Father\": \"John Doe\"}, \"List\": [1, 2, 5, 3, 6, 3, 7], \"Aliases\": [\"Jack\", \"Jim\", \"James\"]}"
    
    // example Object (read)
    var jTest1 = JsonObject(str: jString)
    
    // you can get each value via the .val attribite. But you need to unwrap it
    // by yourself
    let name = jTest1.get("Name").val as! String
    
    // with inpicit data types
    let list = jTest1.get("List").array()
    
    // with explicit data types
    let url: String = jTest1.get("Url").string()!
    
    // not unwrapped
    let id: Int? = jTest1.get("Age").value()
    
    // unwrapped
    let aliases: [String] = jTest1.get("Aliases").array()! as! [String]

    // multiple objects in one object
    let FatherName: String = jTest1.get("Parents").value()!.get("Father").value()!
    
    // test
    println("URL: \(url)")  
    println("Person: \(name): \(id)")
    println("Father: \(FatherName)")
    println("List: \(list)")
    println("Aliases: \(aliases)")

    /* Output:
        URL: http://snakenet.org/
        Person: Jane Doe: Optional(24)
        Father: John Doe
        List: Optional((
            1,
            2,
            5,
            3,
            6,
            3,
            7
        ))
        Aliases: [Jack, Jim, James]
    */
````

Writing
--------

To write into a new object is equally straight forward:

````swift
    var jTest2 = JsonObject()
    var person = JsonObject()
    person.add("Name", val: "Marc Fiedler")
    person.add("Url", val: "http://snakeNet.org/")

    jTest2.add("Type", val: "Tree")
    jTest2.add("Count", val: 2)
    jTest2.add("Person", val: person)

    println("\(jTest2.getJsonString())")

    /* Output:
        {"Type":"Tree","Count":2,"Person":{"Name":"Marc Fiedler","Url":"http:\/\/snakeNet.org\/"}}
    */
````

Error Handling
--------
Error handling has not yet been implemented, but I will keep the lib Swift 2.0 compatible and with the changes to the Swift language I will also improve the lib.

````swift
    if( jTest1.isValid() ){
        //...
    }
    else{
        println("Unable to read JSON string")
    }
````


Copywrite
===========

[snakeNet.org]

[snakenet.org]: http://snakenet.org/
