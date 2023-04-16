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
    
    let protagonist = SKSpriteNode(imageNamed: "Rocket 1.png")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        self.view?.backgroundColor = .clear
        self.scaleMode = .aspectFit
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        for image in phoenixImages {
            image.filteringMode = .nearest
        }
        
        protagonist.size = CGSize(width: 72, height: 120)
        protagonist.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) - 50)
        
        let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
        protagonist.run(rocketAnimation)
        
        self.addChild(protagonist)
        
        
        
    }
    
}
