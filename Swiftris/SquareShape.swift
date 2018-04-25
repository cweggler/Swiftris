//
//  SquareShape.swift
//  Swiftris
//
//  Created by Cara on 4/24/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

class SquareShape:Shape {
    
    /*
        | 0 | 1 |
        | 2 | 3 |
     
     marks the row/column indicator for the square shape
 
    */
    
   
    // square shape will not rotate
 
    /* Have to override these properties as set up in
        the Shape class
    */

    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        
        return [
            
            Orientation.Zero: [(0,0), (1,0), (0,1), (1,1)],
            Orientation.OneEighty: [(0,0), (1,0), (0,1), (1,1)],
            Orientation.Ninety: [(0,0), (1,0), (0,1), (1,1)],
            Orientation.TwoSeventy: [(0,0), (1,0), (0,1), (1,1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        
        return [
            
            Orientation.Zero: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
        
        ]
    }
}
