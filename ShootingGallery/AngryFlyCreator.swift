//
//  AngryFlyCreator.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

//  BeeCreator.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit

class AngryFlyCreator{
    
    static let animationsManager = AnimationsManager.sharedInstance
    
    static let textureAtlas = SKTextureAtlas(named: "EnemyCharacters")
    
    static func generateAngryFly() -> SKSpriteNode{
        
        let madFly = SKSpriteNode(texture: textureAtlas.textureNamed("madfly"))
        
        madFly.userData = [
            "health" : 2,
            "normalXSpeed": 5,
            "normalYSpeed": 5,
            "damagedXSpeed": 20,
            "damagedYSpeed": 20,
            "isMoving": false,
            "thresholdVelocityXNormal": 20,
            "thresholdVelocityYNormal": 20,
            "thresholdVelocityXDamaged":40,
            "thresholdVelocityYDamaged":40
        ]
        
        configureFlappingAnimationFor(fly: madFly)
        configurePhysicsProperties(fly: madFly)
        
        madFly.position = CGPoint.zero
        madFly.zPosition = 5
        
        return madFly
    }
    
    
    
    
    static private func configurePhysicsProperties(fly: SKSpriteNode){
        
        fly.physicsBody = SKPhysicsBody(circleOfRadius: fly.size.width/2)
        fly.physicsBody?.affectedByGravity = false
        fly.physicsBody?.allowsRotation = false
        fly.physicsBody?.isDynamic = true
        
      
        
        
       
    }
    
    static private func configureFlappingAnimationFor(fly: SKSpriteNode){
        let flappingAction = SKAction.animate(with: [
            textureAtlas.textureNamed("madfly"),
            textureAtlas.textureNamed("madfly-fly")
            ], timePerFrame: 0.25)
        
        let flappingAnimation = SKAction.repeatForever(flappingAction)
        fly.run(flappingAnimation)
        
        
    }
    
}
