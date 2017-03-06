//
//  GameViewController.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/5/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    let kDebug = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuScene = MenuScene()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
                // Set the scale mode to scale to fit the window
                menuScene.scaleMode = .aspectFill
                menuScene.size = view.bounds.size
                // Present the scene
                view.presentScene(menuScene)
        
            if(kDebug){
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
         
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
