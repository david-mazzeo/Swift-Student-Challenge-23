import UIKit
import SpriteKit

enum Time {
    case Sunrise
    case Daytime
    case Evening
    case Night
}

class ViewController: UIViewController, CAAnimationDelegate {
    
    let gradient = CAGradientLayer()
    let continueAttributes = AttributeContainer([.font: UIFont.systemFont(ofSize: 30, weight: .bold)])
    var orientation = UIInterfaceOrientation.portrait
    
    var areAnimationsRunning = true
    var waitingToPresent = false
    var isListeningForOrientation = false
    
    var wordmark = UIImageView()
    
    var goButton = UIButton()
    var aboutButton = UIButton()
    
    var starView = UIView()
    var cloudView = UIView()
    var cloudOne = UIImageView()
    var cloudTwo = UIImageView()
    
    var textWidthConstraint = NSLayoutConstraint()
    var textHeightConstraint = NSLayoutConstraint()
    
    var tvScreen = UIImageView()
    var continueButton = UIButton()
    var dialogueView = UITextView()
    
    var settingsLabel = UILabel()
    var settingsDescription = UILabel()
    
    var motionLabel = UILabel()
    var motionSwitch = UISegmentedControl(items: ["Motion", "Buttons"])
    
    var backgroundLabel = UILabel()
    var backgroundSwitch = UISegmentedControl(items: ["On", "Dim", "Off"])
    
    var spriteKitView = SKView()
    var rotateLabel = UILabel()
    
    var currentDialogueStage = 0
    
    let wordmarkImages = [UIImage(named: "Wordmark 1.png")!,
                          UIImage(named: "Wordmark 2.png")!,
                          UIImage(named: "Wordmark 3.png")!,
                          UIImage(named: "Wordmark 4.png")!,
                          UIImage(named: "Wordmark 5.png")!,
                          UIImage(named: "Wordmark 6.png")!,
                          UIImage(named: "Wordmark 7.png")!,
                          UIImage(named: "Wordmark 8.png")!]
    
    @objc func go() {
        
        UserDefaults.standard.set(1, forKey: "nextLevel")
        
        UIView.animate(withDuration: 1, animations: { [self] in
            goButton.alpha = 0
            aboutButton.alpha = 0
            wordmark.alpha = 0
        }, completion: { [self] (finished: Bool) in
            
            wordmark.stopAnimating()
            presentDialogueTV {
                
                UIView.animate(withDuration: 0.2, animations: { [self] in
                    dialogueView.alpha = 1
                    continueButton.alpha = 1
                }, completion: { [self] (finished: Bool) in
                    continueButton.isEnabled = false
                    dialogueView.characterByCharacter(string: """
                    You are a citizen of the planet Lunaro, home to a colony of humans who settled here recently. Although previously thriving, recent climate pollution — manifesting as a cloud of gases encasing the planet, blocking solar energy — has thrown the lives of millions into jeopardy.
                    """, complete: { [self] in
                        continueButton.isEnabled = true
                    })
                })
                
            }
            
        })
        
    }
    
    @objc func controlChanged(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0: UserDefaults.standard.set("motion", forKey: "controls")
        case 1: UserDefaults.standard.set("buttons", forKey: "controls")
        default: break
        }
    }
    
    @objc func backgroundChanged(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0: UserDefaults.standard.set("on", forKey: "background")
        case 1: UserDefaults.standard.set("dim", forKey: "background")
        case 2: UserDefaults.standard.set("off", forKey: "background")
        default: break
        }
    }
    
    func presentDialogueTV(complete: @escaping () -> Void) {
        
        var widthScale = CGFloat(0)
        var heightScale = CGFloat(0)
        let orientation = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.windowScene?.interfaceOrientation ?? .portrait
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            
            if orientation.isLandscape {
                heightScale = (UIScreen.main.bounds.width - 400) / 20
                widthScale = (UIScreen.main.bounds.height - 40) / 20
            } else {
                heightScale = (UIScreen.main.bounds.height - 400) / 20
                widthScale = (UIScreen.main.bounds.width - 40) / 20
            }
            
            textWidthConstraint.constant = (widthScale * 20) - 170
            textHeightConstraint.constant = (heightScale * 20) - 300
        } else {
            widthScale = (self.view.frame.width - 40) / 20
            heightScale = (self.view.frame.height - 100) / 20
            
            textWidthConstraint.constant = (widthScale * 20) - 80
            textHeightConstraint.constant = (heightScale * 20) - 200
        }
        
        if tvScreen.frame.size != CGSize(width: 20, height: 20) {
            tvScreen.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        tvScreen.isHidden = false
        
        UIView.animate(withDuration: 0.1, animations: { [self] in
            
            tvScreen.transform = CGAffineTransform(scaleX: widthScale, y: 1)
            
        }, completion: { [self] (finished: Bool) in

        UIView.animate(withDuration: 0.2, animations: { [self] in
            
            tvScreen.transform = CGAffineTransform(scaleX: widthScale, y: heightScale)
            
        }, completion: {_ in
            
            complete()
            
        }) })
    }
    
    @objc func continueDialogue() {
        switch currentDialogueStage {
        case 0:
            
            continueButton.isEnabled = false
            dialogueView.characterByCharacter(string: """
                    When disaster began to loom, however, a researcher discovered an Ancient Greek myth suggesting the existence of spirits living in the constellations. These findings were presented to the space administration, who begrudgingly approved a flight to the constellation of rebirth — the Phoenix — to acquire a "rebirth" of their home. Such a journey would drain the last of Lunaro's energy supply, making this an extremely high-stakes mission.
                    """, complete: { [self] in
                continueButton.isEnabled = true
            })
            
        case 1:
            
            continueButton.isEnabled = false
            dialogueView.characterByCharacter(string: """
                    You, a professional space traveller, have been entrusted to pilot this flight. To complete your goal, you need to venture to three of the constellation's stars and collect samples. When fused with each other, the researcher believes, these samples can summon the Phoenix.

                    Your craft is equipped with a set of mixtures that can each dissolve certain debris, which you must utilise combined with precision steering skills in order to protect you and your ship.
                    """, complete: { [self] in
                        continueButton.isEnabled = true
                    })
            
        case 2:
            
            continueButton.isEnabled = false
            continueButton.configuration?.attributedTitle = AttributedString("Start", attributes: continueAttributes)
            
            UIView.animate(withDuration: 1, animations: { [self] in
                
                dialogueView.alpha = 0
                
            }, completion: { [self]_ in
                
                UIView.animate(withDuration: 1, animations: { [self] in
                    
                    settingsLabel.alpha = 1
                    settingsDescription.alpha = 1
                    motionLabel.alpha = 1
                    motionSwitch.alpha = 1
                    backgroundLabel.alpha = 1
                    backgroundSwitch.alpha = 1
                    
                }, completion: { [self]_ in
                    
                    continueButton.isEnabled = true
                    backgroundSwitch.isEnabled = true
                    motionSwitch.isEnabled = true
                    
                })
            })
            
        case 3:
            
            let vc = SpaceFlightController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                continueButton.isEnabled = false
                backgroundSwitch.isEnabled = false
                motionSwitch.isEnabled = false
                continueButton.configuration?.attributedTitle = AttributedString("Continue", attributes: continueAttributes)
                
                view.layer.removeAllAnimations()
                gradient.removeAllAnimations()
                cloudView.layer.removeAllAnimations()
                self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
                dialogueView.text = ""
                areAnimationsRunning = false
            }
            
            currentDialogueStage = -1
            
        default: break
        }
        
        currentDialogueStage += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segmentColor = UIColor.init(red: 140/255, green: 1, blue: 171/255, alpha: 1)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            dialogueView.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        }
        
        spriteKitView.isHidden = true
        continueButton.isEnabled = false
        continueButton.alpha = 0
        dialogueView.alpha = 0
        
        starView.backgroundColor = .clear
        cloudView.backgroundColor = .clear
        
        wordmark.contentMode = .center
        wordmark.layer.magnificationFilter = .nearest
        wordmark.animationImages = wordmarkImages
        wordmark.animationDuration = 1
        wordmark.startAnimating()
        
        dialogueView.isEditable = false
        dialogueView.isSelectable = false
        dialogueView.textColor = .green
        dialogueView.backgroundColor = .clear
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            dialogueView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        } else {
            dialogueView.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        }
        
        cloudOne.image = UIImage(named: "Day Clouds")
        cloudTwo.image = UIImage(named: "Day Clouds")
        
        tvScreen.isHidden = true
        tvScreen.image = UIImage(named: "Tall CRT Shape")
        
        settingsLabel.text = "Accessibility"
        settingsLabel.textColor = .green
        settingsLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        settingsLabel.textAlignment = .center
        settingsLabel.alpha = 0
        
        settingsDescription.text = "The space administration has designed their fleet with accessibility in mind. Please adjust these preferences to your needs."
        settingsDescription.textColor = .green
        settingsDescription.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        settingsDescription.textAlignment = .center
        settingsDescription.numberOfLines = 0
        settingsDescription.alpha = 0
        
        motionLabel.text = "Steer with..."
        motionLabel.textColor = .green
        motionLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        motionLabel.textAlignment = .left
        motionLabel.numberOfLines = 0
        motionLabel.alpha = 0
        
        motionSwitch.selectedSegmentTintColor = segmentColor
        motionSwitch.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        motionSwitch.addTarget(self, action: #selector(controlChanged(_:)), for: .valueChanged)
        motionSwitch.isEnabled = false
        motionSwitch.alpha = 0
        
        if UserDefaults.standard.string(forKey: "controls") == "buttons" {
            motionSwitch.selectedSegmentIndex = 1
        } else {
            motionSwitch.selectedSegmentIndex = 0
        }
        
        backgroundLabel.text = "Space Background"
        backgroundLabel.textColor = .green
        backgroundLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        backgroundLabel.textAlignment = .left
        backgroundLabel.numberOfLines = 0
        backgroundLabel.alpha = 0
        
        backgroundSwitch.selectedSegmentTintColor = segmentColor
        backgroundSwitch.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        backgroundSwitch.addTarget(self, action: #selector(backgroundChanged(_:)), for: .valueChanged)
        backgroundSwitch.isEnabled = false
        backgroundSwitch.alpha = 0
        
        switch UserDefaults.standard.string(forKey: "background") {
        case "dim": backgroundSwitch.selectedSegmentIndex = 1
        case "on": backgroundSwitch.selectedSegmentIndex = 2
        default: backgroundSwitch.selectedSegmentIndex = 0
        }
        
        goButton.addTarget(self, action: #selector(go), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueDialogue), for: .touchUpInside)
        
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
        let topPadding = (window?.safeAreaInsets.top ?? 0)

        gradient.frame = CGRect(x: 0, y: -topPadding, width: view.bounds.width, height: view.bounds.height + topPadding)
        gradient.colors = coloursFromTime(time: .Daytime)

        view.layer.insertSublayer(gradient, at: 0)
        
        cloudOne.layer.magnificationFilter = .nearest
        cloudTwo.layer.magnificationFilter = .nearest
        
        var goConfig = UIButton.Configuration.filled()
        goConfig.attributedTitle = AttributedString("Take Off", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 30, weight: .bold)]))
        goConfig.baseForegroundColor = .black
        goConfig.baseBackgroundColor = .white
        goConfig.cornerStyle = .capsule
        
        var aboutConfig = UIButton.Configuration.gray()
        aboutConfig.attributedTitle = AttributedString("Made with ❤️ by David Mazzeo.", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 17, weight: .bold)]))
        aboutConfig.baseForegroundColor = .white
        aboutConfig.cornerStyle = .capsule
        
        var continueConfig = UIButton.Configuration.gray()
        continueConfig.attributedTitle = AttributedString("Continue", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 30, weight: .bold)]))
        continueConfig.baseForegroundColor = .white
        continueConfig.baseBackgroundColor = .systemGreen
        continueConfig.cornerStyle = .capsule
        
        goButton.configuration = goConfig
        aboutButton.configuration = aboutConfig
        continueButton.configuration = continueConfig
        
        continueButton.isEnabled = false
        
        rotateLabel.text = "Please rotate your device to portrait mode."
        rotateLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        rotateLabel.textColor = .white
        rotateLabel.textAlignment = .center
        
        view.addSubview(goButton)
        view.addSubview(wordmark)
        view.addSubview(aboutButton)
        view.addSubview(starView)
        
        cloudView.addSubview(cloudOne)
        cloudView.addSubview(cloudTwo)
        view.addSubview(cloudView)
        
        view.addSubview(tvScreen)
        view.addSubview(continueButton)
        view.addSubview(dialogueView)
        
        view.addSubview(settingsLabel)
        view.addSubview(settingsDescription)
        view.addSubview(motionLabel)
        view.addSubview(motionSwitch)
        view.addSubview(backgroundLabel)
        view.addSubview(backgroundSwitch)
        
        view.addSubview(spriteKitView)
        view.addSubview(rotateLabel)
        
        goButton.translatesAutoresizingMaskIntoConstraints = false
        wordmark.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        spriteKitView.translatesAutoresizingMaskIntoConstraints = false
        starView.translatesAutoresizingMaskIntoConstraints = false
        cloudView.translatesAutoresizingMaskIntoConstraints = false
        cloudOne.translatesAutoresizingMaskIntoConstraints = false
        cloudTwo.translatesAutoresizingMaskIntoConstraints = false
        tvScreen.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        dialogueView.translatesAutoresizingMaskIntoConstraints = false
        rotateLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsDescription.translatesAutoresizingMaskIntoConstraints = false
        motionLabel.translatesAutoresizingMaskIntoConstraints = false
        motionSwitch.translatesAutoresizingMaskIntoConstraints = false
        backgroundLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30).isActive = true
        goButton.heightAnchor.constraint(equalToConstant: 66).isActive = true
        goButton.widthAnchor.constraint(equalToConstant: 161).isActive = true
        
        wordmark.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        wordmark.widthAnchor.constraint(equalToConstant: 496).isActive = true
        wordmark.heightAnchor.constraint(equalToConstant: 150).isActive = true
        wordmark.bottomAnchor.constraint(equalTo: goButton.topAnchor, constant: 20).isActive = true
        
        aboutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aboutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        spriteKitView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        spriteKitView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spriteKitView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spriteKitView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        starView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        starView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        starView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        starView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        cloudView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cloudView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        cloudView.widthAnchor.constraint(equalToConstant: 5490).isActive = true
        cloudView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        cloudOne.topAnchor.constraint(equalTo: cloudView.topAnchor).isActive = true
        cloudOne.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor).isActive = true
        cloudOne.leftAnchor.constraint(equalTo: cloudView.leftAnchor).isActive = true
        cloudOne.widthAnchor.constraint(equalToConstant: 2745).isActive = true
        cloudOne.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        cloudTwo.topAnchor.constraint(equalTo: cloudView.topAnchor).isActive = true
        cloudTwo.bottomAnchor.constraint(equalTo: cloudView.bottomAnchor).isActive = true
        cloudTwo.leftAnchor.constraint(equalTo: cloudOne.rightAnchor).isActive = true
        cloudTwo.rightAnchor.constraint(equalTo: cloudView.rightAnchor).isActive = true
        cloudTwo.widthAnchor.constraint(equalToConstant: 2745).isActive = true
        cloudTwo.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        tvScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tvScreen.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tvScreen.heightAnchor.constraint(equalToConstant: 20).isActive = true
        tvScreen.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        settingsLabel.topAnchor.constraint(equalTo: dialogueView.topAnchor).isActive = true
        settingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        settingsDescription.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 16).isActive = true
        settingsDescription.leftAnchor.constraint(equalTo: dialogueView.leftAnchor).isActive = true
        settingsDescription.rightAnchor.constraint(equalTo: dialogueView.rightAnchor).isActive = true
        
        motionLabel.topAnchor.constraint(equalTo: settingsDescription.bottomAnchor, constant: 30).isActive = true
        motionLabel.leftAnchor.constraint(equalTo: dialogueView.leftAnchor).isActive = true
        
        backgroundLabel.topAnchor.constraint(equalTo: motionSwitch.bottomAnchor, constant: 30).isActive = true
        backgroundLabel.leftAnchor.constraint(equalTo: dialogueView.leftAnchor).isActive = true
        
        motionSwitch.rightAnchor.constraint(equalTo: dialogueView.rightAnchor).isActive = true
        backgroundSwitch.rightAnchor.constraint(equalTo: dialogueView.rightAnchor).isActive = true
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            
            motionSwitch.topAnchor.constraint(equalTo: motionLabel.bottomAnchor, constant: 16).isActive = true
            motionSwitch.leftAnchor.constraint(equalTo: dialogueView.leftAnchor).isActive = true
            
            backgroundSwitch.topAnchor.constraint(equalTo: backgroundLabel.bottomAnchor, constant: 16).isActive = true
            backgroundSwitch.leftAnchor.constraint(equalTo: dialogueView.leftAnchor).isActive = true
            
        } else {
            
            motionSwitch.centerYAnchor.constraint(equalTo: motionLabel.centerYAnchor).isActive = true
            motionSwitch.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
            backgroundSwitch.centerYAnchor.constraint(equalTo: backgroundLabel.centerYAnchor).isActive = true
            backgroundSwitch.widthAnchor.constraint(equalToConstant: 300).isActive = true
            
        }
        
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 66).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 198).isActive = true
        continueButton.topAnchor.constraint(equalTo: dialogueView.bottomAnchor, constant: -30).isActive = true
        
        dialogueView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dialogueView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        textHeightConstraint = dialogueView.heightAnchor.constraint(equalToConstant: 20)
        textWidthConstraint = dialogueView.widthAnchor.constraint(equalToConstant: 20)
        
        textWidthConstraint.isActive = true
        textHeightConstraint.isActive = true
        
        rotateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rotateLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rotateLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rotateLabel.isHidden = true
        
        starView.alpha = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            cycleTime(time: .Evening)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(endGameScene(_:)), name: Notification.Name("endGame"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnToTitle(_:)), name: Notification.Name("returnToTitle"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("endGame"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("returnToTitle"), object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    func initTimer() {
        self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 100, delay: 0, options: [.curveLinear, .repeat], animations: { [self] in
            cloudView.transform = CGAffineTransform(translationX: -2745, y: 0)
        }, completion: { (finished: Bool) in
            self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    override func viewDidLayoutSubviews() {
        gradient.frame = CGRect(x: 0, y: -50, width: view.frame.width, height: view.frame.height + 100)
        
        starView.backgroundColor = UIColor(patternImage: UIImage(named: "Star Pattern.png")!)
        let starGradient = CAGradientLayer()
        
        starGradient.frame = starView.bounds
        starGradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        starGradient.startPoint = CGPointMake(0, 0.8)
        starGradient.endPoint = CGPointMake(0, 1)
        
        starView.layer.mask = starGradient
    }
    
    func cycleTime(time: Time, express: Bool = false) {
        
        CATransaction.begin()
        
        var duration = CFTimeInterval(10)
        
        if express {
            duration = 2
        }

        let oldColours = gradient.colors
        let newColours = coloursFromTime(time: time)
        
        gradient.colors = newColours
        
        let animation = CABasicAnimation(keyPath: "colors")

        animation.fromValue = oldColours
        animation.toValue = newColours
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.delegate = self
        
        if time == .Night {
            UIView.animate(withDuration: duration) { [self] in
                starView.alpha = 1
            }
        }
        
        if time == .Sunrise {
            UIView.animate(withDuration: duration) { [self] in
                starView.alpha = 0
            }
        }
        
        CATransaction.setCompletionBlock { [self] in
            if time == .Daytime || time == .Night {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                    if areAnimationsRunning {
                        if time == .Daytime {
                            cycleTime(time: .Evening)
                        } else {
                            cycleTime(time: .Sunrise)
                        }
                    }
                }
                
            } else {
                if areAnimationsRunning {
                    switch time {
                    case .Sunrise: cycleTime(time: .Daytime)
                    case .Evening: cycleTime(time: .Night)
                    default: break
                    }
                }
            }
        }

        gradient.add(animation, forKey: "animateGradient")
        CATransaction.commit()
    }
    
    func coloursFromTime(time: Time) -> [CGColor] {
        switch time {
        case .Sunrise: return [CGColor(red: 100/255,
                                       green: 210/255,
                                       blue: 255/255, alpha: 1),
                               CGColor(red: 255/255,
                                       green: 159/255,
                                       blue: 10/255, alpha: 1)]
        // Teal to Blue
        case .Daytime: return [CGColor(red: 64/255,
                                       green: 200/255,
                                       blue: 224/255, alpha: 1),
                               CGColor(red: 10/255,
                                       green: 132/255,
                                       blue: 255/255, alpha: 1)]
        // Pink to Orange
        case .Evening: return [CGColor(red: 255/255,
                                       green: 55/255,
                                       blue: 95/255, alpha: 1),
                               CGColor(red: 255/255,
                                       green: 159/255,
                                       blue: 10/255, alpha: 1)]
        // Black to Indigo
        case .Night: return [CGColor(red: 0/255,
                                     green: 0/255,
                                     blue: 0/255, alpha: 1),
                             CGColor(red: 44/255,
                                     green: 43/255,
                                     blue: 107/255, alpha: 1)]
        }
    }
    
    @objc func endGameScene(_ notification: Notification) {
        areAnimationsRunning = true
        tvScreen.isHidden = true
        
        continueButton.alpha = 0
        settingsLabel.alpha = 0
        settingsDescription.alpha = 0
        motionLabel.alpha = 0
        motionSwitch.alpha = 0
        backgroundLabel.alpha = 0
        backgroundSwitch.alpha = 0
        
        textWidthConstraint.constant = 20
        textHeightConstraint.constant = 20
        
        starView.alpha = 0
        gradient.removeAllAnimations()
        gradient.colors = coloursFromTime(time: .Daytime)
        
        spriteKitView.isHidden = false
        
        isListeningForOrientation = true
        orientation = UIInterfaceOrientation(rawValue: (UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.windowScene?.interfaceOrientation.rawValue ?? 0))!
        rotationCheck(isViewInitialising: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            initTimer()
        }
    }
    
    @objc func returnToTitle(_ notification: Notification) {
        isListeningForOrientation = false
        spriteKitView.presentScene(nil)
        spriteKitView.isHidden = true
        spriteKitView.removeFromSuperview()
        cycleTime(time: .Evening)
        
        wordmark.startAnimating()
        
        UIView.animate(withDuration: 1, animations: { [self] in
            goButton.alpha = 1
            wordmark.alpha = 1
            aboutButton.alpha = 1
        })
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        cloudView.layer.removeAllAnimations()
        self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
        gradient.removeAllAnimations()
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        initTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cloudView.layer.removeAllAnimations()
        self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if isListeningForOrientation {
            orientation = UIInterfaceOrientation(rawValue: (UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first?.windowScene?.interfaceOrientation.rawValue ?? 0))!
            rotationCheck()
        }
    }
    
    func rotationCheck(isViewInitialising: Bool = false) {
        if orientation.isLandscape {
            print("landscape")
            spriteKitView.isPaused = true
            spriteKitView.isHidden = true
            
            rotateLabel.isHidden = false
            
            if isViewInitialising {
                waitingToPresent = true
            }
            
        } else {
            print("portrait")
            spriteKitView.isPaused = false
            spriteKitView.isHidden = false
            
            rotateLabel.isHidden = true
            
            if isViewInitialising {
                spriteKitView.presentScene(CompleteScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
            }
            
            if waitingToPresent {
                spriteKitView.presentScene(CompleteScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
            }
        }
    }
    
}

extension UITextView {
    func characterByCharacter(string: String, complete: @escaping () -> Void) {
        let characters = string.count
        var currentString = ""
        var count = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.00825, repeats: true, block: { [self] timer in
            if count == characters {
                timer.invalidate()
                self.text = currentString
                complete()
            } else {
                let index = string.index(string.startIndex, offsetBy: count)
                currentString.append(string[index])
                self.text = currentString + "█"
                count += 1
            }
        })
        
    }
}
