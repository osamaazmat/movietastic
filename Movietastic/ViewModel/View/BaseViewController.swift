//
//  BaseViewController.swift
//  Movietastic
//
//  Created by Macbook Pro on 04/10/2020.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {

    // MARK: Variables And Outlets
    
    let loadingAnimation = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}


// MARK: Reusable Methods

extension BaseViewController {
    func startLoading() {
        loadingAnimation.animation         = Animation.named("main")
        loadingAnimation.frame             = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingAnimation.center            = view.center
        loadingAnimation.contentMode       = .scaleAspectFit
        loadingAnimation.loopMode          = .loop
        loadingAnimation.play()
        
        self.view.addSubview(loadingAnimation)
    }
    
    func stopLoading() {
        self.loadingAnimation.removeFromSuperview()
        self.loadingAnimation.stop()
    }
}
