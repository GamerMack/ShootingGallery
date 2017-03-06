//
//  UserOptionsManager.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit

class UserOptionsManager{
    
    static let sharedInstance = UserOptionsManager()
    
    private var userChoiceDict = [String:String]()
    
    
     func getDifficultyLevel() -> String{
        return userChoiceDict["DifficultyLevel"]!
    }
    
     func setDifficultyLevel(userSelection: String){
        userChoiceDict["DifficultyLevel"] = userSelection
    }
    
    
    private init(){
        
    }
    
    
    
}
