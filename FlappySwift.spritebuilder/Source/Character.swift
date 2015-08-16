//
//  Character.swift
//  FlappySwift
//
//  Created by Benjamin Reynolds on 9/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

import Foundation

class Character: CCSprite {
    
    func didLoadFromCCB() {
        self.position = CGPoint(x:115, y:250)
    }
    
    func flap() {
        self.physicsBody.applyImpulse(ccp(0, 700))
        self.physicsBody.applyAngularImpulse(5000)
    }
}