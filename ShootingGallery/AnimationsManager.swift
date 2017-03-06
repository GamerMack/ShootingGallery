//
//  AnimationsManager.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit

class AnimationsManager{
    
    static let sharedInstance = AnimationsManager()
    
   
    private var animationsDictionary = [String:SKAction]()
    
    
    func getAnimationWithNameOf(animationName: String) -> SKAction{
        
        if let requestedAction = animationsDictionary[animationName]{
            return requestedAction
        }
        
        return SKAction()
    }
    
    
    private init(){
        configureAnimationsDict()
    }
    
    
    private func configureAnimationsDict(){
        let explosionAnimation = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion00")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion01")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion02")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion03")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion04")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion05")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion06")),
            SKTexture(image: #imageLiteral(resourceName: "regularExplosion07"))
            ], timePerFrame: 0.30)
        
        
        let explosionAnimationWithSound = SKAction.group([
            SKAction.playSoundFileNamed("rumble3", waitForCompletion: false),
            explosionAnimation
            ])
    
        animationsDictionary["explosionAnimation"] = explosionAnimation
        animationsDictionary["explosionAnimationWithSound"] = explosionAnimationWithSound
        
    }
}
