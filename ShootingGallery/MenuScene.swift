//
//  MenuScene.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class MenuScene: SKScene{
    
    
    let textureAtlas: SKTextureAtlas? = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)
    
    let startButton: SKSpriteNode = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        guard let textureAtlas = textureAtlas else { return }
        
        let bg: SKAudioNode = SKAudioNode(fileNamed: kGermanVirtue)
        bg.autoplayLooped = true
        self.addChild(bg)
        
        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        let backgroundTexture = SKTexture(image: #imageLiteral(resourceName: "uncolored_desert"))
        let backgroundImage = SKSpriteNode(texture: backgroundTexture)
        backgroundImage.size = CGSize(width: self.size.width, height: self.size.height)
        backgroundImage.position = CGPoint.zero
        backgroundImage.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundImage.zPosition = -5
        self.addChild(backgroundImage)
        
        //Build the label for the GameTitle
        let topTitleNode = SKLabelNode(fontNamed: kFuturaMedium)
        topTitleNode.text = "Stealthy Sniper"
        topTitleNode.zPosition = 2
        topTitleNode.position = CGPoint(x: 0.0, y: 100)
        topTitleNode.fontSize = 60
        self.addChild(topTitleNode)
        
        let bottomTitleNode = SKLabelNode(fontNamed: kFuturaMedium)
        bottomTitleNode.text = "against the Alien Invasion"
        bottomTitleNode.position = CGPoint(x: 0.0, y: 50)
        bottomTitleNode.zPosition = 2
        bottomTitleNode.fontSize = 60
        self.addChild(bottomTitleNode)
        
        //Build the start node
        startButton.texture = textureAtlas.textureNamed("yellow_button09")
        startButton.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        startButton.size = CGSize(width: 295, height: 76)
        startButton.name = "StartButton"
        startButton.position = CGPoint(x: 0, y: -80)
        startButton.zPosition = 2
        self.addChild(startButton)
        
        
        //Add some alien enemies
        let wingmanTexture = SKTexture(image: #imageLiteral(resourceName: "wingMan1"))
        let wingmanNode = SKSpriteNode(texture: wingmanTexture)
        wingmanNode.xScale *= 1.2
        wingmanNode.yScale *= 1.2
        wingmanNode.position = CGPoint(x: -150, y: -100)
        wingmanNode.zPosition = 1
        wingmanNode.zRotation = -45.0
        self.addChild(wingmanNode)
        
        //Build label text for Start Button
        let startButtonText = SKLabelNode(fontNamed: kFuturaCondensedExtraBold)
        startButtonText.text = "Start Game"
        startButtonText.verticalAlignmentMode = .center
        startButtonText.position = CGPoint(x: 0, y: 2)
        startButtonText.fontSize = 40
        startButtonText.name = "StartButton"
        startButtonText.zPosition = 3
        startButton.addChild(startButtonText)
        
        let pulseAnimation = SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.25),
            SKAction.fadeAlpha(to: 0.8, duration: 0.25)
            ]))
        
        startButton.run(pulseAnimation, withKey: "startPulseAnimation")
        
    
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches{
            let touchLocation = t.location(in: self)
            let nodeTouched = nodes(at: touchLocation)[0]
            
            if nodeTouched.name == "StartButton"{
                self.view?.presentScene(GameScene(size: self.size))
            
            }
        }
    }

}

