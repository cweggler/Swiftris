//
//  ZShape.swift
//  Swiftris
//
//  Created by Cara on 4/24/18.
//  Copyright © 2018 Bloc. All rights reserved.
//

class ZShape:Shape {
    
    /*
        Orientation 0
     
          * | 0 |
        | 2 | 1 |
        | 3 |
     
        Orientation 90
     
        | 3 | *2 |
             | 1 | 0 |
     
        Orientation 180
     
          * | 0 |
        | 2 | 1 |
        | 3 |
     
        Orientation 270
     
        | 3 | *2 |
             | 1 | 0 |
    */
    
    /* Have to override these properties as set up in
     the Shape class
     */
    
    override var blockRowColumnPositions: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        
        return [
            
            Orientation.Zero: [(1,0), (1,1), (0,1), (0,2)],
            Orientation.Ninety: [(1,1), (0,1), (0,0), (-1,0)],
            Orientation.OneEighty: [(1,0), (1,1), (0,1), (0,2)],
            Orientation.TwoSeventy: [(1,1), (0,1), (0,0), (-1,0)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        
        return [
            
            Orientation.Zero: [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy:[blocks[FirstBlockIdx], blocks[SecondBlockIdx], blocks[FourthBlockIdx]]
        ]
    }
}
