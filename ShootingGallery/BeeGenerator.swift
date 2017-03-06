//
//  Bee.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//ERROR HAS OCCURRED IN THIS CODE
//THIS CLASS IS DEPRECATED AND REPLACED WITH BEECREATOR

import Foundation
import SpriteKit


class BeeGenerator{
    
    static let animationsManager = AnimationsManager.sharedInstance
    
    static let textureAtlas = SKTextureAtlas(named: "EnemyCharacters")
    
    static func generateBeeSwarm() -> SKSpriteNode{
        
        let queenBee = SKSpriteNode(texture: textureAtlas.textureNamed("bee"))
        queenBee.userData?.setValue(true, forKey: "isQueenBee")
        queenBee.userData?.setValue(false, forKey: "isWorkerBee")
        
        configureFlappingAnimationFor(bee: queenBee)
        //addWorkerBeesTo(queenBee: queenBee,numberOfWorkerBees: 6)
        
        
        let pathRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let path1 = CGPath(ellipseIn: pathRect, transform: nil)
        let pathAction = SKAction.follow(path1, asOffset: false, orientToPath: false, speed: 50)
        let pathAnimation = SKAction.repeatForever(pathAction)
        queenBee.run(pathAnimation)
        
        queenBee.position = CGPoint.zero
        queenBee.zPosition = 5
        
        return queenBee
    }
    

    
    static private func addWorkerBeesTo(queenBee: SKSpriteNode, numberOfWorkerBees: Int){
        
        for index in 1...numberOfWorkerBees{
            let workerBee = SKSpriteNode(texture: textureAtlas.textureNamed("bee"))
            workerBee.userData = [
                "isWorkerBee": true,
                "isQueenBee":false
            ]
            workerBee.xScale *= 2.2
            workerBee.yScale *= 2.2
    
            configureFlappingAnimationFor(bee: workerBee)
            configureMovementAnimationsFor(bee: workerBee)
            queenBee.addChild(workerBee)
            
           
            
            let randomXPos = Double(arc4random_uniform(100))
            let randomYPos = Double(arc4random_uniform(100))
            
            let adjustedRandomXPos = index % 2 == 0 ? randomXPos: -randomXPos
            let adjustedRandomYPos = index % 2 == 0 ? randomYPos: -randomYPos

            
            workerBee.position = CGPoint(x: adjustedRandomXPos, y: adjustedRandomYPos)
            workerBee.zPosition = 5
        }
    }
    
    static private func configureMovementAnimationsFor(bee: SKSpriteNode){
     
        
        let randomDeltaX = -100.0 + Double(arc4random_uniform(200))
        let randomDeltaY = -100.0 + Double(arc4random_uniform(200))
        
        let randomMoveVector1 = CGVector(dx: randomDeltaX, dy: 0)
        let randomMoveVector2 = CGVector(dx: 0, dy: randomDeltaY)
        let randomMoveVector3 = CGVector(dx: -randomDeltaX, dy: 0)
        let randomMoveVector4 = CGVector(dx: 0, dy: -randomDeltaY)

        let moveAction1 = SKAction.move(by: randomMoveVector1, duration: 0.20)
    
        
        let moveAction2 = SKAction.move(by: randomMoveVector2, duration: 0.20)
        let moveAction3 = SKAction.move(by: randomMoveVector3, duration: 0.20)
        let moveActoin4 = SKAction.move(by: randomMoveVector4, duration: 0.20)
        
        let moveSequence = SKAction.sequence([
            moveAction1,
            moveAction2,
            moveAction3,
            moveActoin4
            ])
        
        let movingAnimation = SKAction.repeatForever(moveSequence)
        
        bee.run(movingAnimation)
    }
    
    static private func configureFlappingAnimationFor(bee: SKSpriteNode){
        let flappingAction = SKAction.animate(with: [
            textureAtlas.textureNamed("bee"),
            textureAtlas.textureNamed("bee-fly")
            ], timePerFrame: 0.25)
        
        let flappingAnimation = SKAction.repeatForever(flappingAction)
        bee.run(flappingAnimation)


    }
}
 
