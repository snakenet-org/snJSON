//
//  JsonType.swift
//  snJson
//
//  Created by Marc Fiedler on 09/07/15.
//  Copyright (c) 2015 snakeNet.org. All rights reserved.
//

import UIKit

public class JsonType: NSObject {
    public static let Integer: Int = 0
    public static let String: Int = 1
    public static let List: Int = 2
    public static let Object: Int = 3
    public static let IntegerList: Int = 4
    public static let StringList: Int = 5
    public static let ObectList: Int = 6
    
    public override init() {
        super.init()
    }
}
