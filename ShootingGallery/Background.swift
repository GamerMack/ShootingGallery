//
//  Background.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/5/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

func configureBackgroundMusicForParentNode(parentNode: SKNode, withMusicFile fileName: String){
    let bg: SKAudioNode = SKAudioNode(fileNamed: fileName)
    bg.autoplayLooped = true
    parentNode.addChild(bg)
}


        
