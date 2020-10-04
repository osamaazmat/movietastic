//
//  LaunchScreenViewController.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import UIKit
import Lottie

class LaunchScreenViewController: BaseViewController {

    var viewModel: LaunchScreenViewModel?
    let animationView = AnimationView()
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
}


// MARK: Private Functions

extension LaunchScreenViewController {
    
    private func setupVC() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ?? "")
        let viewModel               = LaunchScreenViewModel()
        self.viewModel              = viewModel
        self.viewModel?.delegate    = self

        self.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.viewModel?.getMovies()
        }
    }
    
    private func startAnimation() {
        animationView.animation         = Animation.named("main")
        animationView.frame             = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center            = view.center
        animationView.contentMode       = .scaleAspectFit
        animationView.loopMode          = .loop
        animationView.play()
        
        self.view.addSubview(animationView)
    }
}


// MARK: LaunchScreenViewModel Delegate

extension LaunchScreenViewController: LaunchScreenViewModelDelegate {
    func moviesSynced(withMovies movies: [MovieModel]) {
        let mainStoryboard: UIStoryboard        = UIStoryboard(name: "Main", bundle: nil)
        let mainListNav                         = mainStoryboard.instantiateViewController(withIdentifier: "movieListNav") as! UINavigationController
        self.view.window?.rootViewController    = mainListNav
        self.view.window?.makeKeyAndVisible()
    }
}
