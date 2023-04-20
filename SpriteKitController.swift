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
var wasLandscape = false
var objectPicker = SKAction()
var orientation = UIInterfaceOrientation.portrait

class SpaceFlightController: UIViewController {
    
    let gradient = CAGradientLayer()
    
    var animationTimer = Timer()
    var durationTimer = Timer()
    
    var currentView = "Game"
    var percentElapsed = 0
    
    var isFirstPlay = true
    var isEliminated = false
    var isAlreadySwitching = false
    var isBackgroundAnimating = false
    
    var backgroundAlpha = CGFloat(1)
    let HUDAttributes = AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
    
    var waitingToPresent = false
    var waitingScene = 0
    
    var backgroundView = UIView()
    var spriteKitView = SKView()
    
    var elementOneButton = UIButton()
    var elementTwoButton = UIButton()
    
    var bottomBackgroundConstraint = NSLayoutConstraint()
    
    var livesButton = UIButton()
    var destroyedButton = UIButton()
    var elapsedButton = UIButton()
    
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    var rotateLabel = UILabel()
    
    @objc func elementOneFire() {
        elementTwoButton.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("fire"), object: nil, userInfo: ["element": 1])
    }
    
    @objc func elementOneReleased() {
        elementTwoButton.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("released"), object: nil)
    }
    
    @objc func elementTwoFire() {
        elementOneButton.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("fire"), object: nil, userInfo: ["element": 2])
    }
    
    @objc func elementTwoReleased() {
        elementOneButton.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("released"), object: nil)
    }
    
    @objc func leftPressed() {
        rightButton.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("applyForce"), object: nil, userInfo: ["direction": "left"])
    }
    
    @objc func rightPressed() {
        leftButton.isEnabled = false
        NotificationCenter.default.post(name: Notification.Name("applyForce"), object: nil, userInfo: ["direction": "right"])
    }
    
    @objc func leftReleased() {
        rightButton.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("releaseForce"), object: nil)
    }
    
    @objc func rightReleased() {
        leftButton.isEnabled = true
        NotificationCenter.default.post(name: Notification.Name("releaseForce"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("switchViews"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("asteroidHit"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("lifeModified"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("startLevel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("restartLevel"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("endGame"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch UserDefaults.standard.string(forKey: "background") {
        case "dim": backgroundAlpha = 0.5
        case "off": backgroundAlpha = 0
        default: backgroundAlpha = 1
        }
        
        backgroundView.alpha = backgroundAlpha
        
        orientation = UIInterfaceOrientation(rawValue: (UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.windowScene?.interfaceOrientation.rawValue ?? 0))!
        
        view.backgroundColor = .black
        
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
        let topPadding = (window?.safeAreaInsets.top ?? 0)
        
        gradient.frame = CGRect(x: 0, y: -topPadding, width: view.bounds.width, height: view.bounds.height + topPadding)
        gradient.colors = [UIColor.black.cgColor, UIColor.init(red: 0, green: 27/255, blue: 54/255, alpha: 1).cgColor]

        self.view.layer.insertSublayer(gradient, at: 0)
        
        self.backgroundView.backgroundColor = UIColor(patternImage: UIImage(named: "Space Pattern")!)
        
        let buttonTitleAttributes = AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)])
        
        var livesConfig = UIButton.Configuration.tinted()
        livesConfig.attributedTitle = AttributedString("3", attributes: buttonTitleAttributes)
        livesConfig.subtitle = "lives left"
        livesConfig.baseForegroundColor = .systemRed
        livesConfig.baseBackgroundColor = .systemRed
        livesConfig.cornerStyle = .capsule
        livesConfig.titleAlignment = .center
        livesConfig.titlePadding = -2
        
        var destroyedConfig = UIButton.Configuration.gray()
        destroyedConfig.attributedTitle = AttributedString("0", attributes: buttonTitleAttributes)
        destroyedConfig.subtitle = "destroyed"
        destroyedConfig.baseForegroundColor = .white
        destroyedConfig.cornerStyle = .capsule
        destroyedConfig.titleAlignment = .center
        destroyedConfig.titlePadding = -2
        
        var elapsedConfig = UIButton.Configuration.tinted()
        elapsedConfig.attributedTitle = AttributedString("0%", attributes: buttonTitleAttributes)
        elapsedConfig.subtitle = "complete"
        elapsedConfig.baseForegroundColor = .systemBlue
        elapsedConfig.baseBackgroundColor = .systemBlue
        elapsedConfig.cornerStyle = .capsule
        elapsedConfig.titleAlignment = .center
        elapsedConfig.titlePadding = -2
        
        var elementOneConfig = UIButton.Configuration.tinted()
        elementOneConfig.attributedTitle = AttributedString("Hydrochloric Acid", attributes: buttonTitleAttributes)
        elementOneConfig.baseForegroundColor = .systemGreen
        elementOneConfig.baseBackgroundColor = .systemGreen
        elementOneConfig.cornerStyle = .capsule
        elementOneConfig.titlePadding = -2
        
        var elementTwoConfig = UIButton.Configuration.tinted()
        elementTwoConfig.attributedTitle = AttributedString("Thermal Energy", attributes: buttonTitleAttributes)
        elementTwoConfig.baseForegroundColor = .systemOrange
        elementTwoConfig.baseBackgroundColor = .systemOrange
        elementTwoConfig.cornerStyle = .capsule
        elementTwoConfig.titlePadding = -2
        
        var leftConfig = UIButton.Configuration.tinted()
        leftConfig.image = UIImage(systemName: "chevron.left.2")
        leftConfig.baseForegroundColor = .systemPurple
        leftConfig.baseBackgroundColor = .systemPurple
        leftConfig.cornerStyle = .capsule
        
        var rightConfig = UIButton.Configuration.tinted()
        rightConfig.image = UIImage(systemName: "chevron.right.2")
        rightConfig.baseForegroundColor = .systemIndigo
        rightConfig.baseBackgroundColor = .systemIndigo
        rightConfig.cornerStyle = .capsule
        
        elementOneButton.addTarget(self, action: #selector(elementOneFire), for: .touchDown)
        elementOneButton.addTarget(self, action: #selector(elementOneReleased), for: .touchUpInside)
        elementOneButton.addTarget(self, action: #selector(elementOneReleased), for: .touchDragExit)
        
        elementTwoButton.addTarget(self, action: #selector(elementTwoFire), for: .touchDown)
        elementTwoButton.addTarget(self, action: #selector(elementTwoReleased), for: .touchUpInside)
        elementTwoButton.addTarget(self, action: #selector(elementTwoReleased), for: .touchDragExit)
        
        leftButton.addTarget(self, action: #selector(leftPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(leftReleased), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftReleased), for: .touchDragExit)
        
        rightButton.addTarget(self, action: #selector(rightPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(rightReleased), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightReleased), for: .touchDragExit)
        
        livesButton.configuration = livesConfig
        destroyedButton.configuration = destroyedConfig
        elapsedButton.configuration = elapsedConfig
        elementOneButton.configuration = elementOneConfig
        elementTwoButton.configuration = elementTwoConfig
        leftButton.configuration = leftConfig
        rightButton.configuration = rightConfig
        
        rotateLabel.text = "Please rotate your device to portrait mode."
        rotateLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        rotateLabel.textColor = .white
        rotateLabel.textAlignment = .center
        
        view.addSubview(backgroundView)
        view.addSubview(livesButton)
        view.addSubview(destroyedButton)
        view.addSubview(elapsedButton)
        view.addSubview(elementOneButton)
        view.addSubview(elementTwoButton)
        view.addSubview(rotateLabel)
        
        livesButton.translatesAutoresizingMaskIntoConstraints = false
        destroyedButton.translatesAutoresizingMaskIntoConstraints = false
        elapsedButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        elementOneButton.translatesAutoresizingMaskIntoConstraints = false
        elementTwoButton.translatesAutoresizingMaskIntoConstraints = false
        rotateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        livesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        livesButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        livesButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        livesButton.rightAnchor.constraint(equalTo: destroyedButton.leftAnchor, constant: -15).isActive = true
        livesButton.widthAnchor.constraint(equalTo: destroyedButton.widthAnchor, multiplier: 1).isActive = true
        livesButton.widthAnchor.constraint(equalTo: elapsedButton.widthAnchor, multiplier: 1).isActive = true
        
        destroyedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        destroyedButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        destroyedButton.rightAnchor.constraint(equalTo: elapsedButton.leftAnchor, constant: -15).isActive = true
        destroyedButton.widthAnchor.constraint(equalTo: livesButton.widthAnchor, multiplier: 1).isActive = true
        destroyedButton.widthAnchor.constraint(equalTo: elapsedButton.widthAnchor, multiplier: 1).isActive = true
        
        elapsedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        elapsedButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        elapsedButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        elapsedButton.widthAnchor.constraint(equalTo: livesButton.widthAnchor, multiplier: 1).isActive = true
        elapsedButton.widthAnchor.constraint(equalTo: destroyedButton.widthAnchor, multiplier: 1).isActive = true
        
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        bottomBackgroundConstraint = backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)
        bottomBackgroundConstraint.isActive = true
        
        elementOneButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        elementOneButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
        elementOneButton.rightAnchor.constraint(equalTo: elementTwoButton.leftAnchor, constant: -10).isActive = true
        elementOneButton.widthAnchor.constraint(equalTo: elementTwoButton.widthAnchor, multiplier: 1).isActive = true
        
        elementTwoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        elementTwoButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
        elementTwoButton.widthAnchor.constraint(equalTo: elementOneButton.widthAnchor, multiplier: 1).isActive = true
        
        if UserDefaults.standard.string(forKey: "controls") == "buttons" {
            view.addSubview(leftButton)
            view.addSubview(rightButton)
            
            leftButton.translatesAutoresizingMaskIntoConstraints = false
            rightButton.translatesAutoresizingMaskIntoConstraints = false
            
            leftButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
            leftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
            leftButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
            leftButton.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: -10).isActive = true
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor, multiplier: 1).isActive = true
            
            rightButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
            rightButton.heightAnchor.constraint(equalToConstant: 57).isActive = true
            rightButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
            rightButton.widthAnchor.constraint(equalTo: leftButton.widthAnchor, multiplier: 1).isActive = true
            
            elementOneButton.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: -16).isActive = true
            elementTwoButton.bottomAnchor.constraint(equalTo: rightButton.topAnchor, constant: -16).isActive = true
            
        } else {
            elementOneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
            elementTwoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        }
        
        rotateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rotateLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rotateLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rotateLabel.isHidden = true
        
        rotationCheck(isViewInitialising: true, sceneID: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViews(_:)), name: Notification.Name("switchViews"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hitObject(_:)), name: Notification.Name("asteroidHit"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lifeLost(_:)), name: Notification.Name("lifeModified"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startLevel(_:)), name: Notification.Name("startLevel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(restartLevel(_:)), name: Notification.Name("restartLevel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endGame(_:)), name: Notification.Name("endGame"), object: nil)
        
    }
    
    func animateBackground() {
        bottomBackgroundConstraint.constant = 444
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { [self] timer in
            backgroundView.transform = CGAffineTransform(translationX: 0, y: -444)
            UIView.animate(withDuration: 10, delay: 0, options: [.curveLinear], animations: { [self] in
                backgroundView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        })
        
        animationTimer.fire()
    }
    
    @objc func endGame(_ notification: Notification) {
        self.dismiss(animated: false)
    }
    
    @objc func restartLevel(_ notification: Notification) {
        durationTimer.invalidate()
        UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
            hideElements()
            
        }, completion: { [self] (finished: Bool) in
            backgroundView.layer.removeAllAnimations()
            isBackgroundAnimating = false
            cleanSK()
            
            spriteKitView.alpha = 0
            rotationCheck(isViewInitialising: true, sceneID: 1)
            
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
                displayElements()
            })
        })
    }
    
    @objc func switchViews(_ notification: Notification) {
        if !isEliminated && !isAlreadySwitching {
            isAlreadySwitching = true
            UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
                hideElements()
                
            }, completion: { [self] (finished: Bool) in
                backgroundView.layer.removeAllAnimations()
                cleanSK()
                
                spriteKitView.alpha = 0
                
                var scene = 0
                
                if currentView == "Game" {
                    scene = 2
                    currentView = "Sample"
                } else if UserDefaults.standard.integer(forKey: "nextLevel") == 4 {
                    scene = 3
                    currentView = "Encounter"
                } else {
                    scene = 1
                    currentView = "Game"
                }
                
                rotationCheck(isViewInitialising: true, sceneID: scene)
                
                UIView.animate(withDuration: 1, delay: 0, options: [.curveLinear], animations: { [self] in
                    displayElements()
                }, completion: { [self] (finished: Bool) in
                    isAlreadySwitching = false
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
        
        leftButton.alpha = 0
        rightButton.alpha = 0
    }
    
    func displayElements() {
        backgroundView.alpha = backgroundAlpha
        spriteKitView.alpha = 1
        
        if currentView == "Game" {
            elementOneButton.alpha = 1
            elementTwoButton.alpha = 1
            
            livesButton.alpha = 1
            destroyedButton.alpha = 1
            elapsedButton.alpha = 1
            
            leftButton.alpha = 1
            rightButton.alpha = 1
        }
    }
    
    func cleanSK() {
        elapsedButton.configuration?.attributedTitle = AttributedString("0%", attributes: HUDAttributes)
        destroyedButton.configuration?.attributedTitle = AttributedString("0", attributes: HUDAttributes)
        livesButton.configuration?.attributedTitle = AttributedString("3", attributes: HUDAttributes)
        
        objectPicker = SKAction()
        animationTimer.invalidate()
        isBackgroundAnimating = false
        durationTimer.invalidate()
        percentElapsed = 0
        
        objectsHit = 0
        livesRemaining = 3
        
        isEliminated = false
        
        spriteKitView.scene?.removeAllActions()
        spriteKitView.scene?.removeAllChildren()
        spriteKitView.scene?.removeFromParent()
        spriteKitView.presentScene(nil)
        spriteKitView.removeFromSuperview()
    }
    
    func initSK() {
        spriteKitView = SKView()
        spriteKitView.preferredFramesPerSecond = UIScreen.main.maximumFramesPerSecond
        
        self.view.insertSubview(spriteKitView, at: 2)
        
        spriteKitView.translatesAutoresizingMaskIntoConstraints = false
        
        spriteKitView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spriteKitView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spriteKitView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spriteKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        if !isFirstPlay || currentView == "Sample" {
            spriteKitView.alpha = 0
        } else if isFirstPlay {
            isFirstPlay = false
        }
    }
    
    @objc func startLevel(_ notification: Notification) {
        animateBackground()
        isBackgroundAnimating = true
        
        var duration = Double(0)
        
        switch UserDefaults.standard.integer(forKey: "nextLevel") {
        case 1: duration = 15
        case 2: duration = 20
        case 3: duration = 30
        default: break
        }
        
        durationTimer = Timer.scheduledTimer(withTimeInterval: duration/100, repeats: true, block: { [self] timer in
            if !spriteKitView.isPaused {
                percentElapsed += 1
                elapsedButton.configuration?.attributedTitle = AttributedString("\(String(percentElapsed))%", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
                
                if percentElapsed >= 100 {
                    NotificationCenter.default.post(name: NSNotification.Name("finishLevel"), object: nil)
                    timer.invalidate()
                }
            }
        })
    }
    
    @objc func hitObject(_ notification: Notification) {
        destroyedButton.configuration?.attributedTitle = AttributedString(String(objectsHit), attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
    }
    
    @objc func lifeLost(_ notification: Notification) {
        if livesRemaining == 0 {
            objectPicker = SKAction()
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
        
        if livesRemaining == 1 {
            livesButton.configuration?.subtitle = "life left"
        } else {
            livesButton.configuration?.subtitle = "lives left"
        }
        
        livesButton.configuration?.attributedTitle = AttributedString(String(livesRemaining), attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 18, weight: .bold)]))
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        
        spriteKitView.scene?.removeAction(forKey: "objectPicker")
        spriteKitView.isPaused = true
        objectPicker.speed = 0
        
        if let cutscene = spriteKitView.scene?.action(forKey: "encounterDialogue") {
            cutscene.speed = 0
        }
        
        animationTimer.invalidate()
        backgroundView.layer.removeAllAnimations()
        backgroundView.transform = CGAffineTransformIdentity
        
        NotificationCenter.default.post(name: NSNotification.Name("released"), object: nil)
        
        elementOneButton.isEnabled = true
        elementTwoButton.isEnabled = true
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        
        if objectPicker != SKAction() {
            spriteKitView.scene?.run(objectPicker, withKey: "objectPicker")
        }
        
        if let cutscene = spriteKitView.scene?.action(forKey: "encounterDialogue") {
            cutscene.speed = 1
        }
        
        if isBackgroundAnimating {
            animateBackground()
        }
        
        spriteKitView.isPaused = false
        objectPicker.speed = 1
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom]
    }
    
    override func viewDidLayoutSubviews() {
        gradient.frame = CGRect(x: 0, y: -50, width: view.frame.width, height: view.frame.height + 100)
        
        if waitingToPresent {
            rotationCheck()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        orientation = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.windowScene?.interfaceOrientation ?? .portrait
        
        if !waitingToPresent {
            rotationCheck()
        }
    }
    
    func rotationCheck(isViewInitialising: Bool = false, sceneID: Int = 0) {
        // ID System
        // 0 = No Scene
        // 1 = Flight Scene
        // 2 = Sample Scene
        // 3 = Encounter Scene
        
        if orientation.isLandscape {
            spriteKitView.isPaused = true
            spriteKitView.isHidden = true
            
            rotateLabel.isHidden = false
            
            backgroundView.isHidden = true
            livesButton.isHidden = true
            destroyedButton.isHidden = true
            elapsedButton.isHidden = true
            elementOneButton.isHidden = true
            elementTwoButton.isHidden = true
            leftButton.isHidden = true
            rightButton.isHidden = true
            
            if isViewInitialising {
                waitingToPresent = true
                waitingScene = sceneID
            }
            
        } else {
            spriteKitView.isPaused = false
            spriteKitView.isHidden = false
            
            rotateLabel.isHidden = true
            
            backgroundView.isHidden = false
            livesButton.isHidden = false
            destroyedButton.isHidden = false
            elapsedButton.isHidden = false
            elementOneButton.isHidden = false
            elementTwoButton.isHidden = false
            
            if UserDefaults.standard.string(forKey: "controls") == "buttons" {
                leftButton.isHidden = false
                rightButton.isHidden = false
            }
            
            var sceneToPresent = SKScene()
            
            if isViewInitialising {
                
                switch sceneID {
                case 1: sceneToPresent = FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                case 2: sceneToPresent = StarSampleScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                case 3: sceneToPresent = EncounterScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                default: break
                }
                
                wasLandscape = false
                initSK()
                spriteKitView.presentScene(sceneToPresent)
            }
            
            if waitingToPresent {
                
                switch waitingScene {
                case 1: sceneToPresent = FlightScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                case 2: sceneToPresent = StarSampleScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                case 3: sceneToPresent = EncounterScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                default: break
                }
                
                wasLandscape = true
                initSK()
                spriteKitView.presentScene(sceneToPresent)
                
                waitingToPresent = false
                waitingScene = 0
            }
        }
    }
    
}
