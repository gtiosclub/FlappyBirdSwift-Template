//
//  GamePlayScene.swift
//  FlappySwift
//
//  Created by Brian Wang on 8/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//
import Foundation

class GamePlayScene : CCNode, CCPhysicsCollisionDelegate {
    var scrollSpeed: CGFloat = 100
    
    weak var _gamePhysicsNode: CCPhysicsNode!
    
    weak var _hero: Character!
    weak var _ground1: CCSprite!
    weak var _ground2: CCSprite!
    weak var _obstaclesLayer: CCNode!
    weak var _restartButton: CCButton!
    weak var _scoreLabel: CCLabelTTF!
    
    var grounds: [CCSprite] = []  // initializes an empty array
    var obstacles: [CCNode] = []
    var sinceTouch: CCTime = 0
    var isGameOver = false
    
    func didLoadFromCCB() {
        _gamePhysicsNode.collisionDelegate = self
        _gamePhysicsNode.gravity = CGPoint(x:0, y:-850)
        
        grounds.append(_ground1)
        grounds.append(_ground2)
    }
    
    override func update(delta: CCTime) {
        _hero?.position = ccp(_hero.position.x + scrollSpeed * CGFloat(delta), _hero.position.y)
        _gamePhysicsNode.position = ccp(_gamePhysicsNode.position.x - scrollSpeed * CGFloat(delta), _gamePhysicsNode.position.y)
        
        // clamp physics node and _hero position to the next nearest pixel value to avoid black line artifacts
        let scale = CCDirector.sharedDirector().contentScaleFactor
        _hero?.position = ccp(round(_hero.position.x * scale) / scale, round(_hero.position.y * scale) / scale)
        _gamePhysicsNode.position = ccp(round(_gamePhysicsNode.position.x * scale) / scale, round(_gamePhysicsNode.position.y * scale) / scale)
        
        // clamp angular velocity
        sinceTouch += delta
        // rotate downwards if enough time passed since last touch
        if (sinceTouch > 0.55) {
            let impulse = -18000.0 * delta
            _hero.physicsBody.applyAngularImpulse(CGFloat(impulse))
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
        
        // clamp velocity
        let velocityY = clampf(Float(_hero.physicsBody.velocity.y), -Float(CGFloat.max), 200)
        _hero?.physicsBody.velocity = ccp(0, CGFloat(velocityY))
        
        // clamp angular velocity
        _hero?.rotation = clampf(_hero.rotation, -30, 90)
        if (_hero.physicsBody.allowsRotation) {
            let angularVelocity = clampf(Float(_hero.physicsBody.angularVelocity), -2, 1)
            _hero?.physicsBody.angularVelocity = CGFloat(angularVelocity)
        }
        
    }
    
    
    func restart() {
        var scene = CCBReader.loadAsScene("MainScene")
        CCDirector.sharedDirector().replaceScene(scene)
    }
    
    func gameOver() {
        if (isGameOver == false) {
            isGameOver = true
            _restartButton.visible = true
            scrollSpeed = 0
            _hero?.rotation = 90
            _hero?.physicsBody.allowsRotation = false
            
            // just in case
            _hero?.stopAllActions()
            
            var move = CCActionEaseBounceOut(action: CCActionMoveBy(duration: 0.2, position: ccp(0, 4)))
            var moveBack = CCActionEaseBounceOut(action: move.reverse())
            var shakeSequence = CCActionSequence(array: [move, moveBack])
            runAction(shakeSequence)
        }
    }
}

