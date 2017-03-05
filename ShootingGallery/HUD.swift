//
//  HUD.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/5/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit


class HUD{
    var bulletNodes: [SKSpriteNode] = []
    let killCountText = SKLabelNode(text: "00000")
    
    var scoreIconTexture: SKTexture?
    var bulletNodeTexture: SKTexture?
    
    init(newBulletTexture: SKTexture, newScoreTexture: SKTexture){
        scoreIconTexture = newScoreTexture
        bulletNodeTexture = newBulletTexture
    }
   
    
    func createHUDNodes(screenSize: CGSize) -> SKNode{
        
        let newHUDNode = SKNode()
        
        let scoreIconTexture = self.scoreIconTexture ?? SKTexture(image: #imageLiteral(resourceName: "text_score"))
        
        let bulletTexture = self.bulletNodeTexture ?? SKTexture(image: #imageLiteral(resourceName: "icon_bullet_silver_long"))
            
        
        let scoreIconSize = scoreIconTexture.size()
        
        let scoreIcon = SKSpriteNode(texture: scoreIconTexture)
        
        //Configure the size and position of the Kill score icon (assume a scene anchore point of (0.5,0.5)
        let scoreIconYPos = screenSize.height/2-23
        let scoreIconXPos = -screenSize.width/2 + 20
        scoreIcon.position = CGPoint(x: scoreIconXPos, y: scoreIconYPos)
        
        //Configure the killCountText display
        killCountText.fontName = "IowanOldStyle-Bold"
        killCountText.position = CGPoint(x: scoreIconYPos + scoreIconSize.width + 10, y: scoreIconYPos)
        
        killCountText.verticalAlignmentMode = .center
        killCountText.horizontalAlignmentMode = .left
        
        newHUDNode.addChild(killCountText)
        newHUDNode.addChild(scoreIcon)
        
        //Create the bullets for the player's ammunition
        for index in 0...4{
            let bulletSize = bulletTexture.size()
            
            let newBulletNode = SKSpriteNode(texture: bulletTexture)
            
            let yPos = scoreIconYPos - scoreIconSize.height - 10
            let xPos = scoreIconXPos + CGFloat(index)*(bulletSize.width + 5.0)
            newBulletNode.position = CGPoint(x: xPos, y: yPos)
            bulletNodes.append(newBulletNode)
            newHUDNode.addChild(newBulletNode)
        }
        
        return newHUDNode
        
    }
    
        func setKillCountDisplay(newKillCount: Int){
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 5
            
            if let killCount = formatter.string(from: NSNumber(value: newKillCount)){
                killCountText.text = killCount
            }
            
        }
        
        func setBulletDisplay(newBulletAmount: Int){
            let fadeAction = SKAction.fadeAlpha(to: 0.2, duration: 0.5)
            
            for index in 0...bulletNodes.count-1{
                if index < newBulletAmount{
                    bulletNodes[index].alpha = 1.0
                } else {
                    bulletNodes[index].run(fadeAction)
                }
            }
        }
}

    
