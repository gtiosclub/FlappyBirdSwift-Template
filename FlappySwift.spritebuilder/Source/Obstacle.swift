//
//  Obstacle.swift
//  FlappySwift
//
//  Created by Brian Wang on 8/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Obstacle: CCNode {
    
    var _topPipe:CCNode!
    var _bottomPipe:CCNode!
    
    let minimumYPosition:CGFloat = 200
    let maximumYPosition:CGFloat = 380
    
    func setupRandomPosition() {
        
        // calculate the end of the range of top pipe
        let random:CGFloat = (CGFloat(rand()) / CGFloat(RAND_MAX))
        let range:CGFloat = maximumYPosition - minimumYPosition
        self.position = CGPoint(x:self.position.x, y:minimumYPosition + (random * range))
    }
    
}