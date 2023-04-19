//
//  StarSampleController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 14/4/2023.
//

import SpriteKit

class StarSampleScene: SKScene {
    
    var deviceHeight = CGFloat(0)
    var deviceWidth = CGFloat(0)
    
    let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
    let level = UserDefaults.standard.integer(forKey: "nextLevel")
    
    let rocketImages = [SKTexture(imageNamed: "Rocket 1"),
                        SKTexture(imageNamed: "Rocket 2"),
                        SKTexture(imageNamed: "Rocket 3"),
                        SKTexture(imageNamed: "Rocket 4"),
                        SKTexture(imageNamed: "Rocket 3A"),
                        SKTexture(imageNamed: "Rocket 5"),
                        SKTexture(imageNamed: "Rocket 6")]
    
    let scientistImages = [SKTexture(imageNamed: "Scientist 1"),
                           SKTexture(imageNamed: "Scientist 2")]
    
    var beamImages = [SKTexture]()
    
    override func didMove(to view: SKView) {
        
        if wasLandscape {
            deviceWidth = UIScreen.main.bounds.height
            deviceHeight = UIScreen.main.bounds.width
        } else {
            deviceHeight = UIScreen.main.bounds.height
            deviceWidth = UIScreen.main.bounds.width
        }
        
        var starMultiplier = CGFloat(20)
        var rocketMultiplier = CGFloat(6)
        var beamMultiplier = CGFloat(5)
        var beamModifier = CGFloat(-60)
        var rocketModifier = CGFloat(-5)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            starMultiplier = 10
            beamMultiplier = 3
            rocketMultiplier = 4
            beamModifier = -20
            rocketModifier = 20
        }
        
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        self.view?.backgroundColor = .clear
        self.scaleMode = .aspectFit
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        for image in scientistImages {
            image.filteringMode = .nearest
        }
        
        let protagonist = SKSpriteNode(imageNamed: "Rocket 1")
        
        protagonist.size = CGSize(width: 18 * rocketMultiplier, height: 30 * rocketMultiplier)
        protagonist.position = CGPoint(x: rocketModifier + (beamMultiplier * 20) + (starMultiplier * 24), y: deviceHeight / 2)
        protagonist.zRotation = .pi / 2
        
        let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
        protagonist.run(rocketAnimation)
        
        self.addChild(protagonist)
        
        var starName = ""
        
        switch level {
        case 1:
            starName = "Red Star"
            beamImages = [SKTexture(imageNamed: "Red Beam 1"),
                          SKTexture(imageNamed: "Red Beam 2"),
                          SKTexture(imageNamed: "Red Beam 3"),
                          SKTexture(imageNamed: "Red Beam 4")]
            
            UserDefaults.standard.set(2, forKey: "nextLevel")
            
        case 2:
            starName = "Yellow Star"
            beamImages = [SKTexture(imageNamed: "Yellow Beam 1"),
                          SKTexture(imageNamed: "Yellow Beam 2"),
                          SKTexture(imageNamed: "Yellow Beam 3"),
                          SKTexture(imageNamed: "Yellow Beam 4")]
            
            UserDefaults.standard.set(3, forKey: "nextLevel")
            
        case 3:
            starName = "Blue Star"
            beamImages = [SKTexture(imageNamed: "Blue Beam 1"),
                          SKTexture(imageNamed: "Blue Beam 2"),
                          SKTexture(imageNamed: "Blue Beam 3"),
                          SKTexture(imageNamed: "Blue Beam 4")]
            
            UserDefaults.standard.set(4, forKey: "nextLevel")
            
        default: break
        }
        
        for image in beamImages {
            image.filteringMode = .nearest
        }
        
        let texture = SKTexture(imageNamed: starName)
        texture.filteringMode = .nearest
        let star = SKSpriteNode(texture: texture)
        
        star.size = CGSize(width: 24 * starMultiplier, height: 48 * starMultiplier)
        star.position = CGPoint(x: 12 * starMultiplier, y: deviceHeight / 2)
        
        self.addChild(star)
        
        let beam = SKSpriteNode(texture: beamImages.first)
        
        beam.size = CGSize(width: 20 * beamMultiplier, height: 18 * beamMultiplier)
        beam.position = CGPoint(x: beamModifier + (starMultiplier * 24), y: deviceHeight / 2)
        
        let beamAnimation = SKAction.repeatForever(SKAction.animate(with: beamImages, timePerFrame: 0.3))
        beam.run(beamAnimation)
        
        self.addChild(beam)
        
        beam.run(SKAction.sequence([
                 SKAction.wait(forDuration: 2.5),
                 SKAction.fadeAlpha(to: 0, duration: 0.5),
                 SKAction.run { [weak self] in
                     
                     self?.displayTV(dialogue: "Successfully acquired the \(starName) Sample.", speaker: "System")
                     
                 }, SKAction.wait(forDuration: 2), SKAction.run { [weak self] in
                     
                     self?.hideTV()
                     
                 }, SKAction.wait(forDuration: 1), SKAction.run { [weak self] in
                     
                     switch self?.level {
                     case 1: self?.displayTV(dialogue: "First star down! Two more to go!", speaker: "Scientist")
                     case 2: self?.displayTV(dialogue: "You've collected the second sample, nice work! One left!", speaker: "Scientist")
                     case 3: self?.displayTV(dialogue: "You got the last sample! Now, prepare to fuse them.", speaker: "Scientist")
                     default: break
                     }
                     
                 }, SKAction.wait(forDuration: 2), SKAction.run { [weak self] in
                     
                     self?.hideTV()
                     
                 }, SKAction.wait(forDuration: 0.5), SKAction.run {
                     
                     NotificationCenter.default.post(name: Notification.Name("switchViews"), object: nil)
                     
                 }]))
    }
    
}
