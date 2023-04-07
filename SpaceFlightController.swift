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
        
        for image in rocketImages {
            image.filteringMode = .nearest
        }
        
        motionEngine.accelerometerUpdateInterval = 1/60
        motionEngine.gyroUpdateInterval = 1/60
        
        motionEngine.startAccelerometerUpdates()
        run(SKAction.run { [self] in
            
            protagonist.size = CGSize(width: 72, height: 120)
            protagonist.zPosition = 1
            protagonist.position = CGPoint(x: 50, y: 90)

            let rocketAnimation = SKAction.repeatForever(SKAction.animate(with: rocketImages, timePerFrame: 0.1))
            protagonist.run(rocketAnimation)
            
            self.addChild(protagonist)
            
        })
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        processUserMotion(forUpdate: currentTime)
    }
    
    func processUserMotion(forUpdate currentTime: CFTimeInterval) {
        let xAxis = motionEngine.accelerometerData?.acceleration.x ?? 0.0
        let xAxisAdjusted = (xAxis + 1) / 2
        let screenWidth = UIScreen.main.bounds.width

        protagonist.position = CGPoint(x: CGFloat(xAxisAdjusted * screenWidth), y: 90)
        
        print(xAxis as Any)
    }
    
    
}

class Rocket: SKSpriteNode {
    
}
