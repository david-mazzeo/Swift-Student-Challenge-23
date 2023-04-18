//
//  FlightSceneController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 15/4/2023.
//

import SpriteKit
import CoreMotion

class FlightScene: SKScene, SKPhysicsContactDelegate {
    
    let rocketImages = [SKTexture(imageNamed: "Rocket 1"),
                        SKTexture(imageNamed: "Rocket 2"),
                        SKTexture(imageNamed: "Rocket 3"),
                        SKTexture(imageNamed: "Rocket 4"),
                        SKTexture(imageNamed: "Rocket 3A"),
                        SKTexture(imageNamed: "Rocket 5"),
                        SKTexture(imageNamed: "Rocket 6")]
    
    let cometImages = [SKTexture(imageNamed: "Comet 1"),
                       SKTexture(imageNamed: "Comet 2"),
                       SKTexture(imageNamed: "Comet 3"),
                       SKTexture(imageNamed: "Comet 4"),
                       SKTexture(imageNamed: "Comet 5"),
                       SKTexture(imageNamed: "Comet 6"),
                       SKTexture(imageNamed: "Comet 7"),
                       SKTexture(imageNamed: "Comet 8")]
    
    let blackHoleImages = [SKTexture(imageNamed: "Black Hole 1"),
                           SKTexture(imageNamed: "Black Hole 2"),
                           SKTexture(imageNamed: "Black Hole 3"),
                           SKTexture(imageNamed: "Black Hole 4"),
                           SKTexture(imageNamed: "Black Hole 5"),
                           SKTexture(imageNamed: "Black Hole 6"),
                           SKTexture(imageNamed: "Black Hole 7")]
    
    let greenChargeUpImages = [SKTexture(imageNamed: "Green Charge 1"),
                               SKTexture(imageNamed: "Green Charge 2"),
                               SKTexture(imageNamed: "Green Charge 3"),
                               SKTexture(imageNamed: "Green Charge 4"),
                               SKTexture(imageNamed: "Green Charge 5"),
                               SKTexture(imageNamed: "Green Charge 6")]
    
    let asteroidDestroyedImages = [SKTexture(imageNamed: "Asteroid Hit 1"),
                                   SKTexture(imageNamed: "Asteroid Hit 2"),
                                   SKTexture(imageNamed: "Asteroid Hit 3"),
                                   SKTexture(imageNamed: "Asteroid Hit 4"),
                                   SKTexture(imageNamed: "Asteroid Hit 5"),
                                   SKTexture(imageNamed: "Asteroid Hit 6"),
                                   SKTexture(imageNamed: "Asteroid Hit 7"),
                                   SKTexture(imageNamed: "Asteroid Hit 8"),
                                   SKTexture(imageNamed: "Asteroid Hit 9"),
                                   SKTexture(imageNamed: "Asteroid Hit 10"),
                                   SKTexture(imageNamed: "Asteroid Hit 11")]
    
    let cometDestroyedImages = [SKTexture(imageNamed: "Comet Hit 1"),
                                SKTexture(imageNamed: "Comet Hit 2"),
                                SKTexture(imageNamed: "Comet Hit 3"),
                                SKTexture(imageNamed: "Comet Hit 4"),
                                SKTexture(imageNamed: "Comet Hit 5"),
                                SKTexture(imageNamed: "Comet Hit 6"),
                                SKTexture(imageNamed: "Comet Hit 7"),
                                SKTexture(imageNamed: "Comet Hit 8"),
                                SKTexture(imageNamed: "Comet Hit 9"),
                                SKTexture(imageNamed: "Comet Hit 10")]
    
    let explosionImages = [SKTexture(imageNamed: "Explosion 1"),
                           SKTexture(imageNamed: "Explosion 2"),
                           SKTexture(imageNamed: "Explosion 3"),
                           SKTexture(imageNamed: "Explosion 4"),
                           SKTexture(imageNamed: "Explosion 5"),
                           SKTexture(imageNamed: "Explosion 6"),
                           SKTexture(imageNamed: "Explosion 7"),
                           SKTexture(imageNamed: "Explosion 8"),
                           SKTexture(imageNamed: "Explosion 9"),
                           SKTexture(imageNamed: "Explosion 10"),
                           SKTexture(imageNamed: "Explosion 11"),
                           SKTexture(imageNamed: "Explosion 12"),
                           SKTexture(imageNamed: "Explosion 13"),
                           SKTexture(imageNamed: "Explosion 14"),
                           SKTexture(imageNamed: "Explosion 15")]
    
    let cometExplosionImages = [SKTexture(imageNamed: "Comet Explosion 1"),
                                SKTexture(imageNamed: "Comet Explosion 2"),
                                SKTexture(imageNamed: "Comet Explosion 3"),
                                SKTexture(imageNamed: "Comet Explosion 4"),
                                SKTexture(imageNamed: "Comet Explosion 5"),
                                SKTexture(imageNamed: "Comet Explosion 6"),
                                SKTexture(imageNamed: "Comet Explosion 7"),
                                SKTexture(imageNamed: "Comet Explosion 8"),
                                SKTexture(imageNamed: "Comet Explosion 9"),
                                SKTexture(imageNamed: "Comet Explosion 10"),
                                SKTexture(imageNamed: "Comet Explosion 11"),
                                SKTexture(imageNamed: "Comet Explosion 12"),
                                SKTexture(imageNamed: "Comet Explosion 13"),
                                SKTexture(imageNamed: "Comet Explosion 14"),
                                SKTexture(imageNamed: "Comet Explosion 15")]
    
    let rocketDestroyedImages = [SKTexture(imageNamed: "Rocket Hit 1"),
                                 SKTexture(imageNamed: "Rocket Hit 2"),
                                 SKTexture(imageNamed: "Rocket Hit 3"),
                                 SKTexture(imageNamed: "Rocket Hit 4"),
                                 SKTexture(imageNamed: "Rocket Hit 5"),
                                 SKTexture(imageNamed: "Rocket Hit 6"),
                                 SKTexture(imageNamed: "Rocket Hit 7"),
                                 SKTexture(imageNamed: "Rocket Hit 8"),
                                 SKTexture(imageNamed: "Rocket Hit 9"),
                                 SKTexture(imageNamed: "Rocket Hit 10"),
                                 SKTexture(imageNamed: "Rocket Hit 11"),
                                 SKTexture(imageNamed: "Rocket Hit 12")]
    
    var isTVOn = false
    var isSetup = false
    var isBeamActive = false
    var isAlreadyBlackHole = false
    var healthEvents = true
    var isRoundFinished = false
    var objectPickerMax = 0
    var forceModifier = Double(0)
    var motionEngine = CMMotionManager()
    
    let protagonist = SKSpriteNode(imageNamed: "Rocket 1.png")
    let beam = SKShapeNode()
    let level = UserDefaults.standard.integer(forKey: "nextLevel")
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    let topPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.top ?? 0
    let bottomPadding = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.safeAreaInsets.bottom ?? 0
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("fire"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("released"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("finishLevel"), object: nil)
        print("DEINITIALISED")
    }
    
    override func didMove(to view: SKView) {
        
        print("NEWVIEW")
        
        NotificationCenter.default.addObserver(self, selector: #selector(fireLaser(_:)), name: Notification.Name("fire"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endLaser(_:)), name: Notification.Name("released"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishLevel(_:)), name: Notification.Name("finishLevel"), object: nil)
        
        self.scene?.name = "Game"
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        self.view?.backgroundColor = .clear
        
        self.scaleMode = .aspectFit
        physicsWorld.contactDelegate = self
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        for image in greenChargeUpImages {
            image.filteringMode = .nearest
        }
        
        for image in asteroidDestroyedImages {
            image.filteringMode = .nearest
        }
        
        for image in cometDestroyedImages {
            image.filteringMode = .nearest
        }
        
        for image in cometImages {
            image.filteringMode = .nearest
        }
        
        for image in explosionImages {
            image.filteringMode = .nearest
        }
        
        for image in cometExplosionImages {
            image.filteringMode = .nearest
        }
        
        for image in cometImages {
            image.filteringMode = .nearest
        }
        
        for image in blackHoleImages {
            image.filteringMode = .nearest
        }
        
        for image in rocketDestroyedImages {
            image.filteringMode = .nearest
        }
        
        switch UserDefaults.standard.integer(forKey: "nextLevel") {
        case 1: objectPickerMax = 6 // Level 1; asteroids only.
        case 2: objectPickerMax = 11 // Level 2; asteroids and comets.
        default: objectPickerMax = 12 // Level 3; asteroids, comets, and black holes.
        }
        
        motionEngine.accelerometerUpdateInterval = 1/60
        motionEngine.gyroUpdateInterval = 1/60
        
        motionEngine.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { [weak self] (data, error) -> Void in
            let xAxis = self?.motionEngine.accelerometerData?.acceleration.x ?? 0.0
            if self?.isSetup == true {
                self?.protagonist.physicsBody!.applyForce(CGVector(dx: (40 * xAxis) + (self?.forceModifier ?? 0), dy: 0))
            }
        })
        
        run(SKAction.run { [weak self] in
            
            self?.protagonist.size = CGSize(width: 72, height: 120)
            self?.protagonist.position = CGPoint(x: 50, y: 163 + (self?.bottomPadding ?? 0))
            self?.protagonist.zRotation = 0
            self?.protagonist.name = "Rocket"
            
            self?.protagonist.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 72, height: 120))
            self?.protagonist.physicsBody?.isDynamic = true
            self?.protagonist.physicsBody?.mass = 0.02
            self?.protagonist.physicsBody?.affectedByGravity = false
            self?.protagonist.physicsBody?.allowsRotation = false
            self?.protagonist.physicsBody?.contactTestBitMask = 1
            self?.protagonist.constraints = [SKConstraint.zRotation(SKRange(constantValue: 0)),
                                             SKConstraint.positionY(SKRange(constantValue: 163 + (self?.bottomPadding ?? 0))),
                                             SKConstraint.positionX(SKRange(lowerLimit: 1, upperLimit: (self?.deviceWidth ?? 0) - 1))]
            
            self?.physicsBody = SKPhysicsBody(edgeLoopFrom: self?.frame ?? CGRect())

            let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: self?.rocketImages ?? [SKTexture](), timePerFrame: 0.1))
            self?.protagonist.run(rocketAnimation)
            
            self?.addChild(self?.protagonist ?? SKSpriteNode())
            self?.isSetup = true
            
            if self?.level == 1 {
                self?.isTVOn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.displayTV(dialogue: "Ah, we've arrived. Let's begin.", speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                        self?.hideTV()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                            self?.displayTV(dialogue: "Steer your rocket with motion controls, and fire at asteroids by holding 'Hydrochloric Acid' at the bottom of your device.", speaker: "System")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                                self?.hideTV()
                                NotificationCenter.default.post(Notification(name: Notification.Name("startLevel")))
                                self?.run(SKAction.repeatForever(SKAction.sequence([
                                    SKAction.run { [weak self] in
                                        if self?.isRoundFinished == false {
                                            self?.pickObject()
                                        }
                                    },
                                    SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
                                
                                                                                                    
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                                    self?.displayTV(dialogue: "You can gain a life with every 10 objects you destroy, however you'll lose one if your ship gets hit.", speaker: "System")
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                                        self?.hideTV(complete: { [weak self] in
                                            self?.isTVOn = false
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if self?.level == 2 {
                self?.isTVOn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.displayTV(dialogue: "Destination set to the second star. Let's do this!", speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                        self?.hideTV()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                            self?.displayTV(dialogue: "Comets are present in this area. Melt them by holding 'Thermal Energy' at the bottom of your device.", speaker: "System")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                                self?.hideTV(complete: { [weak self] in
                                    self?.isTVOn = false
                                })
                                
                                NotificationCenter.default.post(Notification(name: Notification.Name("startLevel")))
                                self?.run(SKAction.repeatForever(SKAction.sequence([
                                    SKAction.run { [weak self] in
                                        if self?.isRoundFinished == false {
                                            self?.pickObject()
                                        }
                                    },
                                    SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
                            }
                        }
                    }
                }
            }
            
            if self?.level == 3 {
                self?.isTVOn = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.displayTV(dialogue: "This is the final stretch! You can do this!", speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                        self?.hideTV()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                            self?.displayTV(dialogue: "Black holes are present in this area. Prevent them from sucking you in by steering away from them!", speaker: "System")
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                                self?.hideTV(complete: { [weak self] in
                                    self?.isTVOn = false
                                })
                                
                                NotificationCenter.default.post(Notification(name: Notification.Name("startLevel")))
                                self?.run(SKAction.repeatForever(SKAction.sequence([
                                    SKAction.run { [weak self] in
                                        if self?.isRoundFinished == false {
                                            self?.pickObject()
                                        }
                                    },
                                    SKAction.wait(forDuration: 0.6, withRange: 0.4)])))
                            }
                        }
                    }
                }
            }
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var isCompatible = false
        var isEnemy = false
        var isBeam = false
        
        if contact.bodyB.node?.name == "Asteroid" || contact.bodyB.node?.name == "Comet" || contact.bodyB.node?.name == "Black Hole" {
            isEnemy = true
        }
        
        if contact.bodyA.node?.name == "Beam" || contact.bodyA.node?.name == "BeamTwo" {
            isBeam = true
        }
        
        if contact.bodyA.node?.name == "Beam" && contact.bodyB.node?.name == "Asteroid" {
            isCompatible = true
        }
        
        if contact.bodyA.node?.name == "BeamTwo" && contact.bodyB.node?.name == "Comet" {
            isCompatible = true
        }
        
        if isBeam && isEnemy && isCompatible {
            
            objectsHit += 1
            NotificationCenter.default.post(Notification(name: Notification.Name("asteroidHit")))
            
            if objectsHit.isMultiple(of: 10) {
                livesRemaining += 1
                NotificationCenter.default.post(Notification(name: Notification.Name("lifeModified")))
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            }
            
            if contact.bodyB.node?.name == "Asteroid" {
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: asteroidDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            } else {
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: cometDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            }
            
        }
        
        if contact.bodyA.node?.name == "Rocket" && isEnemy && healthEvents {
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                let tapticFeedback = UINotificationFeedbackGenerator()
                tapticFeedback.notificationOccurred(.error)
            }
            
            var explosion = SKSpriteNode()
            
            switch contact.bodyB.node?.name {
            case "Comet":
                
                explosion = SKSpriteNode(imageNamed: "Comet Explosion 1")
                explosion.size = CGSize(width: 60, height: 60)
                explosion.position = contact.contactPoint
                
                explosion.run(SKAction.sequence([
                    SKAction.animate(with: cometExplosionImages, timePerFrame: 1/30),
                    SKAction.removeFromParent()]))
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: cometDestroyedImages, timePerFrame: 1/30),
                    SKAction.removeFromParent()]))
                
                self.addChild(explosion)
                
            case "Asteroid":
                
                explosion = SKSpriteNode(imageNamed: "Explosion 1")
                explosion.size = CGSize(width: 60, height: 60)
                explosion.position = contact.contactPoint
                
                explosion.run(SKAction.sequence([
                    SKAction.animate(with: explosionImages, timePerFrame: 1/30),
                    SKAction.removeFromParent()]))
                
                contact.bodyB.node?.run(SKAction.sequence([SKAction.run {
                    contact.bodyB.node?.physicsBody = nil
                }, SKAction.animate(with: asteroidDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
                self.addChild(explosion)
                
            case "Black Hole":
                
                forceModifier = 0
                
                if forceModifier == -10 {
                    protagonist.run(SKAction.move(to: CGPoint(x: 150, y: 163 + bottomPadding), duration: 0))
                } else {
                    protagonist.run(SKAction.move(to: CGPoint(x: deviceWidth - protagonist.size.width - 150, y: 163 + bottomPadding), duration: 0))
                }
            
            default: break
            }
            
            livesRemaining -= 1
            NotificationCenter.default.post(Notification(name: Notification.Name("lifeModified")))
            
            healthEvents = false
            if livesRemaining > 0 {
                
                if !isTVOn {
                    isTVOn = true
                    displayTV(dialogue: pickHitDialogue(), speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        self?.hideTV(complete: { [weak self] in
                            self?.isTVOn = false
                        })
                    }
                }
                
                var timerCount = 0
                
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] timer in
                    if timerCount == 10 {
                        timer.invalidate()
                        self?.protagonist.isHidden = false
                        self?.healthEvents = true
                    } else {
                        if self?.protagonist.isHidden == true {
                            self?.protagonist.isHidden = false
                        } else {
                            self?.protagonist.isHidden = true
                        }
                        
                        timerCount += 1
                    }
                })
            } else {
                isRoundFinished = true
                motionEngine.stopAccelerometerUpdates()
                motionEngine.stopGyroUpdates()
                
                protagonist.run(SKAction.sequence([
                    SKAction.animate(with: rocketDestroyedImages, timePerFrame: 1/36),
                    SKAction.removeFromParent()]))
                
                if isTVOn {
                    hideTV(complete: { [weak self] in
                        self?.isTVOn = false
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        self?.displayTV(dialogue: self?.pickEliminatedDialogue() ?? "", speaker: "Scientist")
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        self?.hideTV()
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default.post(Notification(name: Notification.Name("restartLevel")))
                    }
                    }
                    }
                } else {
                    displayTV(dialogue: pickEliminatedDialogue(), speaker: "Scientist")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                        self?.hideTV()
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationCenter.default.post(Notification(name: Notification.Name("restartLevel")))
                    }
                    }
                }
                
            }
        }
    }
    
    func pickHitDialogue() -> String {
        let randomNumber = Int.random(in: 0 ..< 5)
        var livesText = "lives"
        
        if livesRemaining == 1 {
            livesText = "life"
        }
        
        switch randomNumber {
        case 0: return "Be careful! \(livesRemaining) \(livesText) remaining!"
        case 1: return "Don't be reckless! \(livesRemaining) \(livesText) left!"
        case 2: return "Hey, are you ok?! You have \(livesRemaining) \(livesText) left!"
        case 3: return "Uh-oh, is everything alright? \(livesRemaining) \(livesText) remaining."
        case 4: return "\(livesRemaining) \(livesText) remaining, break some stuff to get them back!"
        default: return ""
        }
        
    }
    
    func pickEliminatedDialogue() -> String {
        let randomNumber = Int.random(in: 0 ..< 5)
        
        switch randomNumber {
        case 0: return "We failed after all..."
        case 1: return "Hey! Are you there?!"
        case 2: return "No!..."
        case 3: return "It can't be..."
        case 4: return "Hello?! Do you read me?!"
        default: return ""
        }
    }
    
    @objc func finishLevel(_ notification: Notification) {
        print("LEVEL FINISHED")
        isRoundFinished = true
        motionEngine.stopAccelerometerUpdates()
        motionEngine.stopGyroUpdates()
        
        for child in self.children {
            
            if child.name == "Asteroid" {
                
                child.run(SKAction.sequence([SKAction.run {
                    child.physicsBody = nil
                }, SKAction.animate(with: asteroidDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            }
            
            if child.name == "Comet" {
                
                child.run(SKAction.sequence([SKAction.run {
                    child.physicsBody = nil
                }, SKAction.animate(with: cometDestroyedImages, timePerFrame: 1/33),
                    SKAction.removeFromParent()]))
                
            }
            
            if child.name == "Black Hole" {
                
                child.run(SKAction.sequence([SKAction.run {
                    child.physicsBody = nil
                }, SKAction.fadeAlpha(to: 0, duration: 0.33),
                    SKAction.removeFromParent()]))
                
            }
        }
        
        var dialogue = ""
        
        switch level {
        case 1: dialogue = "Nice work! Now to grab a sample of that star..."
        case 2: dialogue = "Great work! Let's grab that sample."
        case 3: dialogue = "All done! You know what to do from here."
        default: break
        }
        
        if isTVOn {
            hideTV(complete: { [weak self] in
                self?.isTVOn = false
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.displayTV(dialogue: dialogue, speaker: "Scientist")
            }
        } else {
            displayTV(dialogue: dialogue, speaker: "Scientist")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hideTV(complete: { [weak self] in
                self?.isTVOn = false
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: Notification.Name("switchViews"), object: nil)
            }
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
    
    func pickObject() {
        var randomNumber = 0
        
        if isAlreadyBlackHole {
            randomNumber = Int.random(in: 0 ..< (objectPickerMax - 1))
        } else {
            randomNumber = Int.random(in: 0 ..< objectPickerMax)
        }
        
        if 0...5 ~= randomNumber {
            addAsteroid()
        } else if 5...10 ~= randomNumber {
            addComet()
        } else {
            addBlackHole()
        }
    }
    
    func addAsteroid() {
        let texture = SKTexture(imageNamed: "Asteroid 1")
        texture.filteringMode = .nearest
        
        let asteroid = SKSpriteNode(texture: texture)
        
        asteroid.size = CGSize(width: 120, height: 104)
        asteroid.position = CGPoint(x: random(min: 0 + (asteroid.size.width / 2), max: deviceWidth - (asteroid.size.width / 2)), y: deviceHeight + 100)
        
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 96, height: 80))
        asteroid.physicsBody?.isDynamic = true
        asteroid.physicsBody?.affectedByGravity = false
        asteroid.physicsBody?.collisionBitMask = 0
        asteroid.physicsBody?.contactTestBitMask = 1
        asteroid.name = "Asteroid"
        
        self.addChild(asteroid)
        
        let actionMove = SKAction.move(to: CGPoint(x: random(min: 0 + (asteroid.size.width / 2), max: deviceWidth - (asteroid.size.width / 2)), y: 0), duration: TimeInterval(random(min: 2, max: 3)))
        asteroid.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
        
    }
    
    func addComet() {
        let texture = SKTexture(imageNamed: "Comet 1")
        texture.filteringMode = .nearest
        
        let comet = SKSpriteNode(texture: texture)
        
        comet.size = CGSize(width: 68, height: 128)
        comet.position = CGPoint(x: random(min: 0 + (comet.size.width / 2), max: deviceWidth - (comet.size.width / 2)), y: deviceHeight + 100)
        
        comet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 68, height: 128))
        comet.physicsBody?.isDynamic = true
        comet.physicsBody?.affectedByGravity = false
        comet.physicsBody?.collisionBitMask = 0
        comet.physicsBody?.contactTestBitMask = 1
        comet.name = "Comet"
        
        self.addChild(comet)
        
        let actionMove = SKAction.move(to: CGPoint(x: comet.position.x, y: 0), duration: TimeInterval(random(min: 2, max: 3)))
        comet.run(SKAction.repeatForever(SKAction.animate(with: cometImages, timePerFrame: 0.1)))
        comet.run(SKAction.sequence([actionMove, SKAction.removeFromParent()]))
        
    }
    
    func addBlackHole() {
        isAlreadyBlackHole = true
        let texture = SKTexture(imageNamed: "Black Hole 1")
        texture.filteringMode = .nearest
        
        let blackHole = SKSpriteNode(texture: texture)
        let xPosition = randomBesides(min: 0 + (blackHole.size.width / 2), max: deviceWidth - (blackHole.size.width / 2), besidesMin: 100, besidesMax: deviceWidth - 100)
        
        if xPosition <= 100 {
            forceModifier = -10
        } else {
            forceModifier = 10
        }
        
        blackHole.size = CGSize(width: 116, height: 76)
        blackHole.position = CGPoint(x: xPosition, y: deviceHeight + 100)
        
        blackHole.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 52, height: 52))
        blackHole.physicsBody?.isDynamic = true
        blackHole.physicsBody?.affectedByGravity = false
        blackHole.physicsBody?.collisionBitMask = 0
        blackHole.physicsBody?.contactTestBitMask = 1
        blackHole.name = "Black Hole"
        
        self.addChild(blackHole)
        
        let actionMove = SKAction.move(to: CGPoint(x: blackHole.position.x, y: 0), duration: TimeInterval(random(min: 3, max: 4)))
        
        blackHole.run(SKAction.repeatForever(SKAction.animate(with: blackHoleImages, timePerFrame: 0.1)))
        
        blackHole.run(SKAction.sequence([actionMove, SKAction.removeFromParent(), SKAction.run { [weak self] in
            self?.forceModifier = 0
            self?.isAlreadyBlackHole = false
        }]))
    }
    
    @objc func fireLaser(_ notification: Notification) {
        let chargeUpView = SKSpriteNode(texture: greenChargeUpImages.first)
        
        chargeUpView.size = CGSize(width: 24, height: 18)
        chargeUpView.position = CGPoint(x: 0, y: 70)
        
        protagonist.addChild(chargeUpView)
        
        let chargeUpAnimation = SKAction.animate(with: greenChargeUpImages, timePerFrame: 1/24)
        
        chargeUpView.run(SKAction.sequence([chargeUpAnimation, SKAction.removeFromParent(), SKAction.run { [weak self] in
            self?.createLaser(element: (notification.userInfo?["element"] as? Int) ?? 1)
        }]))
        
    }
    
    func createLaser(element: Int) {
        var colour = UIColor()
        var name = "Beam"
        protagonist.addChild(beam)
        
        switch element {
        case 1: colour = .green
                name = "Beam"
        case 2: colour = .orange
                name = "BeamTwo"
        default: break
        }
        
        let beamHeight = (deviceHeight - 240) - (topPadding + bottomPadding)
        let beamPath = UIBezierPath(rect: CGRect(x: 0, y: 70, width: 2, height: beamHeight)).cgPath
        
        beam.path = beamPath
        beam.lineWidth = 6
        beam.strokeColor = colour
        
        beam.name = name
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
            SKAction.run { [weak self] in
                for particle in particles {
                    particle.position = CGPoint(x: self?.randomBesides(min: -20, max: 22, besidesMin: -10, besidesMax: 12) ?? 0, y: self?.random(min: 70, max: beamHeight) ?? 0)
                }
            },
            SKAction.wait(forDuration: 0.4)])))
    }
    
    @objc func endLaser(_ notification: Notification) {
        beam.removeAllChildren()
        protagonist.removeAllChildren()
        isBeamActive = false
    }
    
}
