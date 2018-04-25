//
//  LineShape.swift
//  Swiftris
//
//  Created by Cara on 4/24/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

class LineShape:Shape {
    
    /*
        Orientations 0 & 180
            | 0 |
            | 1 |
            | 2 |
            | 3 |
     
        Orientations 90 & 270
     
        | 0 | 1 | 2 | 3 |
 
        marks the row/column indicator for the line shape
    */
    
    // the line shape only has 2 positions when rotating
    // It hinges on the 2nd block
    
    /* Have to override these properties as set up in
     the Shape class
     */
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        
        return [
            
            Orientation.Zero: [(0,0), (0,1), (0,2), (0,3)],
            Orientation.Ninety: [(-1,0), (0,0), (1,0), (2,0)],
            Orientation.OneEighty: [(0,0), (0,1), (0,2), (0,3)],
            Orientation.TwoSeventy: [(-1,0), (0,0), (1,0), (2,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        
        return [
            
            Orientation.Zero: [blocks[FourthBlockIdx]],
            Orientation.Ninety: blocks,
            Orientation.OneEighty: [blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: blocks
        ]
    }
}
