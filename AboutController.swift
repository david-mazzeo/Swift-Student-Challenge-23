//
//  AboutController.swift
//  Interstellar
//
//  Created by David Mazzeo on 19/4/2023.
//

import UIKit

class AboutController: UIViewController {
    
    let wordmarkImages = [UIImage(named: "Wordmark 1.png")!,
                          UIImage(named: "Wordmark 2.png")!,
                          UIImage(named: "Wordmark 3.png")!,
                          UIImage(named: "Wordmark 4.png")!,
                          UIImage(named: "Wordmark 5.png")!,
                          UIImage(named: "Wordmark 6.png")!,
                          UIImage(named: "Wordmark 7.png")!,
                          UIImage(named: "Wordmark 8.png")!]
    
    let icon = UIImageView()
    let about = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        icon.image = UIImage(named: "512px Rounded Icon")
        icon.contentMode = .scaleAspectFit
        
        about.backgroundColor = .clear
        about.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        about.numberOfLines = 0
        about.text = "Thank you for playing Interstellar! Have a great WWDC23!"
        
        view.addSubview(icon)
        view.addSubview(about)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        about.translatesAutoresizingMaskIntoConstraints = false
        
        icon.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        icon.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        about.centerYAnchor.constraint(equalTo: icon.centerYAnchor).isActive = true
        about.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 20).isActive = true
        about.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
    
}
