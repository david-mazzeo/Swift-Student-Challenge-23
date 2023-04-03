import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cloudView: UIView!
    @IBOutlet weak var cloudOne: UIImageView!
    @IBOutlet weak var cloudTwo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: View Initialisation
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
        
    }
    
}
