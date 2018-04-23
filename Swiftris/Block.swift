//
//  Block.swift
//  Swiftris
//
//  Created by Cara on 4/22/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6

enum BlockColor: Int, CustomStringConvertible{
    
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    var spriteName: String{
        switch self{
        case .Blue:
            return "blue"
        
        case .Orange:
            return "orange"
        
        case .Purple:
            return "purple"
        
        case .Red:
            return "red"
        
        case .Teal:
            return "teal"
        
        case .Yellow:
            return "yellow"
        }
    }
    
    var description: String{
        return self.spriteName
    }
    
    static func random() -> BlockColor {
        return BlockColor(rawValue: Int(arc4random_uniform(NumberOfColors)))!
    }
}

// Hashable allows us to store Block in the Array 2D
class Block: Hashable, CustomStringConvertible {
    
    // Constants
    let color: BlockColor
    
    // Properties
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    /* This shortens the call of block.color.spriteName to block.spriteName */
    var spriteName: String {
        return color.spriteName
    }
    
    // Fulfilling the Hashable protocol
    var hashValue: Int {
        return self.column ^ self.row
    }
    
    // Fulfilling the CustomStringConvertible protocol
    var description: String {
        return "\(color): [\(column), \(row)]"
    }
    
    // Initializes the class
    init(column:Int, row:Int, color:BlockColor){
        self.column = column
        self.row = row
        self.color = color
    }
    
    static func == (lhs: Block, rhs: Block) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.rawValue == rhs.color.rawValue
    }
}
