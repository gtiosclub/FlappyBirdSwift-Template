//
//  GamePlayScene.swift
//  FlappySwift
//
//  Created by Brian Wang on 8/21/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class GamePlayScene : CCNode, CCPhysicsCollisionDelegate {
    var scrollSpeed: CGFloat = 100 //How fast the screen moves
    
    weak var hero: Character? //Later initialized in MainScene.swift
    
    weak var _gamePhysicsNode: CCPhysicsNode! //Linked with Spritebuilder
    weak var _ground1: CCSprite! //Linked with Spritebuilder
    weak var _ground2: CCSprite! //Linked with Spritebuilder
    
    var grounds: [CCSprite] = []  // initializes an empty array
    var obstacles: [CCNode] = [] //initializes an empty array
    var sinceTouch: CCTime = 0
    var isGameOver = false
    
    func didLoadFromCCB() {
        //add to array of ground objects
        grounds.append(_ground1)
        grounds.append(_ground2)
    }
    
    override func update(delta: CCTime) {
        if (!isGameOver) {
            hero?.position = ccp(hero!.position.x + scrollSpeed * CGFloat(delta), hero!.position.y)
            _gamePhysicsNode.position = ccp(_gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), _gamePhysicsNode.position.y)
            
            // clamp physics node and hero position to the next nearest pixel value to avoid black line artifacts
            let scale = CCDirector.sharedDirector().contentScaleFactor
            hero?.position = ccp(round(hero!.position.x * scale) / scale, round(hero!.position.y * scale) / scale)
            _gamePhysicsNode.position = ccp(round(_gamePhysicsNode.position.x * scale) / scale, round(_gamePhysicsNode.position.y * scale) / scale)
            
            // clamp angular velocity
            sinceTouch += delta
            // rotate downwards if enough time passed since last touch
            if (sinceTouch > 0.55) {
                let impulse = -18000.0 * delta
                hero?.physicsBody.applyAngularImpulse(CGFloat(impulse))
            }
            
            // clamp velocity
            if (hero != nil) {
                let velocityY = clampf(Float(hero!.physicsBody.velocity.y), -Float(CGFloat.max), 200)
                hero?.physicsBody.velocity = ccp(0, CGFloat(velocityY))
            }
            
            // clamp angular velocity
            hero?.rotation = clampf(hero!.rotation, -30, 90)
            if (hero?.physicsBody.allowsRotation != nil) {
                let angularVelocity = clampf(Float(hero!.physicsBody.angularVelocity), -2, 1)
                hero!.physicsBody.angularVelocity = CGFloat(angularVelocity)
            }
            // loop the ground whenever a ground image was moved entirely outside the screen
            for ground in grounds {
                // get the world position of the ground
                let groundWorldPosition = _gamePhysicsNode.convertToWorldSpace(ground.position)
                // get the screen position of the ground
                let groundScreenPosition = convertToNodeSpace(groundWorldPosition)
                // if the left corner is one complete width off the screen, move it to the right
                if groundScreenPosition.x <= (-ground.contentSize.width) {
                    ground.position = ccp(ground.position.x + ground.contentSize.width * 2, ground.position.y)
                }
            }
        }
    
    }
    
}

