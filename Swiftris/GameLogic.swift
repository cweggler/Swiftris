//
//  GameLogic.swift
//  Swiftris
//
//  Created by Cara on 4/30/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

let NumColumns = 10
let NumRows = 20

let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1

protocol GameLogicDelegate {
    
    // Invoked when the current round ends
    func gameDidEnd(swiftris: GameLogic)
    
    // Invoked after a new game has begun
    func gameDidBegin(swiftris: GameLogic)
    
    // Invoked when the falling shape has become part of the game board
    func gameShapeDidLand(swiftris: GameLogic)
    
    // Invoked when the falling shape has changed its location
    func gameShapeDidMove(swiftris: GameLogic)
    
    // Invoked when the falling shape has changed its location after
    // being dropped
    func gameShapeDidDrop(swiftris: GameLogic)
    
    // Invoked when the game has reached a new level
    func gameDidLevelUp(swiftris: GameLogic)
}

class GameLogic {
    var blockArray: Array2D<Block>
    var nextShape: Shape?
    var fallingShape: Shape?
    var delegate: GameLogicDelegate?
    
    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(columns: NumColumns, rows: NumRows)
    }
    
    func beginGame() {
        if (nextShape == nil){
            nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        }
        
        delegate?.gameDidBegin(swiftris: self)
    }
    
    func newShape() -> (fallingShape: Shape?, nextShape: Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(startingColumn: PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(column: StartingColumn, row: StartingRow)
        
        guard detectIllegalPlacement() == false else {
            nextShape = fallingShape
            nextShape!.moveTo(column: PreviewColumn, row: PreviewRow)
            endGame()
            return(nil, nil)
        }
        
        return(fallingShape, nextShape)
    }
    
    func detectIllegalPlacement() -> Bool {
        guard let shape = fallingShape else {
            return false
        }
        
        for block in shape.blocks {
            if block.column < 0 || block.column >= NumColumns
                || block.row < 0 || block.row >= NumRows {
                return true
            } else if blockArray[block.column, block.row] != nil {
                return true
            }
        }
        
        return false
    }
}


