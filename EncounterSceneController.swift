//
//  EncounterSceneController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 15/4/2023.
//

import SpriteKit

class EncounterScene: SKScene {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
    
    let TVScreen = SKSpriteNode(imageNamed: "CRT Shape")
    let croppedFrame = SKCropNode()
    
    let rocketImages = [SKTexture(imageNamed: "Rocket 1"),
                        SKTexture(imageNamed: "Rocket 2"),
                        SKTexture(imageNamed: "Rocket 3"),
                        SKTexture(imageNamed: "Rocket 4"),
                        SKTexture(imageNamed: "Rocket 3A"),
                        SKTexture(imageNamed: "Rocket 5"),
                        SKTexture(imageNamed: "Rocket 6")]
    
    let phoenixImages = [SKTexture(imageNamed: "Phoenix 1"),
                         SKTexture(imageNamed: "Phoenix 2"),
                         SKTexture(imageNamed: "Phoenix 3"),
                         SKTexture(imageNamed: "Phoenix 4"),
                         SKTexture(imageNamed: "Phoenix 5")]
    
    override func didMove(to view: SKView) {
        
        
        
    }
    
}
