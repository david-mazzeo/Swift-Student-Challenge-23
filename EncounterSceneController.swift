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
    
    let redBeamImages = [SKTexture(imageNamed: "Red Beam 4"),
                         SKTexture(imageNamed: "Red Beam 3"),
                         SKTexture(imageNamed: "Red Beam 2"),
                         SKTexture(imageNamed: "Red Beam 1")]
    
    let yellowBeamImages = [SKTexture(imageNamed: "Yellow Beam 4"),
                            SKTexture(imageNamed: "Yellow Beam 3"),
                            SKTexture(imageNamed: "Yellow Beam 2"),
                            SKTexture(imageNamed: "Yellow Beam 1")]
    
    let blueBeamImages = [SKTexture(imageNamed: "Blue Beam 4"),
                          SKTexture(imageNamed: "Blue Beam 3"),
                          SKTexture(imageNamed: "Blue Beam 2"),
                          SKTexture(imageNamed: "Blue Beam 1")]
    
    let redSampleImages = [SKTexture(imageNamed: "Red Sample 1"),
                           SKTexture(imageNamed: "Red Sample 2"),
                           SKTexture(imageNamed: "Red Sample 3"),
                           SKTexture(imageNamed: "Red Sample 4")]
    
    let yellowSampleImages = [SKTexture(imageNamed: "Yellow Sample 1"),
                              SKTexture(imageNamed: "Yellow Sample 2"),
                              SKTexture(imageNamed: "Yellow Sample 3"),
                              SKTexture(imageNamed: "Yellow Sample 4")]
    
    let blueSampleImages = [SKTexture(imageNamed: "Blue Sample 1"),
                            SKTexture(imageNamed: "Blue Sample 2"),
                            SKTexture(imageNamed: "Blue Sample 3"),
                            SKTexture(imageNamed: "Blue Sample 4")]
    
    let fusionImages = [SKTexture(imageNamed: "Fusion Orb 1"),
                        SKTexture(imageNamed: "Fusion Orb 2"),
                        SKTexture(imageNamed: "Fusion Orb 3"),
                        SKTexture(imageNamed: "Fusion Orb 4"),
                        SKTexture(imageNamed: "Fusion Orb 5"),
                        SKTexture(imageNamed: "Fusion Orb 6"),
                        SKTexture(imageNamed: "Fusion Orb 7"),
                        SKTexture(imageNamed: "Fusion Orb 8")]
    
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
        
        for image in redBeamImages {
            image.filteringMode = .nearest
        }
        
        for image in yellowBeamImages {
            image.filteringMode = .nearest
        }
        
        for image in blueBeamImages {
            image.filteringMode = .nearest
        }
        
        for image in redSampleImages {
            image.filteringMode = .nearest
        }
        
        for image in yellowSampleImages {
            image.filteringMode = .nearest
        }
        
        for image in blueSampleImages {
            image.filteringMode = .nearest
        }
        
        for image in fusionImages {
            image.filteringMode = .nearest
        }
        
        protagonist.size = CGSize(width: 72, height: 120)
        protagonist.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) - 100)
        
        let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
        protagonist.run(rocketAnimation)
        
        self.addChild(protagonist)
                
        let redBeam = SKSpriteNode()
        redBeam.size = CGSize(width: 60, height: 54)
        redBeam.position = CGPoint(x: deviceWidth / 2 - 45, y: deviceHeight / 2 - 10)
        redBeam.zRotation = -45 * (.pi / 180)
        redBeam.alpha = 0
        
        let yellowBeam = SKSpriteNode()
        yellowBeam.size = CGSize(width: 60, height: 54)
        yellowBeam.position = CGPoint(x: deviceWidth / 2, y: deviceHeight / 2 + 15)
        yellowBeam.zRotation = -90 * (.pi / 180)
        yellowBeam.alpha = 0
        
        let blueBeam = SKSpriteNode()
        blueBeam.size = CGSize(width: 60, height: 54)
        blueBeam.position = CGPoint(x: deviceWidth / 2 + 45, y: deviceHeight / 2 - 10)
        blueBeam.zRotation = 225 * (.pi / 180)
        blueBeam.alpha = 0
        
        let redSample = SKSpriteNode()
        redSample.size = CGSize(width: 104, height: 116)
        redSample.position = CGPoint(x: deviceWidth / 2 - 115, y: deviceHeight / 2 + 55)
        redSample.alpha = 0
        
        let yellowSample = SKSpriteNode()
        yellowSample.size = CGSize(width: 104, height: 116)
        yellowSample.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) + 90)
        yellowSample.alpha = 0
        
        let blueSample = SKSpriteNode()
        blueSample.size = CGSize(width: 104, height: 116)
        blueSample.position = CGPoint(x: deviceWidth / 2 + 115, y: deviceHeight / 2 + 55)
        blueSample.alpha = 0
        
        let fusionOrb = SKSpriteNode()
        fusionOrb.size = CGSize(width: 84, height: 84)
        fusionOrb.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) - 25)
        fusionOrb.alpha = 0
        
        let flash = SKShapeNode()
        flash.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: deviceWidth, height: deviceHeight)).cgPath
        flash.fillColor = .white
        flash.zPosition = 1
        flash.alpha = 0
        
        let phoenix = SKSpriteNode()
        phoenix.size = CGSize(width: 61, height: 68)
        phoenix.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) + 60)
        phoenix.alpha = 0
        
        let redConstantAnimation = SKAction.repeatForever(SKAction.animate(with: redBeamImages, timePerFrame: 0.3))
        redBeam.run(redConstantAnimation)
        
        let redSampleAnimation = SKAction.repeatForever(SKAction.animate(with: redSampleImages, timePerFrame: 0.3))
        redSample.run(redSampleAnimation)
        
        let yellowConstantAnimation = SKAction.repeatForever(SKAction.animate(with: yellowBeamImages, timePerFrame: 0.3))
        yellowBeam.run(yellowConstantAnimation)
        
        let yellowSampleAnimation = SKAction.repeatForever(SKAction.animate(with: yellowSampleImages, timePerFrame: 0.3))
        yellowSample.run(yellowSampleAnimation)
        
        let blueConstantAnimation = SKAction.repeatForever(SKAction.animate(with: blueBeamImages, timePerFrame: 0.3))
        blueBeam.run(blueConstantAnimation)
        
        let blueSampleAnimation = SKAction.repeatForever(SKAction.animate(with: blueSampleImages, timePerFrame: 0.3))
        blueSample.run(blueSampleAnimation)
        
        let fusionAnimation = SKAction.repeatForever(SKAction.animate(with: fusionImages, timePerFrame: 0.3))
        fusionOrb.run(fusionAnimation)
        
        let phoenixAniation = SKAction.repeatForever(SKAction.animate(with: phoenixImages, timePerFrame: 0.3))
        phoenix.run(phoenixAniation)
        
        let appearAnimation = SKAction.fadeAlpha(to: 1, duration: 1)
        let disappearAnimation = SKAction.fadeAlpha(to: 0, duration: 1)
        
        run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "It's time to fuse our samples! Whenever you're ready.", speaker: "Scientist")
        }, SKAction.wait(forDuration: 3), SKAction.run {
            self.hideTV()
        }, SKAction.run {
            redBeam.run(appearAnimation)
            redSample.run(SKAction.fadeAlpha(to: 1, duration: 3))
        }, SKAction.wait(forDuration: 3), SKAction.run {
            redBeam.run(disappearAnimation)
        }, SKAction.run {
            yellowBeam.run(appearAnimation)
            yellowSample.run(SKAction.fadeAlpha(to: 1, duration: 3))
        }, SKAction.wait(forDuration: 3), SKAction.run {
            yellowBeam.run(disappearAnimation)
        }, SKAction.run {
            blueBeam.run(appearAnimation)
            blueSample.run(SKAction.fadeAlpha(to: 1, duration: 3))
        }, SKAction.wait(forDuration: 3), SKAction.run {
            blueBeam.run(disappearAnimation)
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "Get out of the way!", speaker: "Scientist")
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.protagonist.run(SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.15))
        }, SKAction.wait(forDuration: 0.5), SKAction.run { [self] in
            hideTV()
            
            let combinedPoint = CGPoint(x: deviceWidth / 2, y: deviceHeight / 2 + 100)
            redSample.run(SKAction.move(to: combinedPoint, duration: 3))
            yellowSample.run(SKAction.move(to: combinedPoint, duration: 3))
            blueSample.run(SKAction.move(to: combinedPoint, duration: 3))
            
            redSample.run(SKAction.resize(toWidth: 208, height: 232, duration: 3))
            yellowSample.run(SKAction.resize(toWidth: 208, height: 232, duration: 3))
            blueSample.run(SKAction.resize(toWidth: 208, height: 232, duration: 3))
            
            redSample.run(SKAction.fadeAlpha(to: 0.5, duration: 2.5))
            yellowSample.run(SKAction.fadeAlpha(to: 0.5, duration: 2.5))
            blueSample.run(SKAction.fadeAlpha(to: 0.5, duration: 2.5))
            
        }, SKAction.wait(forDuration: 2.5), SKAction.run {
            
            flash.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1, duration: 0.2),
                                         
                 SKAction.run { [self] in
                     redSample.alpha = 0
                     yellowSample.alpha = 0
                     blueSample.alpha = 0
                     fusionOrb.alpha = 1
                     
                     fusionOrb.run(SKAction.fadeAlpha(to: 0, duration: 3))
                     phoenix.run(SKAction.fadeAlpha(to: 1, duration: 3))
                     
                     phoenix.run(SKAction.resize(toWidth: 305, height: 340, duration: 3))
                     phoenix.run(SKAction.move(to: CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) + 50), duration: 3))
                 },
                                         
                SKAction.fadeAlpha(to: 0, duration: 0.4)]))
        }, SKAction.wait(forDuration: 4), SKAction.run {
            self.displayTV(dialogue: "No way...", speaker: "Scientist")
        }, SKAction.wait(forDuration: 2), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run { [self] in
            self.displayTV(dialogue: "Ah, so you made it.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 2), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "It... knew we were coming?", speaker: "Scientist")
        }, SKAction.wait(forDuration: 2), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run { [self] in
            self.displayTV(dialogue: "Of course. I've been observing your ship since you departed- erm, 'Lunaro', was it?", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 4), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run { [self] in
            self.displayTV(dialogue: "I have to say, you're the first to make it through the debris belt. Your determination is clear.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 4), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run { [self] in
            self.displayTV(dialogue: "On that note, I have decided to grant your wish. Your planet will be reborn, nulling the climate disaster it's currently facing.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 6), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "Before I do, however, I'd like you to make a promise on behalf of your people.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 4), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "Protect the planet you call home this time, for if it collapses again, you may not be lucky enough to convince me to save it twice.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 6), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "Can you give me this promise?", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 4), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "O- Of course!", speaker: "Scientist")
        }, SKAction.wait(forDuration: 2), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "Very well.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 2), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run {
            self.displayTV(dialogue: "In a moment, you'll be safely back on your now restored planet, as if nothing ever happened. Goodbye, brave crew.", speaker: "Phoenix")
        }, SKAction.wait(forDuration: 6), SKAction.run { [self] in
            self.hideTV()
        }, SKAction.wait(forDuration: 1), SKAction.run { [self] in
            phoenix.run(SKAction.resize(toWidth: 427, height: 476, duration: 1))
            phoenix.run(SKAction.move(to: CGPoint(x: deviceWidth / 2, y: (deviceHeight / 2) + 100), duration: 1))
        }, SKAction.wait(forDuration: 1), SKAction.run {
            flash.run(SKAction.sequence([
                SKAction.fadeAlpha(to: 1, duration: 0.2),
                                         
                 SKAction.run {
                     //
                 },
                                         
                SKAction.fadeAlpha(to: 0, duration: 0.4)]))
        }]))
        
        self.addChild(redBeam)
        self.addChild(yellowBeam)
        self.addChild(blueBeam)
        
        self.addChild(redSample)
        self.addChild(yellowSample)
        self.addChild(blueSample)
        
        self.addChild(fusionOrb)
        self.addChild(flash)
        self.addChild(phoenix)
        
    }
    
}
