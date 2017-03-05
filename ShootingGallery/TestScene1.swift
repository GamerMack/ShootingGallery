//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/5/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import SpriteKit
import GameplayKit

enum BackgroundType{
    case TargetRange
    case Desert
    case Castle
}

class GameScene: SKScene {
    //Change Gun Label
    var crossHairToggleControl: SKLabelNode?
    
    
    //Player Stats
    var numberOfBullets: Int = 5
    var numberOfKills: Int = 0
    
    //HUD instance
    let hud = HUD(newBulletTexture: SKTexture(image: #imageLiteral(resourceName: "icon_bullet_silver_long")), newScoreTexture: SKTexture(image: #imageLiteral(resourceName: "text_score")))
    
    //Background and CrossHair(Player)
    var background: SKSpriteNode?
    
    var currentCrossHairIndex: Int = 0
    var crossHairTextures: [SKTexture] = [
        SKTexture(image: #imageLiteral(resourceName: "crosshair_red_small")),
        SKTexture(image: #imageLiteral(resourceName: "crosshair_red_large")),
        SKTexture(image: #imageLiteral(resourceName: "crosshair_outline_small")),
        SKTexture(image: #imageLiteral(resourceName: "crosshair_outline_large"))
    ]
    
    var mainCrossHair: SKSpriteNode?/**PROPERTY OBSERVER FOR POSITION OF mainCrossHair{
        didSet{
            let thresholdDistanceToFlyman: Double = 30.0;
            
            if let flyman = self.flyman, let mainCrossHair = mainCrossHair{
                let xDistance = flyman.position.x - mainCrossHair.position.x
                let yDistance = flyman.position.y - mainCrossHair.position.y
                
                let xDistanceSquared = Double(xDistance*xDistance)
                let yDistanceSquared = Double(yDistance*yDistance)
                
                let distanceToFlyman = sqrt(xDistanceSquared+yDistanceSquared)
                
                if(distanceToFlyman < thresholdDistanceToFlyman){
                    flyman.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 50))
                }
            }
            
        }
    }
 
 **/
    
    //Duck Targets
    var duck1: SKSpriteNode?
    var duck2: SKSpriteNode?
    var duck3: SKSpriteNode?
    
    //Wingman Properties
    var wingman: SKSpriteNode?
    var wingmanIsMoving: Bool = false
    var wingmanIsHit: Bool = false
    
    //Flyman properties
    var flyman: SKSpriteNode?
    var flymanOriginalTextureIsRestored = true
    var flymanIsLevitating: Bool{
        get{
            if let flyman = self.flyman, let flymanVelocityX = flyman.physicsBody?.velocity.dx, let flymanVelocityY = flyman.physicsBody?.velocity.dy{
               
                if(flymanVelocityX > 0 || flymanVelocityY > 0){
                    return true;
                }
            }
            
            return false;
        }
    }
    
    
    override func didMove(to view: SKView) {
        //Background Configuration (TEMPORARY)
        configureBackgroundOf(type: .Castle)
      
        //Crosshair Configuration
        configureMainCrossHair()
        
        //Configure Flyman
        configureFlymanFor(parentNode: self)
        
        
        //Configure CrossHairToggle Control
        configureCrossHairToggle(parentNode: self)
        
        //Configure HUD display
        configureHUDFor(parentNode: self)
       
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let currentCrossHair = mainCrossHair{
            currentCrossHair.position = pos
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let currentCrossHair = mainCrossHair{
            currentCrossHair.position = pos
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
           }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //If the player runs out of bullets, he cannot fire anymore
        if(numberOfBullets == 0) {
            print("No more bullets")
            return
        }
        
            for touch in touches {
                
                let touchPoint = touch.location(in: self)
                
                if let toggle = self.crossHairToggleControl{
                    if toggle.contains(touchPoint){
                        print("You changed guns")
                        toggleMainCrosshair()
                        return
                    }
                }
                
                if let crossHair = mainCrossHair, crossHair.contains(touchPoint){
                    wingmanRespondsToHitAt(touchLocation: touchPoint)
                    flymanRespondsToHitAt(touchLoaction: touchPoint)

                }
               
                self.numberOfBullets -= 1
                print("Updated number of bullets is: \(self.numberOfBullets)")

               
            }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        updateWingman()
        updateFlyman()
        
    }
    
    
    override func didSimulatePhysics() {
        
        flymanRespondsToCrossHairAtMinDistanceOf(distanceFromCrossHair: 100.0)
        
    }
    
    private func showDebuggingInfo(){
        let sceneSize = self.size
        print("The width of the current scene is: \(sceneSize.width)")
        print("The height of the current scene is: \(sceneSize.height)")
        
        let sceneAnchorPoint = self.anchorPoint
        print("The x value for the scene's anchor point is: \(sceneAnchorPoint.x)")
        print("The y value for the scene's anchor point is: \(sceneAnchorPoint.y)")
        
        let cgZero = CGPoint.zero
        print("The x value for CGPointZero is: \(cgZero.x)")
        print("The y value for CGPointZero is: \(cgZero.y)")
        
        let bgAnchorPoint = background!.anchorPoint
        print("The x value of the background's anchor point is: \(bgAnchorPoint.x)")
        print("The y vlaue of the background's anchor point is: \(bgAnchorPoint.y)")
        
    }
    
    
    //MARK: - Private Convenience Functinos
    private func configureBackgroundOf(type: BackgroundType){
        switch(type){
        case .TargetRange:
            configureBackground1()
            break
        case .Desert:
            configureBackground2()
            break
        case .Castle:
            configureBackground3()
            break
        default:
            break
        }
    }
    
    private func configureBackground1(){
        let backgroundScene = SKScene(fileNamed: "Background1")!
        background = backgroundScene.childNode(withName: "Root") as? SKSpriteNode
        background!.move(toParent: self)
        background!.position = CGPoint.zero
        background!.xScale *= 1.2
        background!.color = SKColor.cyan
        
        
    }
    
    private func configureBackground2(){
        let backgroundScene = SKScene(fileNamed: "Desert")!
        background = backgroundScene.childNode(withName: "Root") as? SKSpriteNode
        background!.move(toParent: self)
        background!.xScale *= 0.25
        background?.yScale *= 0.25
        background!.position = CGPoint.zero
        
        
    }
    
    private func configureBackground3(){
        let backgroundScene = SKScene(fileNamed: "Castle")!
        background = backgroundScene.childNode(withName: "Root") as? SKSpriteNode
        background!.move(toParent: self)
        background!.position = CGPoint.zero
        
        
    }
    
    
    private func updateWingman(){
        
        if(self.wingmanIsHit) { return }
      
        let randomX = Int(arc4random_uniform(375))
        let randomY = Int(arc4random_uniform(375))
        
        let coinTossX = Int(arc4random_uniform(2))
        let coinTossY = Int(arc4random_uniform(2))
        
        let adjustedRandomX = coinTossX < 1 ? randomX: -randomX
        let adjustedRandomY = coinTossY < 1 ? randomY: -randomY
        
        let randomPoint = CGPoint(x: adjustedRandomX, y: adjustedRandomY)
        
        let movingAnimation = SKAction.sequence([
            SKAction.run({
                if(self.wingmanIsMoving ){ return }
                else{ self.wingmanIsMoving = true }
            }),
            SKAction.move(to: randomPoint, duration: 1.0),
            SKAction.run({
                let wingmanFinalXPos = self.wingman?.position.x
                let wingmanFinalYPos = self.wingman?.position.y
                print("Wingman's final x Location is x: \(wingmanFinalXPos), y: \(wingmanFinalYPos)")
            }),
            SKAction.wait(forDuration: 2.0),
            SKAction.run({
                self.wingmanIsMoving = false
            })
            ])
        
        if let wingman = wingman{
            wingman.run(movingAnimation)
        }

    }
    
    private func configureMainCrossHair(){
        let crossHairTexture = crossHairTextures[currentCrossHairIndex]
        mainCrossHair = SKSpriteNode(texture: crossHairTexture)
        mainCrossHair!.position = CGPoint.zero
        mainCrossHair?.zPosition = 10
        self.addChild(mainCrossHair!)
    }
    
    private func configureDucks(){
        duck1 = background!.childNode(withName: "duck_target_brown") as? SKSpriteNode
        duck2 = background!.childNode(withName: "duck_target_yellow") as? SKSpriteNode
        duck3 = background!.childNode(withName: "duck_target_white") as? SKSpriteNode
    }
    
    private func configureWingmanFor(parentNode: SKNode){
        let wingmanBaseTexture = SKTexture(image: #imageLiteral(resourceName: "wingMan1"))
        wingman = SKSpriteNode(texture: wingmanBaseTexture)
        
        let flapDownAction = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "wingMan1")),
            SKTexture(image: #imageLiteral(resourceName: "wingMan2")),
            SKTexture(image: #imageLiteral(resourceName: "wingMan3")),
            SKTexture(image: #imageLiteral(resourceName: "wingMan4")),
            SKTexture(image: #imageLiteral(resourceName: "wingMan5"))
            ], timePerFrame: 0.10)
        
        let flapUpAction = SKAction.reversed(flapDownAction)()
        let flappingSequence = SKAction.sequence([
            flapDownAction,
            flapUpAction
            ])
        
        let flappingAnimation = SKAction.repeatForever(flappingSequence)
        
        
        if let wingman = wingman{
            wingman.position = CGPoint.zero
            wingman.run(flappingAnimation)
            parentNode.addChild(wingman)
        }

    }
    
    
    private func configureFlymanFor(parentNode: SKNode){
        let flymanBasicTexture = SKTexture(image: #imageLiteral(resourceName: "flyMan_stand"))
        let flymanSize = flymanBasicTexture.size()
        flyman = SKSpriteNode(texture: flymanBasicTexture)
        flyman?.physicsBody = SKPhysicsBody(circleOfRadius: flymanSize.width/2)
        flyman?.physicsBody?.affectedByGravity = true
        flyman?.physicsBody?.isDynamic = true
        flyman?.physicsBody?.allowsRotation = false
        
        /*EDIT TO CONFIGURE A REPEAT-FOREVER DEFAULT ANIMATION STATE, OTHERWISE FLYMAN JUST STANDS IN PLACE
        let jumpAction = SKAction.animate(with: [
            SKTexture(image: #imageLiteral(resourceName: "flyMan_stand")),
            SKTexture(image: #imageLiteral(resourceName: "flyMan_jump")),
            ], timePerFrame: 0.10)
        
        */
        
        if let flyman = flyman{
            flyman.position = CGPoint(x: -self.size.width/3, y: 0.0)
            flyman.zPosition = 5
            parentNode.addChild(flyman)
        }
        
    }

    
    
    private func createExplosionFor(spriteNode: SKSpriteNode){
        /** OPTIONAL CODE FOR ADDING A PLACEHOLDER NODE TO EXECUTE THE EXPLOSION ANIMATION
        let explodingNode = SKSpriteNode(texture: nil, color: .clear, size: CGSize(width: 50, height: 50))
        
        explodingNode.position = CGPoint.zero
        self.addChild(explodingNode)
        **/
        
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
        

        
        spriteNode.run(explosionAnimation, withKey: "delayedExplosion")
        
    }
    
    private func wingmanRespondsToHitAt(touchLocation: CGPoint){
        if let wingman = wingman{
            
            if wingman.contains(touchLocation){
                wingman.removeAllActions()
                self.wingmanIsHit = true
                createExplosionFor(spriteNode: wingman)
                wingman.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                
                self.numberOfKills += 1
                print("Updated number of kills is: \(self.numberOfKills)")
            }
            
           
            self.wingmanIsHit = false
            self.wingmanIsMoving = false
        }
    }
    
    private func flymanRespondsToHitAt(touchLoaction: CGPoint){
        if let flyman = flyman{
            if flyman.contains(touchLoaction){
                createExplosionFor(spriteNode: flyman)
                flyman.run(SKAction.sequence([
                    SKAction.wait(forDuration: 2.0),
                    SKAction.removeFromParent()
                    ]))
                self.numberOfKills += 1
                print("Updated number of kills is: \(self.numberOfKills)")
            }
            
            
        }
    }
    
    private func flymanRespondsToCrossHairAtMinDistanceOf(distanceFromCrossHair: Double){
        
        if(flymanIsLevitating) { return }
        
        let thresholdDistanceToFlyman: Double = 100.0;
        
        if let flyman = self.flyman, let mainCrossHair = mainCrossHair{
            let xDistance = flyman.position.x - mainCrossHair.position.x
            let yDistance = flyman.position.y - mainCrossHair.position.y
            
            let xDistanceSquared = Double(xDistance*xDistance)
            let yDistanceSquared = Double(yDistance*yDistance)
            
            let distanceToFlyman = sqrt(xDistanceSquared+yDistanceSquared)
            
            if(distanceToFlyman < thresholdDistanceToFlyman){
                let impulseXToApply = flyman.position.x > 0 ? -50 : 50
                
                flyman.physicsBody?.applyImpulse(CGVector(dx: impulseXToApply, dy: 100))
                let textureChange = SKAction.setTexture(SKTexture(image: #imageLiteral(resourceName: "flyMan_jump")))
                flyman.run(textureChange)
                flymanOriginalTextureIsRestored = false
            }
        }
        
        if(flymanIsLevitating){
            print("Flyman is LEVITATING!")
        }

    }
    
    private func updateFlyman(){
        guard let flyman = self.flyman else { return }
        
        if(!flymanIsLevitating && !flymanOriginalTextureIsRestored){
            let restoreOriginalTextureAction = SKAction.setTexture(SKTexture(image: #imageLiteral(resourceName: "flyMan_still_stand")))
            flyman.run(restoreOriginalTextureAction)
            flymanOriginalTextureIsRestored = true
        }
    }
    
    private func configureHUDFor(parentNode: SKNode){
        var newHUDnode = hud.createHUDNodes(screenSize: self.size)
        newHUDnode.zPosition = 5
        parentNode.addChild(newHUDnode)
    }
    
    
    private func configureCrossHairToggle(parentNode: SKNode){
        crossHairToggleControl = SKLabelNode(text: "Change Gun")
        crossHairToggleControl?.horizontalAlignmentMode = .left
        crossHairToggleControl?.verticalAlignmentMode = .top
        /** TODO: Position of Node should be dependent on size of scene, not hardcoded**/
        //let xPos = (self.size.width/2)
        //let yPos = (-self.size.height/2)
        //crossHairToggleControl?.position = CGPoint(x: xPos, y: yPos)
        
        crossHairToggleControl?.position = CGPoint(x: 80, y: -120)
        crossHairToggleControl?.zPosition = 5
        crossHairToggleControl?.color = SKColor.blue
        crossHairToggleControl?.fontColor = SKColor.orange
        
        
        if let crossHairToggle = crossHairToggleControl{
            showDebuggingInfo()
            print("The crossHairToggle is at x: \(crossHairToggle.position.x), and y: \(crossHairToggle.position.y)")

            parentNode.addChild(crossHairToggle)

        }
    }
    
    private func toggleMainCrosshair(){
        if let mainCrossHair = mainCrossHair{
            if(currentCrossHairIndex < crossHairTextures.count-1){
                currentCrossHairIndex += 1
            } else {
                currentCrossHairIndex = 0
            }
            
            print("Crosshair index is now: \(currentCrossHairIndex)")
            let nextCrossHairTexture = crossHairTextures[currentCrossHairIndex]
            let changeTextureAction = SKAction.setTexture(nextCrossHairTexture)
            mainCrossHair.run(changeTextureAction)
        }
    }


    

}



