//
//  LaunchScreenViewModel.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import Foundation

protocol LaunchScreenViewModelDelegate {
    func moviesSynced(withMovies movies: [MovieModel])
}

class LaunchScreenViewModel: NSObject {
    var delegate: LaunchScreenViewModelDelegate?
}

extension LaunchScreenViewModel {
    
    func logUserEndDay() {
        UserDefaults.standard.setValue(Date().endOfDay, forKey: "userLoginEndDay")
    }
    
    func getMovies() {
        if let date = UserDefaults.standard.object(forKey: "userLoginEndDay") as? Date {
            if Date().endOfDay > date {
                MovieService.sharedInstance.syncMoviesWithServer { (movies) in
                    self.delegate?.moviesSynced(withMovies: movies)
                }
            }
            else {
                logUserEndDay()
                MovieService.sharedInstance.syncMoviesWithServer { (movies) in
                    self.delegate?.moviesSynced(withMovies: movies)
                }
            }
        }
        else {
            logUserEndDay()
            MovieService.sharedInstance.syncMoviesWithServer { (movies) in
                self.delegate?.moviesSynced(withMovies: movies)
            }
        }
    }
    
}
