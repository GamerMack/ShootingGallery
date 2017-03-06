//
//  TextureAtlasManager.swift
//  ShootingGallery
//
//  Created by Aleksander Makedonski on 3/6/17.
//  Copyright © 2017 Changzhou Panda. All rights reserved.
//

import Foundation
import SpriteKit


class TextureAtlasManager{
    
    static let sharedInstance = TextureAtlasManager()
    
    private var backgroundsTextureAtlas: SKTextureAtlas?
    private var HUDTextureAtlas: SKTextureAtlas?
    private var flymanTextureAtlas: SKTextureAtlas?
    private var crosshairTextureAtlas: SKTextureAtlas?
    private var enemyCharactersTextureAtlas: SKTextureAtlas?
    private var explosionTextureAtlas: SKTextureAtlas?
    private var userInterfaceTextureAtlas: SKTextureAtlas?
    
    
    func getTextureAtlasOfType(textureAtlasType: TextureAtlasType) -> SKTextureAtlas?{
        switch(textureAtlasType){
        case .Background:
            return backgroundsTextureAtlas
        case .Crosshair:
            return crosshairTextureAtlas
        case .HUD:
            return HUDTextureAtlas
        case .UI:
            return userInterfaceTextureAtlas
        case .Enemies:
            return enemyCharactersTextureAtlas
        case .Explosion:
            return explosionTextureAtlas
        case .Flyman:
            return flymanTextureAtlas
        }
    }
    
    enum TextureAtlasType{
        case Background
        case HUD
        case UI
        case Enemies
        case Explosion
        case Crosshair
        case Flyman
    }
    
    
    private init(){
        loadTextures()
    }
    
    private func loadTextures(){
        //Texture atlas for background layouts
        backgroundsTextureAtlas = SKTextureAtlas(named: "Backgrounds")
        
        //Texture atlas for HUD display UI elements
        HUDTextureAtlas = SKTextureAtlas(named: "HUD")
        
        //Texture atlas for enemy characters
        enemyCharactersTextureAtlas = SKTextureAtlas(named: "EnemyCharacters")
        
        ///Texture atlas for user interface
        userInterfaceTextureAtlas = SKTextureAtlas(named: "UI.atlas")
        
        //Texture atlas for explosion animation images
        explosionTextureAtlas = SKTextureAtlas(named: "RegularExplosion.atlas")
        
        //Texture atlas for Flyman (i.e. an enemy character)
        flymanTextureAtlas = SKTextureAtlas(named: "Flyman.atlas")
        
        
    }
}
