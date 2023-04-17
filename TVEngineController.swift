//
//  TVEngineController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 16/4/2023.
//

import SpriteKit

extension SKScene {
    
    func displayTV(dialogue: String, speaker: String) {
        
        let deviceHeight = UIScreen.main.bounds.height
        let deviceWidth = UIScreen.main.bounds.width
        
        let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
        
        let scientistImages = [SKTexture(imageNamed: "Scientist 1"),
                               SKTexture(imageNamed: "Scientist 2")]
        
        let phoenixImages = [SKTexture(imageNamed: "Phoenix Portrait 1"),
                             SKTexture(imageNamed: "Phoenix Portrait 2")]
        
        let systemImages = SKTexture(imageNamed: "System")
        
        let TVScreen = SKSpriteNode(imageNamed: "CRT Shape")
        let croppedFrame = SKCropNode()
        
        var deviceOffset = CGFloat(0)
        var speakerFontSize = CGFloat(30)
        var dialogueFontSize = CGFloat(18)
        var offsetToCenter = CGFloat(60)
        var labelOffset = CGFloat(-10)
        var scientistSize = CGSize(width: 120, height: 162)
        var systemSize = CGSize(width: 107.5, height: 102.5)
        var phoenixSize = CGSize(width: 175, height: 175)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            deviceOffset = 50
            speakerFontSize = 16
            dialogueFontSize = 12
            offsetToCenter = 40
            labelOffset = -5
            scientistSize = CGSize(width: 100, height: 135)
            systemSize = CGSize(width: 86, height: 82)
            phoenixSize = CGSize(width: 150, height: 150)
        }
        
        TVScreen.name = "TV Frame"
        TVScreen.size = CGSize(width: 20, height: 20)
        
        let croppedTV = SKSpriteNode(imageNamed: "CRT Shape")
        croppedTV.size = TVScreen.size

        croppedFrame.name = "TV Content"
        croppedFrame.maskNode = croppedTV
        
        if self.scene?.name == "Game" {
            TVScreen.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - 166) - topPadding + (deviceOffset / 2))
            croppedFrame.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - 166) - topPadding + (deviceOffset / 2))
        } else {
            TVScreen.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - ((250 - deviceOffset) / 2)) - topPadding + (deviceOffset / 2))
            croppedFrame.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - ((250 - deviceOffset) / 2)) - topPadding + (deviceOffset / 2))
        }
        
        var portrait = SKSpriteNode()
        
        switch speaker {
        case "System":
            
            systemImages.filteringMode = .nearest
            portrait = SKSpriteNode(texture: systemImages)
            portrait.position = CGPoint(x: (120 - deviceOffset / 2) - (deviceWidth / 2), y: 0)
            portrait.size = systemSize
            
        case "Scientist":
            
            for image in scientistImages {
                image.filteringMode = .nearest
            }
            
            let portraitAnimation = SKAction.repeatForever(SKAction.animate(with: scientistImages, timePerFrame: 0.3))
            portrait.run(portraitAnimation)
            portrait.position = CGPoint(x: 100 - (deviceWidth / 2), y: -10)
            portrait.size = scientistSize
            
        case "Phoenix":
            
            for image in phoenixImages {
                image.filteringMode = .nearest
            }
            
            let portraitAnimation = SKAction.repeatForever(SKAction.animate(with: phoenixImages, timePerFrame: 0.3))
            portrait.run(portraitAnimation)
            portrait.position = CGPoint(x: (95 - deviceOffset / 4) - (deviceWidth / 2), y: 0)
            portrait.size = phoenixSize
            
        default: break
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
        let deviceWidth = UIScreen.main.bounds.width
        let firstShrink = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.2)
        let secondShrink = SKAction.resize(toWidth: 20, height: 20, duration: 0.1)
        
        for child in self.children {
            if child.name == "TV Frame" {
                child.run(SKAction.sequence([firstShrink, secondShrink, SKAction.removeFromParent()]))
            }
            
            if child.name == "TV Content" {
                (child as! SKCropNode).maskNode!.run(SKAction.sequence([firstShrink, secondShrink, SKAction.run {
                    child.removeAllChildren()
                    child.removeFromParent()
                    
                    if complete != nil {
                        complete!()
                    }
                }]))
            }
        }
    }
}
