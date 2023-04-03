import UIKit

enum Time {
    case Sunrise
    case Daytime
    case Evening
    case Night
}

class ViewController: UIViewController, CAAnimationDelegate {
    
    let gradient = CAGradientLayer()
    @IBOutlet weak var cloudView: UIView!
    @IBOutlet weak var cloudOne: UIImageView!
    @IBOutlet weak var cloudTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: View Initialisation
        
        // Sets up and displays the inital background gradient.
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
        let topPadding = (window?.safeAreaInsets.top ?? 0)

        gradient.frame = CGRect(x: 0, y: -topPadding, width: view.bounds.width, height: view.bounds.height + topPadding)
        gradient.colors = coloursFromTime(time: .Daytime)

        view.layer.insertSublayer(gradient, at: 0)
        
        // Sets image views to upscale with nearest neighbour, optimising them for pixel art.
        cloudOne.layer.magnificationFilter = .nearest
        cloudTwo.layer.magnificationFilter = .nearest
        
        // MARK: Cloud Cover
        Timer.scheduledTimer(withTimeInterval: 100, repeats: true, block: { [self] timer in
            cloudView.transform = CGAffineTransform(translationX: 0, y: 0)
            UIView.animate(withDuration: 100, delay: 0, options: [.curveLinear], animations: { [self] in
                cloudView.transform = CGAffineTransform(translationX: -2745, y: 0)
            })
        }).fire()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            cycleTime(time: .Evening)
        }
        
    }
    
    func cycleTime(time: Time) {
        
        CATransaction.begin()

        let oldColours = gradient.colors
        let newColours = coloursFromTime(time: time)
        
        gradient.colors = newColours
        
        let animation = CABasicAnimation(keyPath: "colors")

        animation.fromValue = oldColours
        animation.toValue = newColours
        animation.duration = 10
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.delegate = self
        
        CATransaction.setCompletionBlock { [self] in
            if time == .Daytime || time == .Night{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
                    if time == .Daytime {
                        cycleTime(time: .Evening)
                    } else {
                        cycleTime(time: .Sunrise)
                    }
                }
                
            } else {
                
                switch time {
                    case .Sunrise: cycleTime(time: .Daytime)
                    case .Evening: cycleTime(time: .Night)
                    default: break
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
    
}
