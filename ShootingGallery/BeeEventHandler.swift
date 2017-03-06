//
//  BeeEventHandler.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//


//TODO: When user taps a worker bee, only the worker bee should be destroyed; if the user taps on the queen bee, then all the bees should be destroyed

import Foundation
import SpriteKit


class BeeEventHandler{
    
    static let animationsManager = AnimationsManager.sharedInstance
    
    
    static private func createExplosionForBee(bee: SKSpriteNode, sceneNode: SKNode){
        /** OPTIONAL CODE FOR ADDING A PLACEHOLDER NODE TO EXECUTE THE EXPLOSION ANIMATION
         let explodingNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
         
         explodingNode.position = CGPoint.zero
         self.addChild(explodingNode)
         **/
        
        
        let explosionAnimationWithSound = BeeEventHandler.animationsManager.getAnimationWithNameOf(animationName: "explosionAnimationWithSound")
        
        if let isWorkerBee = bee.userData?.value(forKey: "isWorkerBee") as? Bool{
            if(isWorkerBee){
                bee.move(toParent: sceneNode)
                bee.run(explosionAnimationWithSound, withKey: "delayedExplosion")
                return
            }
        }
        
        bee.run(explosionAnimationWithSound, withKey: "delayedExplosion")
        
        
        for child in bee.children{
            if let child = child as? SKSpriteNode{
                createExplosionForBee(bee: child, sceneNode: sceneNode)
            }
        }
        
    }
    
    static func beeRespondsToHitAt(bee: SKSpriteNode?, touchLocation: CGPoint, sceneNode: SKNode){
        if let bee = bee{
            if bee.contains(touchLocation){
                BeeEventHandler.createExplosionForBee(bee: bee, sceneNode: sceneNode)
                
                
                bee.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                /**
                 numberOfKills += 1
                 print("Updated number of kills is: \(numberOfKills)")
                 **/
            }
            
            
        }
        
        
    }
    
    
}
