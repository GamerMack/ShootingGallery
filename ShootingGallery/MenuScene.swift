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
    
    //Texture Atlas for MenuScene
    let textureAtlas: SKTextureAtlas? = TextureAtlasManager.sharedInstance.getTextureAtlasOfType(textureAtlasType: .UI)
    
    //Menu Button
    let startButton: SKSpriteNode = SKSpriteNode()
    var hardButton = SKSpriteNode()
    var mediumButton = SKSpriteNode()
    var easyButton = SKSpriteNode()
    
    //User Options Manager
    let userOptionsManager = UserOptionsManager.sharedInstance
    
    override func didMove(to view: SKView) {
        
        guard let textureAtlas = textureAtlas else { return }
        
        
        configureBackgroundMusicForParentNode(parentNode: self, withMusicFile: kGermanVirtue)

        
       
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
        
    
        //Build difficulty options buttons
        
        hardButton = getButtonWith(textureNamed: "yellow_button06", andWithTextOf: "Hard", atPosition: CGPoint(x: 0, y: 100))
        mediumButton = getButtonWith(textureNamed: "yellow_button06", andWithTextOf: "Medium", atPosition: CGPoint(x: 0, y: 10))
        easyButton = getButtonWith(textureNamed: "yellow_button06", andWithTextOf: "Easy", atPosition: CGPoint(x: 0, y: -75))
        
        self.addChild(hardButton)
        self.addChild(mediumButton)
        self.addChild(easyButton)
        
        
    }
    
    func getButtonWith(textureNamed textureName: String, andWithTextOf buttonText: String, atPosition position: CGPoint, andWithSizeOf size: CGSize = CGSize(width: 295, height: 75)) ->SKSpriteNode {
        
        guard let textureAtlas = self.textureAtlas else { return SKSpriteNode() }
        
        var button = SKSpriteNode()
        
        let buttonTexture = textureAtlas.textureNamed(textureName)
        button = SKSpriteNode(texture: buttonTexture)
        button.anchorPoint = CGPoint.zero
        button.size = size
        button.name = buttonText
        button.position = position
        button.zPosition = -20
        
        let buttonTextLabel = SKLabelNode(fontNamed: kFuturaCondensedMedium)
        buttonTextLabel.text = buttonText
        buttonTextLabel.verticalAlignmentMode = .center
        buttonTextLabel.position = CGPoint(x: 100, y: 40)
        buttonTextLabel.fontSize = 40
        buttonTextLabel.fontColor = SKColor.blue
        buttonTextLabel.name = buttonText
        buttonTextLabel.zPosition = 3
        
        button.addChild(buttonTextLabel)
        
        return button
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for t in touches{
            let touchLocation = t.location(in: self)
            let nodeTouched = nodes(at: touchLocation)[0]
            
            if nodeTouched.name == "StartButton"{
                startButton.removeAllActions()
                startButton.run(SKAction.run({
                    self.startButton.zPosition = -10
                }))
                startButton.run(SKAction.wait(forDuration: 5.0))
                
                hardButton.zPosition = 2
                mediumButton.zPosition = 2
                easyButton.zPosition = 2
                
            
            }
            
            if nodeTouched.name == "Hard"{
                userOptionsManager.setDifficultyLevel(userSelection: "Hard")
                self.view?.presentScene(GameScene(size: self.size))

            }
            
            
            if nodeTouched.name == "Medium"{
                userOptionsManager.setDifficultyLevel(userSelection: "Medium")
                self.view?.presentScene(GameScene(size: self.size))
            }
            
            if nodeTouched.name == "Easy"{
                userOptionsManager.setDifficultyLevel(userSelection: "Easy")
                self.view?.presentScene(GameScene(size: self.size))
                
            }
        }

}

}
