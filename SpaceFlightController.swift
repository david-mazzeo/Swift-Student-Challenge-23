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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        spriteKitView.presentScene(FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
        
    }
    
}

class FlightScene: SKScene {
    
    var isSetup = false
    let motionEngine = CMMotionManager()
    let rocketImages = [SKTexture(image: UIImage(named: "Rocket 1")!),
                        SKTexture(image: UIImage(named: "Rocket 2")!),
                        SKTexture(image: UIImage(named: "Rocket 3")!),
                        SKTexture(image: UIImage(named: "Rocket 4")!),
                        SKTexture(image: UIImage(named: "Rocket 3A")!),
                        SKTexture(image: UIImage(named: "Rocket 5")!),
                        SKTexture(image: UIImage(named: "Rocket 6")!)]
    
    let protagonist = Rocket(imageNamed: "Rocket 1.png")
    
    override func didMove(to view: SKView) {
        
        self.view?.ignoresSiblingOrder = true
        self.view?.scene?.shouldRasterize = true
        self.view?.showsFPS = true
        self.view?.showsNodeCount = true
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        motionEngine.accelerometerUpdateInterval = 1/60
        motionEngine.gyroUpdateInterval = 1/60
        
        motionEngine.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { [self] (data, error) -> Void in
            let xAxis = motionEngine.accelerometerData?.acceleration.x ?? 0.0
    //        if xAxis >= 0.2 || xAxis <= -0.2 {
            if isSetup {
                protagonist.physicsBody!.applyForce(CGVector(dx: 40 * xAxis, dy: 0))
            }
                
                print(xAxis as Any)
    //        }
        })
        
        run(SKAction.run { [self] in
            
            protagonist.size = CGSize(width: 72, height: 120)
            protagonist.position = CGPoint(x: 50, y: 90)
            protagonist.zRotation = 0
            
            protagonist.physicsBody = SKPhysicsBody(rectangleOf: protagonist.size)
            protagonist.physicsBody?.isDynamic = true
            protagonist.physicsBody?.mass = 0.02
            protagonist.physicsBody?.affectedByGravity = false
            protagonist.physicsBody?.allowsRotation = false
            protagonist.constraints = [SKConstraint.zRotation(SKRange(lowerLimit: 0, upperLimit: 0))]
            
            self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)

            let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
            protagonist.run(rocketAnimation)
            
            self.addChild(protagonist)
            isSetup = true
            
        })
        
    }
    
}

class Rocket: SKSpriteNode {
    
}
