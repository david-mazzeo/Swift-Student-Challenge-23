//
//  SpaceFlightController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 6/4/2023.
//

import UIKit
import SpriteKit
import CoreMotion

class SpaceFlightController: UIViewController {
    
    @IBOutlet weak var spriteKitView: SKView!
    @IBOutlet weak var elementOneButton: UIButton!
    @IBOutlet weak var elementTwoButton: UIButton!
    
    @IBAction func elementOneFire(_ sender: Any) {
        elementTwoButton.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name("fire"), object: nil, userInfo: ["element": 1])
    }
    
    @IBAction func elementOneReleased(_ sender: Any) {
        elementTwoButton.isEnabled = true
        NotificationCenter.default.post(name: NSNotification.Name("released"), object: nil)
    }
    
    @IBAction func elementTwoFire(_ sender: Any) {
        elementOneButton.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name("fire"), object: nil, userInfo: ["element": 2])
    }
    
    @IBAction func elementTwoReleased(_ sender: Any) {
        elementOneButton.isEnabled = true
        NotificationCenter.default.post(name: NSNotification.Name("released"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        spriteKitView.presentScene(FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        NotificationCenter.default.post(name: NSNotification.Name("released"), object: nil)
        elementOneButton.isEnabled = true
        elementTwoButton.isEnabled = true
    }
    
}

class FlightScene: SKScene, SKPhysicsContactDelegate {
    
    let rocketImages = [SKTexture(image: UIImage(named: "Rocket 1")!),
                        SKTexture(image: UIImage(named: "Rocket 2")!),
                        SKTexture(image: UIImage(named: "Rocket 3")!),
                        SKTexture(image: UIImage(named: "Rocket 4")!),
                        SKTexture(image: UIImage(named: "Rocket 3A")!),
                        SKTexture(image: UIImage(named: "Rocket 5")!),
                        SKTexture(image: UIImage(named: "Rocket 6")!)]
    
    let greenChargeUpImages = [SKTexture(image: UIImage(named: "Green Beam 1")!),
                               SKTexture(image: UIImage(named: "Green Beam 2")!),
                               SKTexture(image: UIImage(named: "Green Beam 3")!),
                               SKTexture(image: UIImage(named: "Green Beam 4")!),
                               SKTexture(image: UIImage(named: "Green Beam 5")!),
                               SKTexture(image: UIImage(named: "Green Beam 6")!)]
    
    let scientistImages = [SKTexture(image: UIImage(named: "Scientist 1")!),
                           SKTexture(image: UIImage(named: "Scientist 2")!)]
    
    var isSetup = false
    var isBeamActive = false
    let motionEngine = CMMotionManager()
    
    let TVScreen = SKSpriteNode(imageNamed: "CRT Shape")
    let protagonist = Rocket(imageNamed: "Rocket 1.png")
    let croppedFrame = SKCropNode()
    let beam = SKShapeNode()
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
    let bottomPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.bottom ?? 0
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(fireLaser(_:)), name: NSNotification.Name("fire"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endLaser(_:)), name: NSNotification.Name("released"), object: nil)
        
        self.scaleMode = .aspectFit
        physicsWorld.contactDelegate = self
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        for image in greenChargeUpImages {
            image.filteringMode = .nearest
        }
        
        for image in scientistImages {
            image.filteringMode = .nearest
        }
        
        motionEngine.accelerometerUpdateInterval = 1/60
        motionEngine.gyroUpdateInterval = 1/60
        
        motionEngine.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { [self] (data, error) -> Void in
            let xAxis = motionEngine.accelerometerData?.acceleration.x ?? 0.0
            if isSetup {
                protagonist.physicsBody!.applyForce(CGVector(dx: 40 * xAxis, dy: 0))
            }
        })
        
        run(SKAction.run { [self] in
            
            protagonist.size = CGSize(width: 72, height: 120)
            protagonist.position = CGPoint(x: 50, y: 163 + bottomPadding)
            protagonist.zRotation = 0
            
            protagonist.physicsBody = SKPhysicsBody(rectangleOf: protagonist.size)
            protagonist.physicsBody?.isDynamic = true
            protagonist.physicsBody?.mass = 0.02
            protagonist.physicsBody?.affectedByGravity = false
            protagonist.physicsBody?.allowsRotation = false
            protagonist.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0)),
                                       SKConstraint.positionY(SKRange(constantValue: 163 + bottomPadding)),
                                       SKConstraint.positionX(SKRange(lowerLimit: 1, upperLimit: deviceWidth - 1))]
            
            self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

            let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
            protagonist.run(rocketAnimation)
            
            self.addChild(protagonist)
            isSetup = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                displayTV()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                hideTV()
            }
            
        })
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(addAsteroidOne),
            SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
        
    }
    
    func displayTV() {
        TVScreen.size = CGSize(width: 20, height: 20)
        TVScreen.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - 120) - topPadding)
        
        let croppedTV = SKSpriteNode(imageNamed: "CRT Shape")
        croppedTV.size = TVScreen.size
        
        croppedFrame.maskNode = croppedTV
        croppedFrame.position = CGPoint(x: deviceWidth / 2, y: (deviceHeight - 120) - topPadding)
        
        let portrait = SKSpriteNode(imageNamed: "Scientist 1")
        
        let portraitAnimation = SKAction.repeatForever(SKAction.animate(with: scientistImages, timePerFrame: 0.3))
        portrait.run(portraitAnimation)
    
        portrait.size = CGSize(width: 140, height: 189)
        portrait.position = CGPoint(x: 100 - (deviceWidth / 2), y: -10)
        
        var speakerFontSize = CGFloat(30)
        var dialogueFontSize = CGFloat(18)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            speakerFontSize = 22
            dialogueFontSize = 14
        }
        
        var speakerFont = UIFont.systemFont(ofSize: speakerFontSize, weight: .bold)
        
        if #available(iOS 16.0, *) {
            speakerFont = UIFont.systemFont(ofSize: speakerFontSize, weight: .bold, width: UIFont.Width(rawValue: 1))
        }
        
        let speakerLabel = SKLabelNode(attributedText: NSAttributedString(string: "Scientist", attributes: [.font: speakerFont, .foregroundColor: UIColor.green]))
        speakerLabel.horizontalAlignmentMode = .left
        
        let dialogueFont = UIFont.systemFont(ofSize: dialogueFontSize, weight: .regular)
        
        let dialogueLabel = SKLabelNode(attributedText: NSAttributedString(string: "Fake text; blah, blah, blah.", attributes: [.font: dialogueFont, .foregroundColor: UIColor.green]))
        dialogueLabel.horizontalAlignmentMode = .left
        dialogueLabel.verticalAlignmentMode = .top
        dialogueLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        dialogueLabel.numberOfLines = 0
        dialogueLabel.preferredMaxLayoutWidth = deviceWidth - 240
        
        speakerLabel.position = CGPoint(x: 190 - (deviceWidth / 2), y: (speakerLabel.frame.height + 10 + dialogueLabel.frame.height - 60) / 2)
        dialogueLabel.constraints = [SKConstraint.distance(SKRange(constantValue: 0), to: CGPoint(x: 0, y: -10), in: speakerLabel)]
        
        croppedFrame.addChild(portrait)
        croppedFrame.addChild(speakerLabel)
        croppedFrame.addChild(dialogueLabel)
        
        self.addChild(TVScreen)
        self.addChild(croppedFrame)
        
        let firstGrow = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.1)
        let secondGrow = SKAction.resize(toWidth: deviceWidth - 40, height: 200, duration: 0.2)
        
        TVScreen.run(SKAction.sequence([firstGrow, secondGrow]))
        croppedFrame.maskNode!.run(SKAction.sequence([firstGrow, secondGrow]))
    }
    
    func hideTV() {
        let firstShrink = SKAction.resize(toWidth: deviceWidth - 40, height: 20, duration: 0.2)
        let secondShrink = SKAction.resize(toWidth: 20, height: 20, duration: 0.1)
        
        TVScreen.run(SKAction.sequence([firstShrink, secondShrink, SKAction.removeFromParent()]))
        croppedFrame.maskNode!.run(SKAction.sequence([firstShrink, secondShrink, SKAction.run { [self] in
            croppedFrame.removeAllChildren()
            croppedFrame.removeFromParent()
        }]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "Beam" && contact.bodyB.node?.name == "Asteroid" {
            contact.bodyB.node?.removeFromParent()
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 4294967296)
    }
    
    func randomBesides(min: CGFloat, max: CGFloat, besidesMin: CGFloat, besidesMax: CGFloat) -> CGFloat {
        var value = random() * (max - min) + min
        
        while value > besidesMin && value < besidesMax {
            value = random() * (max - min) + min
        }
        
        return value
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addAsteroidOne() {
        let texture = SKTexture(image: UIImage(named: "Asteroid 1")!)
        texture.filteringMode = .nearest
        
        let asteroid = Asteroid(texture: texture)
        
        asteroid.size = CGSize(width: 96, height: 80)
        asteroid.position = CGPoint(x: random(min: 0, max: deviceWidth), y: deviceHeight + 100)
        
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.collisionBitMask = 0
        asteroid.name = "Asteroid"
        asteroid.physicsBody?.contactTestBitMask = 1
        
        self.addChild(asteroid)
        
        let actionMove = SKAction.move(to: CGPoint(x: random(min: 0, max: deviceWidth), y: 0), duration: TimeInterval(random(min: 1, max: 2)))
        asteroid.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
        
    }
    
    @objc func fireLaser(_ notification: Notification) {
        let chargeUpView = SKSpriteNode(texture: greenChargeUpImages.first)
        
        chargeUpView.size = CGSize(width: 24, height: 18)
        chargeUpView.position = CGPoint(x: 0, y: 70)
        
        protagonist.addChild(chargeUpView)
        
        let chargeUpAnimation = SKAction.animate(with: greenChargeUpImages, timePerFrame: 1/12)
        
        chargeUpView.run(SKAction.sequence([chargeUpAnimation, SKAction.removeFromParent(), SKAction.run { [self] in
            
            var colour = UIColor()
            protagonist.addChild(beam)
            
            let element = notification.userInfo?["element"] as? Int
            
            switch element {
            case 1: colour = .green
            case 2: colour = .blue
            default: break
            }
            
            let beamHeight = (deviceHeight - 240) - (topPadding + bottomPadding)
            let beamPath = UIBezierPath(rect: CGRect(x: 0, y: 70, width: 2, height: beamHeight)).cgPath
            
            beam.path = beamPath
            beam.lineWidth = 6
            beam.strokeColor = colour
            
            beam.name = "Beam"
            beam.physicsBody = SKPhysicsBody(edgeChainFrom: beamPath)
            beam.physicsBody?.isDynamic = true
            beam.physicsBody?.affectedByGravity = false
            beam.physicsBody?.allowsRotation = false
            beam.physicsBody?.collisionBitMask = 0
            beam.physicsBody?.contactTestBitMask = 1
            beam.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0)),
                                SKConstraint.positionY(SKRange(constantValue: 0)),
                                SKConstraint.positionX(SKRange(constantValue: 0))]
            
            isBeamActive = true
            
            let particles = [SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode(), SKShapeNode()]
            
            for particle in particles {
                particle.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2, height: 2)).cgPath
                particle.strokeColor = colour
                particle.lineWidth = 1
                
                beam.addChild(particle)
            }
            
            
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run { [self] in
                    for particle in particles {
                        particle.position = CGPoint(x: randomBesides(min: -20, max: 22, besidesMin: -10, besidesMax: 12), y: random(min: 70, max: beamHeight))
                    }
                },
                SKAction.wait(forDuration: 0.4)])))
            
        }]))
        
    }
    
    @objc func endLaser(_ notification: Notification) {
        beam.removeAllChildren()
        protagonist.removeAllChildren()
        isBeamActive = false
    }
    
}

class Rocket: SKSpriteNode {
    
}

class Asteroid: SKSpriteNode {
    
}
