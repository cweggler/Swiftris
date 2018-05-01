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
    
    // Created a function named random that chooses an
    // orientation at random to start with!
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(NumOrientations)))!
    }
    
    // This determines how the block is going to move across the
    // screen
    static func rotate(orientation:Orientation, clockwise: Bool) -> Orientation {
        
        var rotated = orientation.rawValue + (clockwise ? 1 : -1 )
        
        if rotated > Orientation.TwoSeventy.rawValue{
            rotated = Orientation.Zero.rawValue
        }
        else if rotated < 0 {
            rotated = Orientation.TwoSeventy.rawValue
        }
        
        return Orientation(rawValue: rotated)!
    }
}

// number of total shape varieties
let NumShapeTypes: UInt32 = 7

// Shape Indices
let FirstBlockIdx: Int = 0
let SecondBlockIdx: Int = 1
let ThirdBlockIdx: Int = 2
let FourthBlockIdx: Int = 3

/* Creating the Shape class and extending the 2 protocols
Hashable and CustomStringConvertible */
class Shape: Hashable, CustomStringConvertible {
    
    // The color of the shape
    let color: BlockColor
    
    // The blocks comprising of the shape
    var blocks = Array<Block>()
    
    // The current orientation of the shape
    var orientation: Orientation
    
    // The column and row representing the shape's anchor point
    // This will be important for how the shape will move
    var column, row: Int
    
    
    // Required Overrides
    
    // Subclasses must override these properties
    // Notice these require a return of a dictionary
    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>]{
        return [:]
    }
    
    var bottomBlocksForOrientations: [Orientation: Array<Block>]{
        return [:]
    }
    
    var bottomBlocks:Array<Block> {
        guard let bottomBlocks = bottomBlocksForOrientations[orientation] else{
                return []
        }
        return bottomBlocks
    }
    
    // Hashable
    
    var hashValue: Int {
        
        return blocks.reduce(0) { $0.hashValue ^ $1.hashValue}
    }
    
    // CustomStringConvertible
    
    var description: String {
        
        return "\(color) block facing \(orientation): \(blocks[FirstBlockIdx]), \(blocks[SecondBlockIdx]), \(blocks[ThirdBlockIdx]), \(blocks[FourthBlockIdx])"
    }
    
    // Initializes our Shape Class
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation){
        
        self.color = color
        self.column = column
        self.row = row
        self.orientation = orientation
        initializeBlocks()
    }
    
    // Set up a convenience initializer to simplify the process
    // Also calls an orientation and color at random which we want
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color: BlockColor.random(), orientation:Orientation.random())
    }
    
    // This function cannot be overridden by subclasses
    
    final func initializeBlocks(){
        guard let blockRowColumnTranslations = blockRowColumnPositions[orientation] else {
                return
        }
        
        blocks = blockRowColumnTranslations.map {(diff) -> Block in
            return Block(column: column + diff.columnDiff, row: row + diff.rowDiff, color: color)
        }
    }
    
    final func rotateBlocks(orientation: Orientation){
        
        guard let blockRowColumnTranslation:Array<(columnDiff: Int, rowDiff: Int)> = blockRowColumnPositions[orientation] else {
            
            return
            
        }
        
        for(idx, diff) in blockRowColumnTranslation.enumerated() {
            blocks[idx].column = column + diff.columnDiff
            blocks[idx].row = row + diff.rowDiff
        }
    }
    
    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: true)
        rotateBlocks(orientation: newOrientation)
        orientation = newOrientation
    }
    
    final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(orientation: orientation, clockwise: false)
        rotateBlocks(orientation: newOrientation)
        orientation = newOrientation
    }
    
    final func shiftBy(columns: Int, rows: Int){
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    
    final func lowerShapeByOneRow() {
        shiftBy(columns: 0, rows: 1)
    }
    
    final func raiseShapeByOneRow() {
        shiftBy(columns: 0, rows: -1)
    }
    
    final func shiftRightByOneColumn() {
        shiftBy(columns: 1, rows: 0)
    }
    
    final func shiftLeftByOneColumn() {
        shiftBy(columns: -1, rows: 0)
    }
    
    final func moveTo(column:Int, row:Int){
        self.column = column
        self.row = row
        rotateBlocks(orientation: orientation)
    }
    
    final class func random(startingColumn: Int, startingRow: Int) -> Shape {
        switch Int(arc4random_uniform(NumShapeTypes)){
        
        case 0:
            return SquareShape(column: startingColumn, row: startingRow)
        
        case 1:
            return LineShape(column: startingColumn, row: startingRow)
            
        case 2:
            return TShape(column: startingColumn, row: startingRow)
        
        case 3:
            return LShape(column: startingColumn, row: startingRow)
        
        case 4:
            return JShape(column: startingColumn, row: startingRow)
        
        case 5:
            return SShape(column: startingColumn, row: startingRow)
        
        default:
            return ZShape(column: startingColumn, row: startingRow)
        }
    }
}

// Have to create a custom "=" operator to fulfill
// the Hashable protocol
func ==(lhs: Shape, rhs: Shape) -> Bool{
    return lhs.row == rhs.row && lhs.column == rhs.column
}


