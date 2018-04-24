//
//  Shape.swift
//  Swiftris
//
//  Created by Cara on 4/23/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import SpriteKit

let NumOrientations: UInt32 = 4

enum Orientation: Int, CustomStringConvertible {
    
    case Zero = 0, Ninety, OneEighty, TwoSeventy
    
    // fulfills the CustomStringConvertible protocol
    var description: String {
        switch self {
            case .Zero:
                return "0"
            
            case .Ninety:
                return "90"
            
            case .OneEighty:
                return "180"
            
            case .TwoSeventy:
                return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }
}
