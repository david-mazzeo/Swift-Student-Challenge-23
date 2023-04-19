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
    var areAnimationsRunning = true
    
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
    
    var spriteKitView = SKView()
    
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
                    When disaster began to loom, however, a researcher discovered an Ancient Greek myth suggesting the existence of spirits living in the constellations. These findings were presented to the space administration, who begrudgingly approved a flight to the constellation of rebirth — the Phoenix — to acquire a "rebirth" of their home. Such a journey would drain the last of Lunaro's energy supply, turning this into an extremely high-stakes mission.
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
            let vc = SpaceFlightController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                view.layer.removeAllAnimations()
                gradient.removeAllAnimations()
                cloudView.layer.removeAllAnimations()
                self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
                dialogueView.text = ""
                areAnimationsRunning = false
            }
        default: break
        }
        
        currentDialogueStage += 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        dialogueView.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        dialogueView.textColor = .green
        dialogueView.backgroundColor = .clear
        
        cloudOne.image = UIImage(named: "Day Clouds")
        cloudTwo.image = UIImage(named: "Day Clouds")
        
        tvScreen.isHidden = true
        tvScreen.image = UIImage(named: "Tall CRT Shape")
        
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
        view.addSubview(spriteKitView)
        
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
        dialogueView.isHidden = true
        tvScreen.isHidden = true
        continueButton.isHidden = true
        
        starView.alpha = 0
        gradient.removeAllAnimations()
        gradient.colors = coloursFromTime(time: .Daytime)
        spriteKitView.isHidden = false
        spriteKitView.presentScene(CompleteScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)))
    }
    
    @objc func returnToTitle(_ notification: Notification) {
        spriteKitView.presentScene(nil)
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
    
    override func viewDidAppear(_ animated: Bool) {
        if cloudView.layer.animationKeys()?.isEmpty == true || cloudView.layer.animationKeys() == nil {
            initTimer()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cloudView.layer.removeAllAnimations()
        self.cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
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
