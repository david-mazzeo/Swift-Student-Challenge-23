//
//  SpaceFlightController.swift
//  Constellation Explorer
//
//  Created by David Mazzeo on 6/4/2023.
//

import UIKit
import SpriteKit

var objectsHit = 0
var livesRemaining = 3

class SpaceFlightController: UIViewController {
    
    let gradient = CAGradientLayer()
    var animationTimer = Timer()
    var durationTimer = Timer()
    var currentView = "Game"
    var isEliminated = false
    let HUDAttributes = AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
    
    @IBOutlet weak var backgroundView: UIView!
    var spriteKitView = SKView()
    
    @IBOutlet weak var elementOneButton: UIButton!
    @IBOutlet weak var elementTwoButton: UIButton!
    
    @IBOutlet weak var bottomBackgroundConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var livesButton: UIButton!
    @IBOutlet weak var destroyedButton: UIButton!
    @IBOutlet weak var elapsedButton: UIButton!
    
    @IBAction func elementOneFire(_ sender: Any) {
        elementTwoButton.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("fire"), object: nil, userInfo: ["element": 1])
    }
    
    @IBAction func elementOneReleased(_ sender: Any) {
        elementTwoButton.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("released"), object: nil)
    }
    
    @IBAction func elementTwoFire(_ sender: Any) {
        elementOneButton.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("fire"), object: nil, userInfo: ["element": 2])
    }
    
    @IBAction func elementTwoReleased(_ sender: Any) {
        elementOneButton.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("released"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("switchViews"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("asteroidHit"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("lifeModified"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("startLevel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("restartLevel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
        let topPadding = (window?.safeAreaInsets.top ?? 0)
        
        gradient.frame = CGRect(x: 0, y: -topPadding, width: view.bounds.width, height: view.bounds.height + topPadding)
        gradient.colors = [UIColor.black.cgColor, UIColor.init(red: 0, green: 27/255, blue: 54/255, alpha: 1).cgColor]

        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "Space Pattern")!)
        
        initSK()
        spriteKitView.presentScene(FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViews(_:)), name: Notification.Name("switchViews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hitObject(_:)), name: Notification.Name("asteroidHit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lifeLost(_:)), name: Notification.Name("lifeModified"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startLevel(_:)), name: Notification.Name("startLevel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartLevel(_:)), name: Notification.Name("restartLevel"), object: nil)
        
    }
    
    func animateBackground() {
        let patternHeight = -(444 * UIScreen.main.scale)
        bottomBackgroundConstraint.constant = patternHeight
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { [self] timer in
            backgroundView.transform = CGAffineTransform(translationX: 0, y: patternHeight)
            UIView.animate(withDuration: 30, delay: 0, options: [.curveLinear], animations: { [self] in
                backgroundView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        })
        
        animationTimer.fire()
    }
    
    @objc func restartLevel(_ notification: Notification) {
        durationTimer.invalidate()
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
            hideElements()
            
        }, completion: { [self] (finished: Bool) in
            backgroundView.layer.removeAllAnimations()
            cleanSK()
            
            initSK()
            spriteKitView.alpha = 0
            spriteKitView.presentScene(FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
                displayElements()
            })
        })
    }
    
    @objc func switchViews(_ notification: Notification) {
        print("Switched")
        if !isEliminated {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
                hideElements()
                
            }, completion: { [self] (finished: Bool) in
                backgroundView.layer.removeAllAnimations()
                cleanSK()
                
                initSK()
                spriteKitView.alpha = 0
                
                if currentView == "Game" {
                    spriteKitView.presentScene(StarSampleScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
                    currentView = "Sample"
                } else {
                    spriteKitView.presentScene(FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
                    currentView = "Game"
                }
                
                UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
                    displayElements()
                })
            })
        }
    }
    
    func hideElements() {
        spriteKitView.alpha = 0
        
        backgroundView.alpha = 0
        
        elementOneButton.alpha = 0
        elementTwoButton.alpha = 0
        
        livesButton.alpha = 0
        destroyedButton.alpha = 0
        elapsedButton.alpha = 0
    }
    
    func displayElements() {
        backgroundView.alpha = 1
        spriteKitView.alpha = 1
        
        if currentView == "Game" {
            elementOneButton.alpha = 1
            elementTwoButton.alpha = 1
            
            livesButton.alpha = 1
            destroyedButton.alpha = 1
            elapsedButton.alpha = 1
        }
    }
    
    func cleanSK() {
        elapsedButton.configuration?.attributedTitle = AttributedString("0%", attributes: HUDAttributes)
        destroyedButton.configuration?.attributedTitle = AttributedString("0", attributes: HUDAttributes)
        livesButton.configuration?.attributedTitle = AttributedString("3", attributes: HUDAttributes)
        
        animationTimer.invalidate()
        
        objectsHit = 0
        livesRemaining = 3
        
        spriteKitView.scene?.removeAllActions()
        spriteKitView.scene?.removeAllChildren()
        spriteKitView.scene?.removeFromParent()
        spriteKitView.presentScene(nil)
        spriteKitView.removeFromSuperview()
    }
    
    func initSK() {
        spriteKitView = SKView(frame: CGRect(x: 0, y: -100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 200))
        self.view.insertSubview(spriteKitView, at: 2)
    }
    
    @objc func startLevel(_ notification: Notification) {
        animateBackground()
        
        var duration = Double(0)
        
        switch UserDefaults.standard.integer(forKey: "nextLevel") {
        case 1: duration = 15
        case 2: duration = 20
        case 3: duration = 30
        default: break
        }
        
        isEliminated = false
        var percentElapsed = 0
        
        durationTimer = Timer.scheduledTimer(withTimeInterval: duration/100, repeats: true, block: { [self] timer in
            percentElapsed += 1
            elapsedButton.configuration?.attributedTitle = AttributedString("\(String(percentElapsed))%", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
            
            if percentElapsed >= 100 {
                NotificationCenter.default.post(name: NSNotification.Name("finishLevel"), object: nil)
                animationTimer.invalidate()
                timer.invalidate()
            }
        })
    }
    
    @objc func hitObject(_ notification: Notification) {
        destroyedButton.configuration?.attributedTitle = AttributedString(String(objectsHit), attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
    }
    
    @objc func lifeLost(_ notification: Notification) {
        if livesRemaining == 0 {
            durationTimer.invalidate()
            isEliminated = true
            
            var count = 0
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [self] timer in
                if count == 5 {
                    timer.invalidate()
                }
                
                livesButton.alpha = 0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [self] in
                    livesButton.alpha = 1
                }
                
                count += 1
            })
        }
        
        livesButton.configuration?.attributedTitle = AttributedString(String(livesRemaining), attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        NotificationCenter.default.post(name: NSNotification.Name("released"), object: nil)
        elementOneButton.isEnabled = true
        elementTwoButton.isEnabled = true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
}
