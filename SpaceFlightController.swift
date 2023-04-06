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
    
    @IBOutlet weak var rocketView: UIImageView!
    let motionEngine = CMMotionManager()
    var previousRotation: Double = 0
    
    let rocketImages = [UIImage(named: "Rocket 1")!,
                        UIImage(named: "Rocket 2")!,
                        UIImage(named: "Rocket 3")!,
                        UIImage(named: "Rocket 3A")!,
                        UIImage(named: "Rocket 4")!,
                        UIImage(named: "Rocket 5")!,
                        UIImage(named: "Rocket 6")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rocketView.layer.magnificationFilter = .nearest
        rocketView.animationImages = rocketImages
        rocketView.animationDuration = 1
        rocketView.animationRepeatCount = 0
        rocketView.startAnimating()
        
        motionEngine.accelerometerUpdateInterval = 1/60
        motionEngine.gyroUpdateInterval = 1/60
        
        motionEngine.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { [self] (data, error) -> Void in
            
            let xAxis = data?.acceleration.x ?? 0.0
            if isAboveThreshold(nextRotation: xAxis) {
                
                let xAxisAdjusted = (xAxis + 1) / 2
                let screenWidth = UIScreen.main.bounds.width
                let imageWidth = rocketView.bounds.width / 2
                
                rocketView.transform = CGAffineTransform(translationX: CGFloat(xAxisAdjusted * screenWidth) - imageWidth, y: 0)
            }
            
            print(xAxis as Any)
            
        })
        
    }
    
    func isAboveThreshold(nextRotation: Double) -> Bool {
        let ratio = previousRotation - nextRotation
        
        if ratio >= 0.1 || ratio <= -0.1 {
            previousRotation = nextRotation
            return true
        } else {
            return false
        }
    }
    
}
