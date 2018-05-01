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
    
    func settleShape() {
        guard let shape = fallingShape else {
            return
        }
        
        for block in shape.blocks {
            blockArray[block.column, block.row] = block
        }
        
        fallingShape = nil
        delegate?.gameShapeDidLand(swiftris: self)
    }
    
    func detectTouch() -> Bool {
        guard let shape = fallingShape else {
            return false
        }
        
        for bottomBlock in shape.bottomBlocks {
            if bottomBlock.row == NumRows - 1
                || blockArray[bottomBlock.column, bottomBlock.row + 1] != nil {
                    return true
            }
        }
        
        return false
    }
    
    func endGame() {
        delegate?.gameDidEnd(swiftris: self)
    }
    
    func dropShape() {
        guard let shape = fallingShape else {
            return
        }
        
        while detectIllegalPlacement() == false {
            shape.lowerShapeByOneRow()
        }
        
        shape.raiseShapeByOneRow()
        delegate?.gameShapeDidDrop(swiftris: self)
    }
    
    func letShapeFall() {
        guard let shape = fallingShape else {
            return 
        }
        
        shape.lowerShapeByOneRow()
        if detectIllegalPlacement() {
            shape.raiseShapeByOneRow()
            if detectIllegalPlacement() {
                endGame()
            } else {
                settleShape()
            }
        } else {
            delegate?.gameShapeDidDrop(swiftris: self)
            if detectTouch() {
                settleShape()
            }
        }
    }

    func rotateShape() {
        guard let shape = fallingShape else {
            return
        }
        
        shape.rotateClockwise()
        guard detectIllegalPlacement() == false else {
            shape.rotateCounterClockwise()
            return
        }
        
        delegate?.gameShapeDidMove(swiftris: self)
    }
    
    func moveShapeLeft() {
        guard let shape = fallingShape else {
            return
        }
        
        shape.shiftLeftByOneColumn()
        guard detectIllegalPlacement() == false else {
            shape.shiftRightByOneColumn()
            return
        }
        
        delegate?.gameShapeDidMove(swiftris: self)
    }
    
    func moveShapeRight() {
        guard let shape = fallingShape else {
            return
        }
        
        shape.shiftRightByOneColumn()
        guard detectIllegalPlacement() == false else {
            shape.shiftLeftByOneColumn()
            return
        }
        
        delegate?.gameShapeDidMove(swiftris: self)
    }
}


