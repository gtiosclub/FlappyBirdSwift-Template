//
//  Obstacle.swift
//  FlappySwift
//
//  Created by Benjamin Reynolds on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

import Foundation

class Obstacle: CCNode {
    
    var _topPipe:CCNode!
    var _bottomPipe:CCNode!
    
    let minimumYPosition:CGFloat = 200
    let maximumYPosition:CGFloat = 380
    
    
    func didLoadFromCCB() {
        
        _topPipe.physicsBody.sensor = true
        _bottomPipe.physicsBody.sensor = true
    }
    
    func setupRandomPosition() {
        
        // calculate the end of the range of top pipe
        let random:CGFloat = (CGFloat(rand()) / CGFloat(RAND_MAX))
        let range:CGFloat = maximumYPosition - minimumYPosition
        self.position = CGPoint(x:self.position.x, y:minimumYPosition + (random * range))
    }

}