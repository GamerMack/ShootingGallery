//
//  GameScene.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/5/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum BackgroundType{
    case TargetRange
    case Desert
    case Castle
}

class GameScene: SKScene {
    
    //Singletons
    let animationsManager = AnimationsManager.sharedInstance
    
    
    //Change Gun Label
    var crossHairToggleControl: SKNode?
    var gunToggleAtlas = SKTextureAtlas(named: "Toggles")
    
    //Player Stats
    var numberOfBullets: Int = 5
    var numberOfKills: Int = 0
    
    //HUD instance
    let hud = HUD()
    
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
    
   //Angry fly properties
    var angryFly: SKSpriteNode?
    
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
    
    //Bee Swarm properties
    var bee: SKSpriteNode?
    
    
    override func didMove(to view: SKView) {
        //Background Configuration (TEMPORARY)
        configureBackgroundOf(type: .Castle)
        
        
        /**If not loading physics bodies from the .sks file, create static edges around the scene to contain objects
         
        let pathRect = CGRect(x: -100, y: -100, width: 300, height: 200)
        let boundingPath = CGPath(rect: pathRect, transform: nil)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: boundingPath)
      **/
        
        //Crosshair Configuration
        configureMainCrossHair()
        
        //Configure Flyman
        configureFlymanFor(parentNode: self)
        
        //Configure BeeGroup
        //configureBeeSwarmFor(parentNode: self)
        
        //Configure AngryFly
        configureAngryFly(parentNode: self)
        
        //Configure CrossHairToggle Control
        configureCrossHairToggle(parentNode: self)
        
        //Configure HUD display
        configureHUDFor(parentNode: self)
        
        
        //Preload Sounds
        
        do {
            let sounds: [String] = [
            "laser1","laser2","laser3","laser4","laser5","laser6","laser7","laser8","laser9",
            "rumble2","rumble3"
            ]
            
            for sound in sounds{
                let path: String = Bundle.main.path(forResource: sound, ofType: "wav")!
                let url: URL = URL(fileURLWithPath: path)
                let player: AVAudioPlayer = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
            }
            
        } catch {
            //Error handling code
        }
        
        //Configure Background Music
        let bg: SKAudioNode = SKAudioNode(fileNamed: "Mishief Stroll.mp3")
        bg.autoplayLooped = true
        self.addChild(bg)
       
       
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
                
                self.run(SKAction.playSoundFileNamed("laser7", waitForCompletion: false))
                if let crossHair = mainCrossHair, crossHair.contains(touchPoint){
                    wingmanRespondsToHitAt(touchLocation: touchPoint)
                    flymanRespondsToHitAt(touchLocation: touchPoint)
                    angryFlyRespondsToHitAt(touchLocation: touchPoint)
                    BeeEventHandler.beeRespondsToHitAt(bee: bee, touchLocation: touchPoint, sceneNode: self)

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
        
        updateAngryFly()
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
        
        
        let explosionAnimationWithSound = animationsManager.getAnimationWithNameOf(animationName: "explosionAnimationWithSound")
        
        spriteNode.run(explosionAnimationWithSound, withKey: "delayedExplosion")
        
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
    
    
    
    
    
    private func flymanRespondsToHitAt(touchLocation: CGPoint){
        if let flyman = flyman{
            if flyman.contains(touchLocation){
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
        let newHUDnode = hud.generateHUD(screenSize: self.size)
        newHUDnode.zPosition = 5
        parentNode.addChild(newHUDnode)
    }
    
    
    private func configureCrossHairToggle(parentNode: SKNode){
        
        let toggleTexture = gunToggleAtlas.textureNamed("joystickUp")
        crossHairToggleControl = SKSpriteNode(texture: toggleTexture)
        
        if let crossHairToggle = crossHairToggleControl{
            crossHairToggle.position = CGPoint(x: 180, y: -150)
            crossHairToggle.zPosition = 5
        }
    
        /**
        crossHairToggleControl = SKLabelNode(text: "Change Gun")
        crossHairToggleControl?.horizontalAlignmentMode = .left
        crossHairToggleControl?.verticalAlignmentMode = .top **/
        
        /** TODO: Position of Node should be dependent on size of scene, not hardcoded**/
        /**
        let xPos = (self.size.width/2)
        let yPos = (-self.size.height/2)
        crossHairToggleControl?.position = CGPoint(x: xPos, y: yPos)
        **/
        
        /**
        crossHairToggleControl?.position = CGPoint(x: 80, y: -120)
        crossHairToggleControl?.zPosition = 5
        crossHairToggleControl?.color = SKColor.blue
        crossHairToggleControl?.fontColor = SKColor.orange
        **/
        
        if let crossHairToggle = crossHairToggleControl{
            showDebuggingInfo()
            print("The crossHairToggle is at x: \(crossHairToggle.position.x), and y: \(crossHairToggle.position.y)")

            parentNode.addChild(crossHairToggle)

        }
    }
    
    private func toggleMainCrosshair(){
        if let mainCrossHair = mainCrossHair, let crossHairToggle = crossHairToggleControl as? SKSpriteNode{
            if(currentCrossHairIndex < crossHairTextures.count-1){
                currentCrossHairIndex += 1
            } else {
                currentCrossHairIndex = 0
            }
            
            let toggleAnimation = SKAction.animate(with: [
                gunToggleAtlas.textureNamed("joystickUp"),
                gunToggleAtlas.textureNamed("joystickLeft"),
                gunToggleAtlas.textureNamed("joystickUp"),
                ], timePerFrame: 0.20)
            
            crossHairToggle.run(SKAction.sequence([
                toggleAnimation,
                SKAction.run({
                    print("Crosshair index is now: \(self.currentCrossHairIndex)")
                    let nextCrossHairTexture = self.crossHairTextures[self.currentCrossHairIndex]
                    let changeTextureAction = SKAction.setTexture(nextCrossHairTexture)
                    self.mainCrossHair!.run(changeTextureAction)
                })
                ]))
            
         
        }
    }

    private func configureBeeSwarmFor(parentNode: SKNode){
        bee = BeeCreator.generateBeeSwarm()
        parentNode.addChild(bee!)
    }

    private func configureAngryFly(parentNode: SKNode){
        angryFly = AngryFlyCreator.generateAngryFly()
        parentNode.addChild(angryFly!)
    }
    
    
    private func updateAngryFly(){
        
        guard let angryFly = angryFly else { return }
        
        let normalXSpeed = angryFly.userData?.value(forKey: "normalXSpeed") as! Int
        let normalYSpeed = angryFly.userData?.value(forKey: "normalYSpeed") as! Int
        let yImpulseSpeed = CGVector(dx: 0, dy: normalYSpeed)
        let xImpulseSpeed = CGVector(dx: normalXSpeed, dy: 0)
        
        let thresholdVelocityX = angryFly.userData?.value(forKey: "thresholdVelocityXNormal") as! Int
        let thresholdVelocityY = angryFly.userData?.value(forKey: "thresholdVelocityYNormal") as! Int
        
        if(Int((angryFly.physicsBody?.velocity.dx)!) < thresholdVelocityX){
            angryFly.physicsBody?.applyImpulse(xImpulseSpeed)

        }
        
        if(Int((angryFly.physicsBody?.velocity.dy)!) < thresholdVelocityY){
            angryFly.physicsBody?.applyImpulse(yImpulseSpeed)
        }
    }
    
    
    private func angryFlyRespondsToHitAt(touchLocation: CGPoint){
        if let angryFly = angryFly{
            if angryFly.contains(touchLocation){
                
                let currentHealth = angryFly.userData?.value(forKey: "health") as! Int
                
                switch(currentHealth){
                case 2:
                    angryFly.run(SKAction.fadeAlpha(to: 0.7, duration: 0.25))
                    angryFly.userData?.setValue(1, forKey: "health")
                    return
                case 1:
                    angryFly.run(SKAction.fadeAlpha(to: 0.2, duration: 0.25))
                    angryFly.userData?.setValue(0, forKey: "health")
                    return
                case 0:
                    createExplosionFor(spriteNode: angryFly)
                    angryFly.run(SKAction.sequence([
                        SKAction.wait(forDuration: 2.0),
                        SKAction.removeFromParent()
                        ]))
                    self.numberOfKills += 1
                    print("Updated number of kills is: \(self.numberOfKills)")
                    
                    break
                default:
                    break
                }
                
            }
            
            
        }
    }

    

}



