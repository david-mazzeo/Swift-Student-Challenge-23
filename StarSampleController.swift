//
//  StarSampleController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 14/4/2023.
//

import SpriteKit

class StarSampleScene: SKScene {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
    let level = UserDefaults.standard.integer(forKey: "nextLevel")
    
    let TVScreen = SKSpriteNode(imageNamed: "CRT Shape")
    let croppedFrame = SKCropNode()
    
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
            beamImages = [SKTexture(imageNamed: "Red Sample 1"),
                          SKTexture(imageNamed: "Red Sample 2"),
                          SKTexture(imageNamed: "Red Sample 3"),
                          SKTexture(imageNamed: "Red Sample 4")]
            
            UserDefaults.standard.set(2, forKey: "nextLevel")
            
        case 2:
            starName = "Yellow Star"
            beamImages = [SKTexture(imageNamed: "Yellow Sample 1"),
                          SKTexture(imageNamed: "Yellow Sample 2"),
                          SKTexture(imageNamed: "Yellow Sample 3"),
                          SKTexture(imageNamed: "Yellow Sample 4")]
            
            UserDefaults.standard.set(3, forKey: "nextLevel")
            
        case 3:
            starName = "Blue Star"
            beamImages = [SKTexture(imageNamed: "Blue Sample 1"),
                          SKTexture(imageNamed: "Blue Sample 2"),
                          SKTexture(imageNamed: "Blue Sample 3"),
                          SKTexture(imageNamed: "Blue Sample 4")]
            
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
                 SKAction.run { [self] in
                     displayTV(dialogue: "Successfully acquired the \(starName) Sample.", speaker: "System")
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                         hideTV()
                         
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                         switch level {
                         case 1: displayTV(dialogue: "First star down! Two more to go!", speaker: "Scientist")
                         case 2: displayTV(dialogue: "You've collected the second sample, nice work! One left!", speaker: "Scientist")
                         case 3: displayTV(dialogue: "You got the last sample! Now, prepare to fuse them.", speaker: "Scientist")
                         default: break
                         }
                         
                     DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
                         hideTV()
                         
                     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                         NotificationCenter.default.post(name: Notification.Name("switchViews"), object: nil)
                     }
                     }
                     }
                     }
                 }]))
    }
    
    func displayTV(dialogue: String, speaker: String) {
        var deviceOffset = CGFloat(0)
        var speakerFontSize = CGFloat(30)
        var dialogueFontSize = CGFloat(18)
        var offsetToCenter = CGFloat(60)
        var labelOffset = CGFloat(-10)
        var scientistSize = CGSize(width: 120, height: 162)
        var systemSize = CGSize(width: 107.5, height: 102.5)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            deviceOffset = 50
            speakerFontSize = 16
            dialogueFontSize = 12
            offsetToCenter = 40
            labelOffset = -5
            scientistSize = CGSize(width: 100, height: 135)
            systemSize = CGSize(width: 86, height: 82)
        }
        
        TVScreen.size = CGSize(width: 20, height: 20)
        TVScreen.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - ((250 - deviceOffset) / 2)) - topPadding + (deviceOffset / 2))
        
        let croppedTV = SKSpriteNode(imageNamed: "CRT Shape")
        croppedTV.size = TVScreen.size
        
        croppedFrame.maskNode = croppedTV
        croppedFrame.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - ((250 - deviceOffset) / 2)) - topPadding + (deviceOffset / 2))
        
        var portrait = SKSpriteNode(imageNamed: "Scientist 1")
        
        if speaker == "System" {
            let texture = SKTexture(imageNamed: "System")
            texture.filteringMode = .nearest
            portrait = SKSpriteNode(texture: texture)
            portrait.position = CGPoint(x: (120 - deviceOffset / 2) - (deviceWidth / 2), y: 0)
            portrait.size = systemSize
        } else {
            let portraitAnimation = SKAction.repeatForever(SKAction.animate(with: scientistImages, timePerFrame: 0.3))
            portrait.run(portraitAnimation)
            portrait.position = CGPoint(x: 100 - (deviceWidth / 2), y: -10)
            portrait.size = scientistSize
        }
        
        
        var speakerFont = UIFont.systemFont(ofSize: speakerFontSize, weight: .bold)
        
        if #available(iOS 16.0, *) {
            speakerFont = UIFont.systemFont(ofSize: speakerFontSize, weight: .bold, width: UIFont.Width(rawValue: 1))
        }
        
        let speakerLabel = SKLabelNode(attributedText: NSAttributedString(string: speaker, attributes: [.font: speakerFont, .foregroundColor: UIColor.green]))
        speakerLabel.horizontalAlignmentMode = .left
        
        let dialogueFont = UIFont.systemFont(ofSize: dialogueFontSize, weight: .regular)
        
        let dialogueLabel = SKLabelNode(attributedText: NSAttributedString(string: dialogue, attributes: [.font: dialogueFont, .foregroundColor: UIColor.green]))
        dialogueLabel.horizontalAlignmentMode = .left
        dialogueLabel.verticalAlignmentMode = .top
        dialogueLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = deviceWidth - 240
        
        speakerLabel.position = CGPoint(x: 190 - (deviceWidth / 2) - (deviceOffset / 2), y: (speakerLabel.frame.height + 10 + dialogueLabel.frame.height - offsetToCenter) / 2)
        dialogueLabel.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: CGPoint(x: 0, y: labelOffset), in: speakerLabel)]
        
        croppedFrame.addChild(portrait)
        croppedFrame.addChild(speakerLabel)
        croppedFrame.addChild(dialogueLabel)
        
        self.addChild(TVScreen)
        self.addChild(croppedFrame)
        
        let firstGrow = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.1)
        let secondGrow = SKAction.resize(toWidth: deviceWidth - 40, height: 200 - deviceOffset, duration: 0.2)
        
        TVScreen.run(SKAction.sequence([firstGrow, secondGrow]))
        croppedFrame.maskNode!.run(SKAction.sequence([firstGrow, secondGrow]))
    }
    
    func hideTV(complete: (() -> Void)? = nil) {
        let firstShrink = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.2)
        let secondShrink = SKAction.resize(toWidth: 20, height: 20, duration: 0.1)
        
        TVScreen.run(SKAction.sequence([firstShrink, secondShrink, SKAction.removeFromParent()]))
        croppedFrame.maskNode!.run(SKAction.sequence([firstShrink, secondShrink, SKAction.run { [self] in
            croppedFrame.removeAllChildren()
            croppedFrame.removeFromParent()
            
            if complete != nil {
                complete!()
            }
        }]))
    }
    
}
